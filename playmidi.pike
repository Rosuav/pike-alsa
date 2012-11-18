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
				case 0x00..0x7F: return 0; //Error - status byte expected. Running status with no previous status.
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
				case 0xF0: case 0xF7: return 0; //SysEx not currently supported
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

int main(int argc,array(string) argv)
{
	array(array(string|array(array(int|string)))) chunks=parsesmf(Stdio.read_file(argv[1]));
	sscanf(chunks[0][1],"%2c%*2c%2c",int type,int timediv); //timediv == ticks per quarter note
	//if (time_division&0x8000) //it's SMPTE timing?
	write("Time division: %d\n",timediv);
	int tempo=500000,bpm=120;
	float time_division=tempo*.000001/timediv;
	object alsa=load_module("./module.so")->Alsa();
	array(string|int) ports=alsa->list_ports();
	write("Ports available:\n%{%3d:%-3d  %-32.32s %s\n%}",ports);
	write("set_port: %O\n",alsa->set_port(24,1));
	write("get_port:%{ %d%}\n",alsa->get_port());
	chunks=column(chunks[1..],1);
	array(int) chunkptr=allocate(sizeof(chunks));
	int tsnum,tsdem,metronome,barlen;
	int bar=0,beat=0,pos=0,tick_per_beat=timediv,tick_per_bar=timediv*4;
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
				write(" [%3d bpm] %d : %d %s\r",bpm,bar,beat,beat?"        ":"---     ");
			}
			if (firstev)
			{
				//write("Tick %d\n",firstev);
				sleep(firstev*time_division);
				pos+=firstev;
			}
			write(" [%3d bpm] %d : %d %s\r",bpm,bar,beat,beat?"        ":"---     ");
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
					break;
				case 0x58:
					sscanf(ev[3],"%c%c%c%c",tsnum,tsdem,metronome,barlen);
					//write("TIMESIG. %d/%d, met %d, bar %d (norm 8)\n",tsnum,1<<tsdem,metronome,barlen);
					if (tsdem<2) tick_per_beat=timediv*4/(1<<tsdem); else tick_per_beat=timediv/(1<<(tsdem-2));
					tick_per_bar=tick_per_beat*tsnum;
					break;
				case 0x2f: chunkptr[track]=sizeof(chunks[track]); break; //End of track. Ignore anything after it.
			}
			break;
		}
	}
		
	alsa->wait();
	write("Done!\n");
}
