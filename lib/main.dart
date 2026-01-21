import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(children: [ScaleGenerator(), ChordGenerator()]),
        ),
      ),
    );
  }
}

enum DiatonicMode {
  ionian,
  dorian,
  phrygian,
  lydian,
  mixolydian,
  aeolian,
  locrian,
}

Map<DiatonicMode, List<int>> intervalSequencing = {
  DiatonicMode.ionian: [2, 2, 1, 2, 2, 2, 1],
  DiatonicMode.dorian: [2, 1, 2, 2, 2, 1, 2],
  DiatonicMode.phrygian: [1, 2, 2, 2, 1, 2, 2],
  DiatonicMode.lydian: [2, 2, 2, 1, 2, 2, 1],
  DiatonicMode.mixolydian: [2, 2, 1, 2, 2, 1, 2],
  DiatonicMode.aeolian: [2, 1, 2, 2, 1, 2, 2],
  DiatonicMode.locrian: [1, 2, 2, 1, 2, 2, 2],
};

enum ChordType { major, minor }

Map<ChordType, List<int>> chordSequencing = {
  ChordType.major: [0, 4, 7],
  ChordType.minor: [0, 3, 7],
};

enum Tonic {
  c(60),
  cSharp(61),
  d(62),
  dSharp(63),
  e(64),
  f(65),
  fSharp(66),
  g(67),
  gSharp(68),
  a(69),
  aSharp(70),
  b(71);

  const Tonic(this.midiNote);
  final int midiNote;
}

class ScaleGenerator extends StatefulWidget {
  const ScaleGenerator({super.key});

  @override
  ScaleGeneratorState createState() => ScaleGeneratorState();
}

class ScaleGeneratorState extends State<ScaleGenerator> {
  List<int>? scale = [60, 62, 64, 65, 67, 69, 71], intervalSequence = [];
  DiatonicMode? selectedMode = DiatonicMode.ionian;
  Tonic selectedTonic = Tonic.c; //this is c by default -> maps to 60

  void generateScale() {
    int intervalSum = 0;
    intervalSequence = intervalSequencing[selectedMode];
    scale = intervalSequence?.map((interval) {
      intervalSum += interval;
      return selectedTonic.midiNote + intervalSum;
    }).toList();
    scale?.insert(0, selectedTonic.midiNote);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu(
          label: Text("Mode"),
          dropdownMenuEntries: <DropdownMenuEntry<String>>[
            DropdownMenuEntry(value: "Ionian", label: "Ionian (Major)"),
            DropdownMenuEntry(value: "Dorian", label: "Dorian"),
            DropdownMenuEntry(value: "Phrygian", label: "Phyrgian"),
            DropdownMenuEntry(value: "Lydian", label: "Lydian"),
            DropdownMenuEntry(value: "Mixolydian", label: "Mixolydian"),
            DropdownMenuEntry(value: "Aeolian", label: "Aeolian (Minor)"),
            DropdownMenuEntry(value: "Locrian", label: "Locrian"),
          ],
          onSelected: (String? mode) {
            mode = mode!.toLowerCase();
            setState(() {
              selectedMode = DiatonicMode.values.byName(mode!);
              generateScale();
            });
          },
        ),
        DropdownMenu(
          label: Text("Tonic"),
          dropdownMenuEntries: <DropdownMenuEntry<String>>[
            DropdownMenuEntry(value: "C", label: "C"),
            DropdownMenuEntry(value: "C#", label: "C#"),
            DropdownMenuEntry(value: "D", label: "D"),
            DropdownMenuEntry(value: "D#", label: "D#"),
            DropdownMenuEntry(value: "E", label: "E"),
            DropdownMenuEntry(value: "F", label: "F"),
            DropdownMenuEntry(value: "F#", label: "F#"),
            DropdownMenuEntry(value: "G", label: "G"),
            DropdownMenuEntry(value: "G#", label: "G#"),
            DropdownMenuEntry(value: "A", label: "A"),
            DropdownMenuEntry(value: "A#", label: "A#"),
            DropdownMenuEntry(value: "B", label: "B"),
          ],
          onSelected: (String? tonic) {
            setState(() {
              selectedTonic = Tonic.values.byName(tonic!);
              generateScale();
            });
          },
        ),
        Text("this is the scale in its midi numbered format $scale"),
      ],
    );
  }
}

List<int> majorChord = [0, 4, 7], minorChord = [0, 3, 7];

class Chord {
  Chord({required this.type, required this.midiNotes});
  ChordType type;
  List<int> midiNotes = [];
}

class ChordGenerator extends StatefulWidget {
  const ChordGenerator({super.key});

  @override
  ChordGeneratorState createState() => ChordGeneratorState();
}

class ChordGeneratorState extends State<ChordGenerator> {
  List<int> scale = [60, 62, 64, 65, 67, 69, 71];
  List<Chord> chords = [];
  Map<String, bool> chordTypeChecks = {"Major": false, "Minor": false};
  //just have this generate the major triads that are valid in the scale
  void generateChords() {
    /*
    we have to use majorChord intervals
    build each chord out as a set
    if every member of that chordSet is a member of the scale
    check first if every member of the chord is there for each member do that check
    that way we don't waste time building out a chord and then checking validity
    we do validity checks at every step, no time wasting
      append it
    otherwise don't append it

    we have to go through every step in scale (hardcoded for now)
    set each index as the root
    
    so this works, except that now there is not enough degrees in the scale for the scales that come later like 72
    for example F Major is [65, 69, 72] but the problem is that there is no 72 in the scale
      it only goes up to 71
    */
    int root = 0, scaleDegree = 0, interval = 0;
    List<int> midiNotes = [];
    for (var i = 0; i < scale.length; ++i) {
      root = scale[i];
      for (var j = 0; j < majorChord.length; ++j) {
        interval = majorChord[j];
        scaleDegree = root + interval;
        if (!(scale.contains(scaleDegree))) {
          midiNotes.clear();
          break;
        }
        midiNotes.add(scaleDegree);
      }
      if (midiNotes.isNotEmpty) {
        chords.add(Chord(type: ChordType.major, midiNotes: midiNotes));
      }
    }
    debugPrint("$chords");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text("Major"),
          value: chordTypeChecks["Major"],
          onChanged: (bool? value) {
            setState(() {
              chordTypeChecks["Major"] = value!;
              generateChords();
            });
          },
        ),
        CheckboxListTile(
          title: Text("Minor"),
          value: chordTypeChecks["Minor"],
          onChanged: (bool? value) {
            setState(() {
              chordTypeChecks["Minor"] = value!;
            });
          },
        ),
        Text(
          "these are the chords for the scale you have selected (HARDCODED for now): $chords",
        ),
      ],
    );
  }
}
