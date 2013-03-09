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

class TimeMarker //Slider that shows the time in [[H:]M:]S format
{
	inherit GTK2.Hscale;
	string format="%[2]f";
	void create()
	{
		::create(GTK2.Adjustment());
		signal_connect("format-value",format_value);
		//signal_connect("change-value",change_value); //Uncomment to allow the user to drag the slider to seek. Has UI issues though.
		//set_update_policy(GTK2.UPDATE_DISCONTINUOUS); //This would be ideal but doesn't seem to work. The setting appears to have been changed, but it has no effect on the messages sent.
		unset_flags(GTK2.CanFocus);
	}
	string format_value(object self,float val)
	{
		int ival=(int)val;
		int min=ival/60;
		return sprintf(format,min/60,min%60,val%60);
	}
	this_program set_range(float min,float max)
	{
		::set_range(min,max);
		if (max>3600.0) format="%d:%02d:%02.0f"; //h:mm:ss
		else if (max>600.0) format="%[1]02d:%[2]04.1f"; //mm:ss.s
		else if (max>60.0) format="%[1]d:%[2]05.2f"; //m:s.ss
		else format="%[2]f";
		format+=" / "+format_value(0,max);
		return this;
	}
	float|int value_set=0; //The integer 0 means "not set"; the float 0.0 means "seek to beginning"
	mixed timejumpcallout;
	void timejump(float val) {value_set=val;}
	int change_value(object self,int sig,float val)
	{
		if (floatp(value_set)) remove_call_out(timejumpcallout);
		timejumpcallout=call_out(timejump,1.5,val);
	}
}

mapping args;
object alsa;
object parser=(object)"playmidi.pike"; //Grab some utility functions. TODO: Put them into a proper module or something.
function parsesmf=parser->parsesmf;
GTK2.Widget mainwindow,lyrics,status,position;
array(GTK2.Widget) piano=allocate(16),channame=allocate(16),chanpatch=allocate(16);
Thread.Thread midithrd;

//Helper function to build the toggle buttons. Half-brightness for unselected, full for selected.
GTK2.ToggleButton toggle(int r,int g,int b,mixed ... onclick)
{
	GTK2.ToggleButton obj=GTK2.ToggleButton()
		->unset_flags(GTK2.CanFocus)
		->modify_bg(GTK2.STATE_NORMAL,GTK2.GdkColor(r/2,g/2,b/2))
		->modify_bg(GTK2.STATE_PRELIGHT,GTK2.GdkColor(r/2,g/2,b/2))
		->modify_bg(GTK2.STATE_ACTIVE,GTK2.GdkColor(r,g,b));
	obj->signal_connect("toggled",@onclick);
	return obj;
}

//Helper function to create a button and attach an event
GTK2.Button Button(string|mapping props,mixed ... onclick)
{
	GTK2.Button obj=GTK2.Button(props)->unset_flags(GTK2.CanFocus);
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
	hush();
	exit(0); //Or maybe not. I don't know.
}
int skiptrack=0;
void skip() {skiptrack=1;}

int|float jumptarget=0;
void jump(float dist) {jumptarget+=dist;}

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
		->attach(lyrics=GTK2.Label("lyrics go here")->set_line_wrap(1)->set_selectable(1)->unset_flags(GTK2.CanFocus),0,5,17,18,GTK2.FILL,GTK2.FILL|GTK2.EXPAND,0,0)
		->attach_defaults(position=TimeMarker(),0,5,18,19)
		->attach_defaults(GTK2.HbuttonBox()
			->add(Button("Play/pause",pause))
			->add(Button("Stop [Ctrl-Q]",stop))
			->add(Button("Skip track",skip))
		,0,5,19,20)
	)->add_accel_group(GTK2.AccelGroup()
		->connect('Q',4,0,stop,0)
		->connect(' ',0,0,pause,0)
		->connect(65363,1,0,jump, 10.0) //Are there constants somewhere for these? Shift+Right arrow...
		->connect(65361,1,0,jump,-10.0) //... and left arrow.
		->connect(65363,4,0,jump, 60.0) //Ditto with Ctrl
		->connect(65361,4,0,jump,-60.0)
	)->show_all();
	//mainwindow->signal_connect("key_press_event",lambda(object self,GDK2.Event ev) {write("Key! %O\n",(mapping)ev);},0,"",1); //Uncomment to dump keys to the console - good for finding the key codes for the accelgroup above
	midithrd=thread_create(playmidis);
	return -1;
}

int sayargs(mixed ... args) {write("%O\n",args); return 1;}

void playmidis() {foreach (args[Arg.REST],string fn) {playmidi(fn); hush(); alsa->reset(); alsa->wait(); sleep(1);} exit(0);}

void playmidi(string fn)
{
	skiptrack=0;
	array(array(string|array(array(int|string)))) chunks=parsesmf(Stdio.read_file(fn));
	array(string) lyrictxt=({""}); int lyricpos=0;
	mainwindow->resize(1,1);
	lyrics->set_text(fn);
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
	float seconds=0.0; //Absolute position as measured in seconds
	string info=sprintf("%3d bpm, %d %d",bpm,tsnum,1<<tsdem);
	function showstatus=lambda() {status->set_text(sprintf(" [%s] %d : %d %s\r",info,bar,beat,beat?"        ":"---     ")); position->set_value(seconds); while (paused) {hush(); pausecond->wait(pausemtx->lock());}};
	int lyrtrack=-1;
	int maxlyr=0;
	array(int) chan=({-1})*sizeof(chunks); //Associate channel numbers with chunks, for the benefit of the track-name labels
	array(array(int)) lyriccnt=allocate(sizeof(chunks),({0,0,0})); foreach (lyriccnt;int i;array l) l[-1]=i; //Count of lyric events in each track; and count of text events at non-zero position. Ties broken by track index.
	//First pass over the content: Flatten the chunks to a single stream of events.
	array(array(int|string)) events=allocate(`+(@sizeof(chunks[*]))); int evptr=0;
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
			abspos+=firstev;
			seconds+=firstev*time_division;
		}
		array(int|string) ev=events[evptr++]=chunks[track][chunkptr[track]++];
		ev[0]+=abspos;
		switch (ev[1])
		{
			case 0x80..0xef: chan[track]=ev[1]&15; break;
			case 0xff: ev[1]=256+track; switch (ev[2]) //Since a status byte cannot be >255, for obvious reasons, I can (ab)use the fact that ev[1] is a full-range integer and store the track number there. A few event types care about tracks.
			{
				case 0x2f: chunkptr[track]=sizeof(chunks[track]); break; //End of track, ignore any further events. Note that events so ignored will trigger the evptr<sizeof(events) warning message below.
				case 0x05: ++lyriccnt[track][0]; break;
				case 0x01: if (abspos) ++lyriccnt[track][1]; break; //Some files use type 01 for lyrics instead of type 05
				case 0x51: //tempo = microseconds per quarter note
					sscanf(ev[3],"%3c",tempo);
					time_division=tempo*.000001/timediv;
					break;
			}
			break;
		}
	}
	position->set_range(0,seconds);
	string lyricinfo=sort((array(string))lyriccnt)[-1]; //Note: Sort as strings to ensure that subsequent array elements affect the sort (which they don't when arrays are sorted)
	lyrtrack=256+lyricinfo[-1]; //Last cell of the last array is the track number of the Chosen One. Offset by 256 to match ev[1] in the main loop. Comment this out to keep all lyric events from all tracks (potentially interleaved).
	if (evptr<sizeof(events)) {werror("WARNING: Less MIDI events (%d) than expected (%d)!\n",evptr,sizeof(events)); events=events[..evptr-1];}
	//Second pass: Process lyric events into a more Karaoke-friendly form.
	//We collect up lines. There's a "first line" which will be displayed on playback start, and then each event with a \r in it will carry with it the next line.
	//Also, if there are too many lyric events without a \r, one will be inserted.
	//Finally, the lyric events themselves become "advance by N characters".
	array firstline=({0,0xFF,0x05,({0,""})}),curline=firstline; int cnt;
	foreach (events,array(int|string|array(int|string)) ev) if (ev[1]>=0xff && (ev[2]==0x05 || (!lyricinfo[0] && ev[2]==0x01 && ev[0])) && (lyrtrack==ev[1] || lyrtrack==-1))
	{
		string ly=ev[3];
		if (ev[2]==1)
		{
			//Text elements start with a slash or backslash to represent paragraphs
			ev[2]=0x05;
			if (ly[0]=='/' || ly[0]=='\\') ly[0]='\r';
			lyricsraw=1;
		}
		if (!lyricsraw)
		{
			if (ly[-1]=='-') ly=ly[..<1];
			else if (ly[-1]==' ') lyricsraw=1; //Some MIDI files have lyrics already parsed in this way, some don't. I don't know how I'm supposed to recognize which is which.
			else ly+=" ";
		}
		if (has_value(ly,'\r') || ++cnt>10)
		{
			//New line! Alright!
			cnt=0;
			sscanf(ly,"%s\r%s",string before,ly); //I'm guessing one of these will be blank, but hey, may as well support the \r being anywhere in the string
			curline[3][1]+=before||"";
			//write("%d %q\n",@curline[3]);
			curline=ev;
			ev[3]=({sizeof(ly)+1,"\r"});
		}
		else ev[3]=({sizeof(ly),0});
		//write("%O\n",curline);
		curline[3][1]+=ly;
	}
	if (firstline[3][1]!="") lyrics->set_text(lyrictxt[0]=firstline[3][1]);
	//foreach (events,array(int|string|array) ev) if (sizeof(ev)>3 && arrayp(ev[3])) write("Event! %d -> %q\n",ev[3][0],ev[3][1] || "--"); return;
	//Final pass: Iterate strictly over the events, processing them.
	abspos=0; seconds=0.0;
	float jumpto=0.0;
	for (evptr=0;evptr<sizeof(events) && !skiptrack;++evptr)
	{
		//write("%O        \r",jumptarget);
		if (floatp(position->value_set) || floatp(jumptarget))
		{
			if (floatp(jumptarget)) jumpto=seconds+jumptarget;
			else jumpto=position->value_set;
			position->value_set=jumptarget=0;
			if (jumpto<seconds) {evptr=0; seconds=0.0; abspos=0; lyrictxt=({firstline[3][1]}); lyricpos=0; lyrics->set_text(firstline[3][1])->select_region(0,0);}
			hush();
			continue;
		}
		array(int|string) ev=events[evptr];
		if (int firstev=ev[0]-abspos)
		{
			//write("Sleeping %d [%f]\n",firstev,firstev*time_division);
			while (pos+firstev>=tick_per_beat)
			{
				//write("Tick %d/%d leaving %d\n",tick_per_beat-pos,firstev,firstev-(tick_per_beat-pos));
				int wait=tick_per_beat-pos;
				seconds+=wait*time_division;
				if (seconds>=jumpto) sleep(wait*time_division);
				firstev-=wait;
				abspos+=wait;
				pos=0; if (++beat==tsnum) {beat=0; ++bar;}
				showstatus();
			}
			if (firstev)
			{
				//write("Tick %d\n",firstev);
				seconds+=firstev*time_division;
				if (seconds>=jumpto) sleep(firstev*time_division);
				pos+=firstev;
				abspos+=firstev;
			}
			showstatus();
		}
		switch (ev[1])
		{
			case 0x80..0x8f: alsa->note_off(	ev[1]&0xf,ev[2],ev[3]); piano[ev[1]&15]->set_note(ev[2],0); break;
			case 0x90..0x9f: //alsa->note_on(	ev[1]&0xf,ev[2],ev[3]); piano[ev[1]&15]->set_note(ev[2],ev[3]); break;
			{
				int chan=ev[1]&15;
				if (!muted[chan])
				{
					if (anysolo && !soloed[chan]) ev[3]=ev[3] && (ev[3]/4+1); //Ensure that a nonzero velocity stays nonzero (by adding 1); velocity 0 stays 0, though, as it represents note-off.
					if (seconds>=jumpto) alsa->note_on(chan,ev[2],ev[3]);
				}
				piano[chan]->set_note(ev[2],ev[3]);
				break;
			}
			case 0xa0..0xaf: alsa->note_pressure(	ev[1]&0xf,ev[2],ev[3]); break;
			case 0xb0..0xbf: alsa->controller(	ev[1]&0xf,ev[2],ev[3]); break;
			case 0xc0..0xcf: alsa->prog_chg(	ev[1]&0xf,ev[2]); chanpatch[ev[1]&15]->set_text(ev[1]==0xc9?"Percussion":patchnames[ev[2]]); break;
			case 0xd0..0xdf: alsa->chan_pressure(	ev[1]&0xf,ev[2]); break;
			case 0xe0..0xef: alsa->pitch_bend(	ev[1]&0xf,(ev[2]|(ev[3]<<7))-0x2000); break;
			case 0x100..: switch (ev[2]) //Meta-event (normally 0xff)
			{
				case 0x03: //Track name - probably will all happen at the beginning of time, but we'll handle them at any time
					if (chan[ev[1]-256]>-1) channame[chan[ev[1]-256]]->set_text(ev[3]);
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
				case 0x05: if (arrayp(ev[3]))
				{
					if (ev[3][1])
					{
						lyrictxt+=({ev[3][1]});
						while (sizeof(lyrictxt)>8)
						{
							lyricpos-=sizeof(lyrictxt[0]);
							lyrictxt=lyrictxt[1..];
						}
						lyrics->set_text(lyrictxt*"");
					}
					lyrics->select_region(0,lyricpos+=ev[3][0]);
				}
				break;
			}
			break;
		}
	}
	alsa->wait();
}
