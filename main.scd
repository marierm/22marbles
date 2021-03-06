// The interface (sensing technology)
// Its evolution over the last 13 years
// Mapping strategies
// Mapping the buttons
// Collaboration with Myriam (Origami)
// Collaboration with Marc (Origami again)
// Improvisation (free improv with acoustic musicians)
// The quintet (with Preston, Francis, Ana, Émilie)
// The score
// What's next?





// TEST
x = {SinOsc.ar(([54,56,58,60]+12).midicps, 0, 0.1)}.play;
x = {SinOsc.ar(([60]+12).midicps, 0, 0.1)}.play;
x.free;
x = { SinOsc.ar(Array.series(50, 60, 60).clump(2).flop;, 0, 0.1) }.play;
x.free;
s.meter;

// Stop playback in harmo modes: does it work?
// Make option to stop loops in the order they appeared.
// Find a way to make inheritance.

(
{
    ~stageCtl = NetAddr("localhost", 56666);
    ~stageCtlPath = "C:/Users/User/bin/open-stage-control/";
    (~stageCtlPath ++ "open-stage-control.exe -- --port 8000 --send localhost:57120 --osc-port 56666 --load " ++ "stageDisplay.json".resolveRelative).unixCmd;


	TempoClock.default.tempo_((64.midicps) / 2.pow(7)); // tempo of midinote 64 = 1.2876076441909 bps
    // ~scJackName="SuperCollider:out_"; //for Jack connections
    // ~scJackNameIn="SuperCollider:in_"; //for Jack connections
    // ~reaperInJackName="REAPER:in";

	// ~rppFilePath = "../signumMix/kamloopsMix.RPP".resolveRelative;
	// ~rppFilePath = "../showSurToit_2020-07-24/showSurToit_2020-07-24.RPP".resolveRelative;
	// ~rppFilePath = "../vmmm_jams/vmmm_jams.RPP".resolveRelative;
    // ~rppFilePath = "../sos/sos.RPP".resolveRelative;

    // "killall reaper".unixCmd; //kill reaper.
	// "nmcli con up sponger".unixCmd; // Make this computer a hotspot.
	// "nmcli con up sudafed".unixCmd; // Connect to sudafed

	0.1.wait;
    // ("reaper" + ~rppFilePath).unixCmd;
    // "killall jconvolver;".unixCmd;
	// "killall zita-rev1;".unixCmd;
	0.1.wait;
    // "jconvolver -s default -N rvb ~/docs/soundBank/ir/True\\ M7/Halls/amsterdamHall.conf".unixCmd;
	// "zita-rev1 -name rvb".unixCmd;
	s.bootSync;
    // "/home/marierm/scripts/jackDisconnectEverything.py".unixCmd;
	"prep/cSponge.scd".loadRelative;
	"prep/cSimpleSponge.scd".loadRelative;
	"prep/cLooper.scd".loadRelative;
	"prep/cFm.scd".loadRelative;
	// "prep/triggeredByVideo.scd".loadRelative;
	"prep/cPopperRzn.scd".loadRelative;
	"prep/cPopper.scd".loadRelative;
	"prep/cPlayer.scd".loadRelative;
	"prep/gui.scd".loadRelative;

	s.sync;
	1.wait;
	~ipsPrefix = "192.168.109.";
	// ~ipsPrefix = "10.42.0.";
	// ~ips = [103, 79, 111, 86, 109];
	// ~spongeNames = ["stripes", "zebra", "flowers", "ana", "brown"];
	~ips = [103, 79];
	// ~ips = [140];
	// ~ips = [140, 191];
	~spongeNames = ["rubik","zebra"];
	// ~classes = [~cSponge, ~cSimpleSponge];
		~classes = [~cSponge, ~cSponge];
	// ~classes = [~cSponge];//, ~cSponge];
	~transpose = [0, 0];
	~sponges = IdentityDictionary.new();
	~voices = IdentityDictionary.new();

	~numDots = 32;  // For Pat's video.
	~dotArrays = Array.fill2D(~ips.size, ~numDots, {0});
	~patsAddress = NetAddr("224.0.0.1", 8888);
	// x = ~cSponge.value( ~ipsPrefix ++ 97, \sponge, Server.default );
	// x.prep;
	// x.sponge.hold_(true);
	~ips.do({ |i, j|
		// var sym = ("sponge_" ++ i.asAscii).asSymbol;
		var sym = (~spongeNames[j] ++ "_" ++ i).asSymbol;
		~sponges.put( sym, ~classes[j].value( ~ipsPrefix ++ i, sym, Server.default ) );
		~sponges[sym].prep; // The master is the first sponge: stripes
		s.sync;
		1.wait;
		~sponges[sym].sponge.hold_(true);
		~voices.put( sym, List[] );
		~voices[sym].add( // add fm synth to voice 0 of each sponge.
			~cFmManager.value(
				interpolatorPath: ("fm0*").resolveRelative.pathMatch.sort.last,
				cSponge: ~sponges[sym],
				notes: ([ \en1, \en2, \en3].keynum.mirror2.clump(3)).flat + ~transpose[j],
				chords: [
					[ \en1, \en2, \en3, \en3, \en2, \en1].keynum + ~transpose[j],
					// [ \fs7, \bn7, \en8, \en7, \bf7, \cn8].keynum - 12,
					[ \en1, \en2, \gn2, \dn3, \fs3, \bn3].keynum + ~transpose[j],
					[ \en1, \dn2, \fs2, \dn3, \fs3, \bn3].keynum + ~transpose[j],
					[ \en1, \cn2, \gn2, \dn3, \fs3, \bn3].keynum + ~transpose[j],
					[ \en1, \bn1, \an2, \dn3, \fs3, \bn3].keynum + ~transpose[j],
					[ \en1, \en2, \cn3, \dn3, \fs3, \bn3].keynum + ~transpose[j],
					[ \en1, \dn2, \gn2, \cn3, \fs3, \bn3].keynum + ~transpose[j],
					[ \en1, \cn2, \gn2, \bn2, \fs3, \bn3].keynum + ~transpose[j],
					[ \en1, \dn2, \fs2, \bn2, \en3, \an3].keynum + ~transpose[j],
					[ \bn0, \en2, \cn2, \dn3, \gn1, \fn2, \an2 ].keynum,
					[ \an1, \dn2, \en3, \gn2, \bn2, \cn3, \fn1 ].keynum,
					[ \en1, \dn1, \fn2, \cn2, \bn1, \gn3, \an2 ].keynum,
					[ \en1, \an2, \gn2, \dn3, \cn1, \fn2, \bn1 ].keynum,
					[ \cn1, \bn2, \an3, \fn1, \en1, \gn3, \dn2 ].keynum,
					[ \dn1, \fn2, \cn3, \an3, \gn2, \bn1, \en1 ].keynum,
					[ \cn1, \en3, \fn2, \an1, \bn1, \gn2, \dn3 ].keynum
				],
                /*				chords: [ // POUR JOUER TOUS LES CRIS LES SOS (Pokemon sur ta DS)
					[ \en1, \en2, \en3, \en3, \en2, \en1].keynum + ~transpose[j], //
					[ \an1, \en2, \gn2, \an3, \cn3, \en3].keynum + ~transpose[j], // Am7  0001
					[ \fn1, \cn2, \fn2, \an2, \cn3, \an3].keynum + ~transpose[j], // F    0010
					[ \gn1, \dn2, \gn2, \dn3, \bn3, \gn3].keynum + ~transpose[j], // G    0011
					[ \en1, \bn1, \gn2, \en2, \en3, \gn3].keynum + ~transpose[j], // Em   0100
					[ \cn1, \cn2, \en2, \gn2, \cn3, \en3].keynum + ~transpose[j], // C    0101
					[ \gn1, \dn2, \gn2, \dn3, \bn3, \gn3].keynum + ~transpose[j], // G    0110
					[ \an1, \en2, \gn2, \an3, \cn3, \en3].keynum + ~transpose[j], // Am   0111
					[ \fn1, \cn2, \fn2, \an2, \en3, \an3].keynum + ~transpose[j], // FM7  1000
					[ \dn1, \an1, \dn2, \fn2, \an2, \fn3].keynum, // Dm 1001
					[ \en1, \bn1, \en2, \an2, \bn2, \en3].keynum, // E4 1010
					[ \en1, \bn1, \en2, \gs2, \bn2, \dn3].keynum, // E7
					[ \en1, \an2, \gn2, \dn3, \cn1, \fn2, \bn1 ].keynum, //
					[ \cn1, \bn2, \an3, \fn1, \en1, \gn3, \dn2 ].keynum, //
					[ \dn1, \fn2, \cn3, \an3, \gn2, \bn1, \en1 ].keynum, //
					[ \cn1, \en3, \fn2, \an1, \bn1, \gn2, \dn3 ].keynum  //
				],*/
				outBus: j * 2,
				fsrMuteThreshold: [0.85, 0.95][j], // larger number = muting is easier
				fmId: j + 20,
				relTime: 0.2,
				server: s,
				withLoop: (~classes[j] == ~cSponge),
                stageCtl: ~stageCtl
			)
		);

		///////////////
		s.sync;
		1.wait;
		~voices.at(sym).do({|i| i.prep});
		s.sync;
		1.wait;
		////////////////////  To send controls to Pat's videos.
		// ~sponges.at(sym).sponge.action_(
		// 	~sponges.at(sym).sponge.action.addFunc({ |msg|
		// 		var val;
		// 		val = msg[0].linlin(0,1023,-1.0,1.0);
		// 		~dotArrays[j] = ~dotArrays[j].rotate(-1);
		// 		~dotArrays[j].put(~numDots - 1, val);
		// 		~dotArrays[j].do({ |value, index|
		// 			~patsAddress.sendMsg("/video_wave" +/+ ~spongeNames[j], index, value);
		// 			~patsAddress.sendMsg("/video_wave_c" +/+ ~spongeNames[j], index, value);
		// 		});
		// 	});
		// );
		sym.post; " ready.".postln;
	});
	// s.sync;
	// { // add voices to first sponge only.
	// 	var sym = (~spongeNames[0] ++ "_" ++ ~ips[0]).asSymbol;
	// 	sym.postln;
	// 	~voices[sym].add( // add melo synth to voice 1 of first sponge only.
	// 		~cPopperRzn.value(
	// 			interpolatorPath: ("popMelo"++1++"*").resolveRelative.pathMatch.sort.last.resolveRelative,
	// 			cSponge: ~sponges[sym],
	// 			notes: [ \en1, \en2, \en3, \en3, \en2, \en1].keynum + 24 + ~transpose,
	// 			chords: [
	// 				[ \en1, \en2, \en3, \en3, \en2, \en1].keynum + ~transpose,
	// 				// [ \fs7, \bn7, \en8, \en7, \bf7, \cn8].keynum - 12,
	// 				[ \en2, \en3, \gn3, \dn4, \fs4, \bn4].keynum + ~transpose,
	// 				[ \en2, \dn3, \fs3, \dn4, \fs4, \bn4].keynum + ~transpose,
	// 				[ \en2, \cn3, \gn3, \dn4, \fs4, \bn4].keynum + ~transpose,
	// 				[ \en2, \bn2, \an3, \dn4, \fs4, \bn4].keynum + ~transpose,
	// 				[ \en2, \en3, \cn4, \dn4, \fs4, \bn4].keynum + ~transpose,
	// 				[ \en2, \dn3, \gn3, \cn4, \fs4, \bn4].keynum + ~transpose,
	// 				[ \en2, \cn3, \gn3, \bn3, \fs4, \bn4].keynum + ~transpose,
	// 				[ \en2, \dn3, \fs3, \bn3, \en4, \an4].keynum + ~transpose,
	// 				[ \fs2, \bn2, \en3, \en2, \bf2, \cn3].keynum + ~transpose,
	// 				[ \fn2, \bf2, \ef3, \en2, \bf2, \cn3].keynum + ~transpose,
	// 				[ \en2, \an2, \cs3, \ef2, \af2, \dn3].keynum + ~transpose,
	// 				[ \gf2, \an2, \cn3, \fn2, \af2, \df3].keynum + ~transpose,
	// 				[ \gf2, \an2, \cn3, \fn2, \bf2, \dn3].keynum + ~transpose,
	// 				[ \gf2, \an2, \cn3, \fn2, \bn2, \dn3].keynum + ~transpose,
	// 				[ \gn2, \an2, \cn3, \fn2, \bn2, \dn3].keynum + ~transpose,
	// 				[ \gn2, \an2, \cn3, \fn2, \fn3, \dn3].keynum + ~transpose
	// 			],
	// 			outBus: 4,
	// 			tetra: false,
	// 			fsrMuteThreshold: nil,
	// 			rznId: 210,
	// 			relTime: 10.0,
	// 			server: s
	// 		)
	// 	);
	// 	~voices[sym].add( // add melo synth to voice 1 of each sponge.
	// 		~cPopper.value(
	// 			interpolatorPath: ("popMelo"++1++"*").resolveRelative.pathMatch.sort.last.resolveRelative,
	// 			cSponge: ~sponges[sym],
	// 			notes: [ \en1 ],
	// 			outBus: 4,
	// 			tetra: false,
	// 			amp: 4.dbamp,
	// 			fsrMuteThreshold: nil,
	// 			popId: 550,
	// 			server: s
	// 		)
	// 	);
	// 	~voices[sym].add( // add flm playback for each sponge.
	// 		~cPlayer.value(
	// 			audioFilePath: "samples/01-flm.wav".resolveRelative,
	// 			cSponge: ~sponges[sym],
	// 			outBus: 6,
	// 			tetra: false,
	// 			amp: 0.dbamp,
	// 			attackTime: 5,
	// 			relTime: 1,
	// 			ampCtl: true,
	// 			playerId: 880,
	// 			server: s
	// 		)
	// 	);
	// 	~voices[sym].add( // add feu playback for each sponge.
	// 		~cPlayer.value(
	// 			audioFilePath: "samples/05-feu.wav".resolveRelative,
	// 			cSponge: ~sponges[sym],
	// 			outBus: 8,
	// 			tetra: false,
	// 			amp: 0.dbamp,
	// 			attackTime: 15,
	// 			relTime: 12,
	// 			ampCtl: false,
	// 			playerId: 1430,
	// 			server: s
	// 		)
	// 	);
	// 	~voices.at(sym).do({|i| i.prep});
	// }.valueEnvir;

	// Make Jack connections.
    // 10.do({ |i|
    //     var string;
    //     string = "jack_connect" + ~scJackName ++ (i+1) + ~reaperInJackName ++ (i+1);
    //     string.unixCmd;
    // });

/*	"jack_connect REAPER:out1 system:playback_1
     jack_connect REAPER:out2 system:playback_2
     jack_connect REAPER:out3 system:playback_3
     jack_connect REAPER:out4 system:playback_4
     jack_connect REAPER:out5 system:playback_5
     jack_connect REAPER:out6 system:playback_6".unixCmd;

	"jack_connect REAPER:out7 rvb:inL
     jack_connect REAPER:out8 rvb:inR
     jack_connect rvb:outL REAPER:in31
     jack_connect rvb:outR REAPER:in32".unixCmd;*/
/*
	2.do({ |i|
		var string =
		"jack_connect system:capture_" ++ (i+1) + ~scJackNameIn ++ (i+1);
		string.unixCmd;
	});*/

	~ips.do({ |i,j|
		var sym = (~spongeNames[j] ++ "_" ++ i).asSymbol;
		~sponges[sym].sponge.hold_(false);
	});
    // {
    //     ~gui = ~quintetGui.value(~ips, ~spongeNames);
    //     ~gui.window.front;
    // }.defer;
}.fork;
)

~sponges[\stripes_140].sponge.features[0].gui;
~voices[\stripes_140][0]
.interpolator.gui;


.at(~stripes)[fmVoice].octVa;
~voices[\stripes_103][0].looper.setQuant(0.5);
~voices[\stripes_103][0].looper.quant;

"prep/gui.scd".loadRelative;

~gui = ~quintetGui.value([103], ["rubik"]);

~gui.window.front;

~gui = "prep/gui.scd".loadRelative;

NetAddr.localAddr.sendMsg("/rubik_103/recor", 0)

OSCFunc({ |msg|
/*    {
        octaveViews[i].string_(msg[1].asInteger.asString);
    }.defer;*/
    msg.postln;
}, "" +/+ "moo")