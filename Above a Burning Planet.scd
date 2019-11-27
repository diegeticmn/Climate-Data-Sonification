MIDIClient.init;
s.boot;
s.quit;

MIDIClient.destinations;
m = MIDIOut.new(0);
n = MIDIOut.new(1);
m.latency(25);


~bpm = 120;
(
OSCdef.new(
	\test,
	{
		arg msg, time, addr, port;
		x.set(\note, msg[1]);

	},
	'/s_new'
);
)

NetAddr.langPort;


~name = "temp";
~path = Document.current.dir.asString++"/"++ ~name ++".csv";
x = CSVFileReader.read(~path, true, true).postcs;
x = x.collect(_.collect(_.interpret));
x = x.flatten
~b = x.normalize(0,12);
~int = x.normalize(1,50);
~int = ~int.round();
~b = ~b.round();

~name = "glaciers";
~path = Document.current.dir.asString++"/"++ ~name ++".csv";
~glaciers = CSVFileReader.read(~path, true, true).postcs;
~glaciers = ~glaciers.collect(_.collect(_.interpret));
~glaciers = ~glaciers.flatten;
~glaciers = ~glaciers.squared;
~glaciers = ~glaciers.sqrt;
~glaciers = ~glaciers.normalize(0,12);
~glaciers = ~glaciers.round();

Tdef(\MidiClock, { |e|
var period, tick;
"Clock start".postln;
m.start; // send Midi clock start

inf.do{
period = 60/e.bpm;
tick = period/24; // 24ppq
m.midiClock; // send Midi clock
tick.wait;
}
}).play;

)

Tdef(\MidiClock).set(\bpm, ~bpm); // change bpm

m.stop; // send Midiclock stop

~p = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, m,
    \chan, 0,
	\root, -28,
	\degree, Pxrand(~glaciers, 1),
	\dur, 1,
    \amp, Pexprand(0.25, 1.0, inf)
).play(quant: 1*60/~bpm);


(
~chord = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 1,
	\root, 0,
	\degree, Pseq(~int, 1),
	\amp, Pwhite(0.5,1.0,inf),
	\sustain, 8*60/~bpm,
	\dur, 2,
	\stretch, 4*60/~bpm
).play(quant:1*60/~bpm);
)


~bass = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 2,
	\root, -33,
	\degree, Pseq(~b, 1),
	\amp, Pwhite(0.5,1.0,inf),
	\sustain, 24*60/~bpm,
	\dur, 6,
	\stretch, 4*60/~bpm
).play(quant:1*60/~bpm);



~p.stop;
~chord.stop;
~bass.stop;
