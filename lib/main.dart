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

Map<String, List<int>> intervalSequencing = {
  "Ionian": [2, 2, 1, 2, 2, 2, 1],
  "Dorian": [2, 1, 2, 2, 2, 1, 2],
  "Phrygian": [1, 2, 2, 2, 1, 2, 2],
  "Lydian": [2, 2, 2, 1, 2, 2, 1],
  "Mixolydian": [2, 2, 1, 2, 2, 1, 2],
  "Aeolian": [2, 1, 2, 2, 1, 2, 2],
  "Locrian": [1, 2, 2, 1, 2, 2, 2],
};

Map<String, int> midiTonic = {
  "C": 60,
  "C#": 61,
  "D": 62,
  "D#": 63,
  "E": 64,
  "F": 65,
  "F#": 66,
  "G": 67,
  "G#": 68,
  "A": 69,
  "A#": 70,
  "B": 71,
};

class ScaleGenerator extends StatefulWidget {
  const ScaleGenerator({super.key});

  @override
  ScaleGeneratorState createState() => ScaleGeneratorState();
}

class ScaleGeneratorState extends State<ScaleGenerator> {
  List<int>? scale = [60, 62, 64, 65, 67, 69, 71], intervalSequence = [];
  String? selectedMode = "Ionian", selectedTonic = "C";

  void generateScale() {
    int intervalSum = 0;
    intervalSequence = intervalSequencing[selectedMode];
    scale = intervalSequence?.map((interval) {
      intervalSum += interval;
      return midiTonic[selectedTonic]! + intervalSum;
    }).toList();
    scale?.insert(0, midiTonic[selectedTonic]!);
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
            setState(() {
              selectedMode = mode;
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
              selectedTonic = tonic;
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

class ChordGenerator extends StatefulWidget {
  const ChordGenerator({super.key});

  @override
  ChordGeneratorState createState() => ChordGeneratorState();
}

class ChordGeneratorState extends State<ChordGenerator> {
  List<int> scale = [60, 62, 64, 65, 67, 69, 71];
  List<List<int>> chords = [];

  Map<String, bool> chordTypeChecks = {"Major": false, "Minor": false};
  List<int> chord = [];
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
    for (var i = 0; i < scale.length; ++i) {
      root = scale[i];
      for (var j = 0; j < majorChord.length; ++j) {
        interval = majorChord[j];
        scaleDegree = root + interval;
        if (!(scale.contains(scaleDegree))) {
          chord.clear();
          break;
        }
        chord.add(scaleDegree);
      }
      if (chord.isNotEmpty) {
        chords.add(List.from(chord));
        chord.clear();
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
