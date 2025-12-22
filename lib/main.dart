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
          child: Row(
            children: [DropdownMenu(label: Text(
            "Mode"
          ), dropdownMenuEntries: <DropdownMenuEntry<String>>[
            DropdownMenuEntry(value: "Major", label: "Ionian (Major)"),
            DropdownMenuEntry(value: "Dorian", label: "Dorian"),
            DropdownMenuEntry(value: "Phrygian", label: "Phyrgian"),
            DropdownMenuEntry(value: "Lydian", label: "Lydian"),
            DropdownMenuEntry(value: "Mixolydian", label: "Mixoldyian"),
            DropdownMenuEntry(value: "Minor", label: "Aeolian (Minor)"),
            DropdownMenuEntry(value: "Locrian", label: "Locrian"),
          ]),
          DropdownMenu(label: Text("Tonic"), 
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
          ])
          ]),
        ),
      ),
    );
  }
}
