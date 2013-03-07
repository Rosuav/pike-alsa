array(string) patchnames=map(Array.transpose(array_sscanf(#"
0x00 Acoustic Grand Piano     0x2B Contrabass          0x56 Lead 7 (fifths)
0x01 Bright Acoustic Piano    0x2C Tremolo Strings     0x57 Lead 8 (bass+lead
0x02 Electric Grand Piano     0x2D Pizzicato Strings   0x58 Pad 1 (new age)
0x03 Honky-tonk Piano         0x2E Orchestral Harp     0x59 Pad 2 (warm)
0x04 Electric Piano 1         0x2F Timpani             0x5A Pad 3 (polysynth)
0x05 Electric Piano 2         0x30 String Ensemble 1   0x5B Pad 4 (choir)
0x06 Harpsichord              0x31 String Ensemble 2   0x5C Pad 5 (bowed)
0x07 Clavinet                 0x32 SynthStrings 1      0x5D Pad 6 (metallic)
0x08 Celesta                  0x33 SynthStrings 2      0x5E Pad 7 (halo)
0x09 Glockenspiel             0x34 Choir Aahs          0x5F Pad 8 (sweep)
0x0A Music Box                0x35 Voice Oohs          0x60 FX 1 (train)
0x0B Vibraphone               0x36 Synth Voice         0x61 FX 2 (soundtrack)
0x0C Marimba                  0x37 Orchestra Hit       0x62 FX 3 (crystal)
0x0D Xylophone                0x38 Trumpet             0x63 FX 4 (atmosphere)
0x0E Tubular Bells            0x39 Trombone            0x64 FX 5 (brightness)
0x0F Dulcimer                 0x3A Tuba                0x65 FX 6 (goblins)
0x10 Drawbar Organ            0x3B Muted Trumpet       0x66 FX 7 (echoes)
0x11 Percussive Organ         0x3C French Horn         0x67 FX 8 (sci-fi)
0x12 Rock Organ               0x3D Brass Section       0x68 Sitar
0x13 Church Organ             0x3E Synth Brass 1       0x69 Banjo
0x14 Reed Organ               0x3F Synth Brass 2       0x6A Shamisen
0x15 Accordion                0x40 Soprano Sax         0x6B Koto
0x16 Harmonica                0x41 Alto Sax            0x6C Kalimba
0x17 Tango Accordion          0x42 Tenor Sax           0x6D Bagpipe
0x18 Acoustic Guitar (nylon)  0x43 Baritone Sax        0x6E Fiddle
0x19 Acoustic Guitar (steel)  0x44 Oboe                0x6F Shanai
0x1A Electric Guitar (jazz)   0x45 English Horn        0x70 Tinkle Bell
0x1B Electric Guitar (clean)  0x46 Bassoon             0x71 Agogo
0x1C Electric Guitar (muted)  0x47 Clarinet            0x72 Steel Drums
0x1D Overdriven Guitar        0x48 Piccolo             0x73 Woodblock
0x1E Distortion Guitar        0x49 Flute               0x74 Tailo Drum
0x1F Guitar Harmonics         0x4A Recorder            0x75 Melodic Drum
0x20 Acoustic Bass            0x4B Pan Flute           0x76 Synth Drum
0x21 Electric Bass (finger)   0x4C Blown Bottle        0x77 Reverse Cymbal
0x22 Electric Bass (pick)     0x4D Shakuhachi          0x78 Guitar Fret Noise
0x23 Fretless Bass            0x4E Whistle             0x79 Breath Noise
0x24 Slap Bass 1              0x4F Ocarina             0x7A Seashore
0x25 Slap Bass 2              0x50 Lead 1 (square)     0x7B Bird Tweet
0x26 Synth Bass 1             0x51 Lead 2 (sawtooth)   0x7C Telephone Ring
0x27 Synth Bass 2             0x52 Lead 3 (calliope)   0x7D Helicopter
0x28 Violin                   0x53 Lead 4 (chiff)      0x7E Applause
0x29 Viola                    0x54 Lead 5 (charang)    0x7F Gunshot
0x2A Cello                    0x55 Lead 6 (voice)      0x80 end of list
","\n%{0x%*2c %s 0x%*2c %s 0x%*2c %s\n%}")*({ }))*({ }),String.trim_all_whites)[..<1];

class PianoKeyboard
{
	inherit GTK2.DrawingArea;
	multiset(int) notes=(<>); //Set of all notes currently active (eg playing) - normally use set_note() to alter it
	//Black notes are drawn from y=0 to y=10; white notes get y=12 to y=24.
	array(int) xpos=({0,2,4,6,8,12,14,16,18,20,22,24,28}); //Thirteenth entry to complete the cycle; is the X offset applied per octave.
	array(int) isblack=({0,1,0,1,0,0,1,0,1,0,1,0});
	void create(mapping|void props)
	{
		::create(props||([]));
		set_size_request((128/12)*xpos[-1]+xpos[128%12]+4,25);
		signal_connect("expose-event",redraw);
	}

	void redraw()
	{
		object g=GDK2.GC(this)->set_foreground(GDK2.Color(0,160,255));
		for (int i=0;i<128;++i)
		{
			int x=(i/12)*xpos[-1]+xpos[i%12];
			int y1,y2;
			if (isblack[i%12]) {y1=0; y2=10;} else {y1=12; y2=12;}
			draw_rectangle(g,notes[i],x,y1,4,y2);
		}
	}

	void set_note(int note,int status) //If status is nonzero, note is playing.
	{
		notes[note]=status;
		queue_draw();
	}
}

mapping args;
object alsa;
object parser=(object)"playmidi.pike"; //Grab some utility functions. TODO: Put them into a proper module or something.
function parsesmf=parser->parsesmf;
GTK2.Widget mainwindow,lyrics,status,position;
array(GTK2.Widget) piano=allocate(16),channame=allocate(16),chanpatch=allocate(16);
string lyrictxt="";
Thread.Thread midithrd;

//Helper function to build the toggle buttons. Half-brightness for unselected, full for selected.
GTK2.ToggleButton toggle(int r,int g,int b,mixed ... onclick)
{
	GTK2.ToggleButton obj=GTK2.ToggleButton()
		->modify_bg(GTK2.STATE_NORMAL,GTK2.GdkColor(r/2,g/2,b/2))
		->modify_bg(GTK2.STATE_PRELIGHT,GTK2.GdkColor(r/2,g/2,b/2))
		->modify_bg(GTK2.STATE_ACTIVE,GTK2.GdkColor(r,g,b));
	obj->signal_connect("toggled",@onclick);
	return obj;
}

//Helper function to create a button and attach an event
GTK2.Button Button(string|mapping props,mixed ... onclick)
{
	GTK2.Button obj=GTK2.Button(props);
	obj->signal_connect("clicked",@onclick);
	return obj;
}

void silence(int chan) //Mute all currently-playing notes on any channel
{
	foreach (indices(piano[chan]->notes),int note) {alsa->note_off(chan,note,64); piano[chan]->set_note(note,0);}
}
void hush() {for (int i=0;i<16;++i) silence(i);} //... or on all channels

array(int) muted=allocate(16),soloed=allocate(16);
int anysolo; //If nonzero, channels not listed in soloed get their velocities cut
void mute(object self,int chan)
{
	if (muted[chan]=!muted[chan]) silence(chan);
}
void solo(object self,int chan)
{
	soloed[chan]=!soloed[chan]; anysolo=`+(@soloed);
}

int paused;
object pausemtx=Thread.Mutex();
object pausecond=Thread.Condition();
void pause()
{
	if (paused=!paused) hush();
	else pausecond->signal();
}
void stop()
{
	for (int i=0;i<16;++i) silence(i);
	exit(0); //Or maybe not. I don't know.
}
int skiptrack=0;
void skip() {skiptrack=1;}

int main(int argc,array(string) argv)
{
	args=Arg.parse(argv);
	alsa=Public.Sound.ALSA.ALSA();
	write("Ports available:\n%{%3d:%-3d  %-32.32s %s\n%}",alsa->list_ports());
	if (!sizeof(args[Arg.REST]) || !args->port) exit(0,"USAGE: pike karaoke.pike --port=NN:N midifile.mid [midifile...]\n");
	sscanf(args->port,"%d:%d",int client,int port);
	alsa->set_port(client,port);
	GTK2.setup_gtk();
	mainwindow=GTK2.Window(GTK2.WindowToplevel);
	mainwindow->set_title("Pi-karao-ke Display");
	GTK2.Table table=GTK2.Table(0,0,0)->set_col_spacings(5)->set_row_spacings(5);
	for (int i=0;i<sizeof(piano);++i) table
		->attach_defaults(channame[i] =GTK2.Label()->set_alignment(0.0,0.5),	0,1,i+1,i+2)
		->attach_defaults(chanpatch[i]=GTK2.Label()->set_alignment(1.0,0.5),	1,2,i+1,i+2)
		->attach_defaults(piano[i]=PianoKeyboard(),				2,3,i+1,i+2)
		->attach_defaults(toggle(255,0,0,mute,i),				3,4,i+1,i+2)
		->attach_defaults(toggle(0,255,255,solo,i),				4,5,i+1,i+2)
	;
	mainwindow->add(table
		->attach_defaults(status=GTK2.Label("status goes here")->set_size_request(-1,20)->set_alignment(0.0,0.0),0,5,0,1)
		->attach_defaults(lyrics=GTK2.Label("lyrics go here"),0,5,17,18)
		->attach_defaults(position=GTK2.Hscale(GTK2.Adjustment())->unset_flags(GTK2.CanFocus),0,5,18,19)
		->attach_defaults(GTK2.HbuttonBox()
			->add(Button("Play/pause",pause))
			->add(Button("Stop",stop))
			->add(Button("Skip track",skip))
		,0,5,19,20)
	)->show_all();
	midithrd=thread_create(playmidis);
	return -1;
}

void playmidis() {foreach (args[Arg.REST],string fn) {playmidi(fn); hush(); alsa->reset(); alsa->wait(); sleep(1);} exit(0);}

void playmidi(string fn)
{
	skiptrack=0;
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
	int abspos=0; //Absolute position, effectively bar+beat+pos
	string info=sprintf("%3d bpm, %d %d",bpm,tsnum,1<<tsdem);
	function showstatus=lambda() {status->set_text(sprintf(" [%s] %d : %d %s\r",info,bar,beat,beat?"        ":"---     ")); position->set_value(abspos*time_division); while (paused) pausecond->wait(pausemtx->lock());};
	int lyrtrack=-1;
	int maxlyr=0;
	array(int) chan=({-1})*sizeof(chunks); //Associate channel numbers with chunks, for the benefit of the track-name labels
	//First pass over the content: Flatten the chunks to a single stream of events.
	int maxlen=0; float seconds=0;
	foreach (chunks;int i;array chunk)
	{
		int len=0,lyr=0;
		foreach (chunk;int j;array ev)
		{
			len+=ev[0]; if (len>maxlen) {seconds+=(len-maxlen)*time_division; maxlen=len;}
			if (ev[1]<0xf0) chan[i]=ev[1]&15;
			if (ev[1]==0xff) switch (ev[2])
			{
				case 0x05: ++lyr; break;
				case 0x51:
					sscanf(ev[3],"%3c",tempo);
					time_division=tempo*.000001/timediv;
					break;
			}
		}
		if (lyr>maxlyr) {maxlyr=lyr; lyrtrack=i;} //Uncomment to take lyrics from only the track that has the most. This gives the best results in many cases.
	}
	position->set_range(0,seconds);
	while (1)
	{
		if (skiptrack) break;
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
				int wait=tick_per_beat-pos;
				sleep(wait*time_division);
				firstev-=wait;
				abspos+=wait;
				pos=0; if (++beat==tsnum) {beat=0; ++bar;}
				showstatus();
			}
			if (firstev)
			{
				//write("Tick %d\n",firstev);
				sleep(firstev*time_division);
				pos+=firstev;
				abspos+=firstev;
			}
			showstatus();
		}
		array ev=chunks[track][chunkptr[track]++];
		switch (ev[1])
		{
			case 0x80..0x8f: alsa->note_off(	ev[1]&0xf,ev[2],ev[3]); piano[ev[1]&15]->set_note(ev[2],0); break;
			case 0x90..0x9f: //alsa->note_on(	ev[1]&0xf,ev[2],ev[3]); piano[ev[1]&15]->set_note(ev[2],ev[3]); break;
			{
				int chan=ev[1]&15;
				if (!muted[chan])
				{
					if (anysolo && !soloed[chan]) ev[3]=ev[3] && (ev[3]/4+1); //Ensure that a nonzero velocity stays nonzero
					alsa->note_on(chan,ev[2],ev[3]);
				}
				piano[chan]->set_note(ev[2],ev[3]);
				break;
			}
			case 0xa0..0xaf: alsa->note_pressure(	ev[1]&0xf,ev[2],ev[3]); break;
			case 0xb0..0xbf: alsa->controller(	ev[1]&0xf,ev[2],ev[3]); break;
			case 0xc0..0xcf: alsa->prog_chg(	ev[1]&0xf,ev[2]); chanpatch[ev[1]&15]->set_text(ev[1]==0xc9?"Percussion":patchnames[ev[2]]); break;
			case 0xd0..0xdf: alsa->chan_pressure(	ev[1]&0xf,ev[2]); break;
			case 0xe0..0xef: alsa->pitch_bend(	ev[1]&0xf,(ev[2]|(ev[3]<<7))-0x2000); break;
			case 0xff: switch (ev[2])
			{
				case 0x03: //Track name
					if (chan[track]>-1) channame[chan[track]]->set_text(ev[3]);
					break;
				case 0x04: //Instrument name (currently ignored, using the patch numbers instead)
					break;
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
				//case 0x01: //Show text elements as lyrics?
				case 0x05: if (lyrics && (lyrtrack==track || lyrtrack==-1))
				{
					string ly=ev[3];
					lyrtrack=track; //Uncomment to take only the first track with lyrics in it; comment out to keep all lyrics (potentially interspersed).
					if (!lyricsraw)
					{
						if (ly[-1]=='-') ly=ly[..<1];
						else if (ly[-1]==' ') lyricsraw=1; //Some MIDI files have lyrics already parsed in this way, some don't. I don't know how I'm supposed to recognize which is which.
						else ly+=" ";
					}
					lyrics->set_text(lyrictxt=((lyrictxt+ly)/"\r")[<7..]*"\r");
				}
				break;
			}
			break;
		}
	}
	alsa->wait();
}
