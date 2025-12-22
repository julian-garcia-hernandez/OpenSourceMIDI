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
      home: Scaffold(body: Center(child: ScaleGenerator())),
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
