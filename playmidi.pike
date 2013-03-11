//Parse the first byte(s) of data and return a variable-length integer and the remaining data. Not the fastest algorithm but it's cool :)
array(int|string) getvarlen(string data)
{
	sscanf(data,"%[\x80-\xFF]%c%s",string extralen,int len,data);
	sscanf(sprintf("%{%7.7b%}%07b",(array(int))extralen,len),"%b",len);
	return ({len,data});
}

//Parse a Standard MIDI File and return an array of chunks
//Each chunk has its four-letter type, and then either a string of content or an array of messages.
//Each message is an array of integers or strings: ({int delay, int command, int|string ... parameters)}
//The parameters are normally integers, but meta events may use strings.
array(array(string|array(array(int|string)))) parsesmf(string data)
{
	sscanf(data,"%{%4s%4H%}",array(array(string|array(array(int|string)))) chunks); //Now *that's* a REAL variable declaration. Hehe! :)
	if (!chunks || !sizeof(chunks) || chunks[0][0]!="MThd") return 0; //Not a valid MIDI file
	foreach (chunks,array(string|array(array(int|string))) chunk)
	{
		if (chunk[0]!="MTrk") continue;
		array(array(int|string)) events=({ });
		string data=[string]chunk[1];
		int command=0;
		while (data!="")
		{
			[int delay,data]=getvarlen(data);
			if (data[0]>=128) {command=data[0]; data=data[1..];} //If it isn't, retain running status. Note that information is not retained as to the use of running status.
			array(int|string) ev=({delay,command});
			switch (command)
			{
				case 0x00..0x7F: error("Status byte expected. Running status with no previous status.\n");
				case 0x80..0x8F: //Note off
				case 0x90..0x9F: //Note on
				case 0xA0..0xAF: //Note aftertouch
				case 0xB0..0xBF: //Controller
				case 0xE0..0xEF: //Pitch bend
				case 0xF2: //Song Position
					//Two data bytes for these
					ev+=({data[0],data[1]});
					data=data[2..];
					break;
				case 0xC0..0xCF: //Program change
				case 0xD0..0xDF: //Channel aftertouch
				case 0xF3:
					//One data byte.
					ev+=({data[0]});
					data=data[1..];
					break;
				case 0xF1: case 0xF4..0xF6: case 0xF8..0xFE: //System Common various
					//No data bytes.
					break;
				case 0xF0: case 0xF7: break; //SysEx not currently supported
				case 0xFF: //Meta event
					[int type,int len,data]=({data[0],@getvarlen(data[1..])});
					string meta=data[..len-1]; data=data[len..];
					ev+=({type,meta});
					break;
			}
			events+=({ev});
		}
		chunk[1]=events;
	}
	return chunks;
}

mapping args;
object alsa;
GTK2.Widget mainwindow,lyrics,status;
string lyrictxt="";

int main(int argc,array(string) argv)
{
	args=Arg.parse(argv);
	alsa=Public.Sound.ALSA.ALSA();
	write("Ports available:\n%{%3d:%-3d  %-32.32s %s\n%}",alsa->list_ports());
	if (!sizeof(args[Arg.REST]) || !args->port) exit(0,"USAGE: pike playmidi.pike [-X] --port=NN:N midifile.mid\n");
	sscanf(args->port,"%d:%d",int client,int port);
	alsa->set_port(client,port);
	if (!args->X) playmidis(); //Easy, just do it synchronously. (It won't return.)
	//Otherwise, create a window - which has to be done on the main thread, it seems.
	GTK2.setup_gtk();
	mainwindow=GTK2.Window(GTK2.WindowToplevel);
	mainwindow->set_title("PikeMidi Display");
	mainwindow->add(GTK2.Vbox(0,0)
		->add(status=GTK2.Label("status goes here")->set_size_request(-1,20)->set_alignment(0.0,0.0))
		->add(lyrics=GTK2.Label("lyrics go here"))
	)->show_all();
	thread_create(playmidis);
	return -1;
}

void playmidis() {foreach (args[Arg.REST],string fn) {playmidi(fn); alsa->reset(); alsa->wait(); sleep(1);} exit(0);}

void playmidi(string fn)
{
	array(array(string|array(array(int|string)))) chunks=parsesmf(Stdio.read_file(fn));
	lyrictxt="";
	if (lyrics) {mainwindow->resize(1,1); lyrics->set_text(fn);}
	int lyricsraw=0;
	sscanf(chunks[0][1],"%2c%*2c%2c",int type,int timediv); //timediv == ticks per quarter note
	//if (time_division&0x8000) //it's SMPTE timing?
	//write("Time division: %d\n",timediv);
	int tempo=500000,bpm=120;
	float time_division=tempo*.000001/timediv;
	//write("get_port:%{ %d%}\n",alsa->get_port());
	chunks=column(chunks[1..],1);
	array(int) chunkptr=allocate(sizeof(chunks));
	int tsnum,tsdem,metronome,barlen;
	int bar=0,beat=0,pos=0,tick_per_beat=timediv,tick_per_bar=timediv*4;
	string info=sprintf("%3d bpm, %d %d",bpm,tsnum,1<<tsdem);
	function showstatus=args->X?lambda() {status->set_text(sprintf(" [%s] %d : %d %s\r",info,bar,beat,beat?"        ":"---     "));}
		:lambda() {write(" [%s] %d : %d %s\r",info,bar,beat,beat?"        ":"---     ");};
	while (1)
	{
		int firstev=1<<30,track=-1;
		foreach (chunks;int i;array chunk) if (chunkptr[i]<sizeof(chunk))
		{
			int tm=chunk[chunkptr[i]][0];
			if (tm<firstev) {firstev=tm; track=i;} //Note that it has to be _lower_, meaning that earlier tracks take precedence over later ones.
		}
		if (track==-1) break; //No more events!
		if (firstev)
		{
			foreach (chunks;int i;array chunk) if (chunkptr[i]<sizeof(chunk)) chunk[chunkptr[i]][0]-=firstev;
			//write("Sleeping %d [%f]\n",firstev,firstev*time_division);
			while (pos+firstev>=tick_per_beat)
			{
				//write("Tick %d/%d leaving %d\n",tick_per_beat-pos,firstev,firstev-(tick_per_beat-pos));
				sleep((tick_per_beat-pos)*time_division);
				firstev-=tick_per_beat-pos;
				pos=0; if (++beat==tsnum) {beat=0; ++bar;}
				showstatus();
			}
			if (firstev)
			{
				//write("Tick %d\n",firstev);
				sleep(firstev*time_division);
				pos+=firstev;
			}
			showstatus();
		}
		array ev=chunks[track][chunkptr[track]++];
		switch (ev[1])
		{
			case 0x80..0x8f: alsa->note_off(	ev[1]&0xf,ev[2],ev[3]); break;
			case 0x90..0x9f: alsa->note_on(		ev[1]&0xf,ev[2],ev[3]); break;
			case 0xa0..0xaf: alsa->note_pressure(	ev[1]&0xf,ev[2],ev[3]); break;
			case 0xb0..0xbf: alsa->controller(	ev[1]&0xf,ev[2],ev[3]); break;
			case 0xc0..0xcf: alsa->prog_chg(	ev[1]&0xf,ev[2]); break;
			case 0xd0..0xdf: alsa->chan_pressure(	ev[1]&0xf,ev[2]); break;
			case 0xe0..0xef: alsa->pitch_bend(	ev[1]&0xf,(ev[2]|(ev[3]<<7))-0x2000); break;
			case 0xff: switch (ev[2])
			{
				case 0x51: //tempo = microseconds per quarter note
					sscanf(ev[3],"%3c",tempo);
					time_division=tempo*.000001/timediv;
					bpm=60000000/tempo;
					info=sprintf("%3d bpm, %d %d",bpm,tsnum,1<<tsdem);
					break;
				case 0x58:
					sscanf(ev[3],"%c%c%c%c",tsnum,tsdem,metronome,barlen);
					//write("TIMESIG. %d/%d, met %d, bar %d (norm 8)\n",tsnum,1<<tsdem,metronome,barlen);
					if (tsdem<2) tick_per_beat=timediv*4/(1<<tsdem); else tick_per_beat=timediv/(1<<(tsdem-2));
					tick_per_bar=tick_per_beat*tsnum;
					info=sprintf("%3d bpm, %d %d",bpm,tsnum,1<<tsdem);
					break;
				case 0x2f: chunkptr[track]=sizeof(chunks[track]); break; //End of track. Ignore anything after it.
				case 0x05: if (lyrics)
				{
					string ly=ev[3];
					if (!lyricsraw)
					{
						if (ly[-1]=='-') ly=ly[..<1];
						else if (ly[-1]==' ') lyricsraw=1; //Some MIDI files have lyrics already parsed in this way, some don't. I don't know how I'm supposed to recognize which is which.
						else ly+=" ";
					}
					lyrics->set_text(lyrictxt+=ly);
				}
				break;
			}
			break;
		}
	}
	alsa->wait();
}
