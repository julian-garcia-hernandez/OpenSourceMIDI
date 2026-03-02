import 'package:flutter/material.dart';
import 'package:piano/piano.dart';
import 'package:enum_to_string/enum_to_string.dart';

const int keysAmount = 12;

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

class ScaleGenerator extends StatefulWidget {
  const ScaleGenerator({super.key});

  @override
  ScaleGeneratorState createState() => ScaleGeneratorState();
}

class ScaleGeneratorState extends State<ScaleGenerator> {
  List<int>? generatedScale = [60, 62, 64, 65, 67, 69, 71, 72];

  List<int>? intervalSequence = [];
  DiatonicMode? selectedMode = DiatonicMode.ionian;
  NotePosition selectedTonic = NotePosition(note: Note.C, octave: 4);
  int octave = 4;
  Accidental? accidental = Accidental.None;

  void generateScale() {
    int intervalSum = 0;
    intervalSequence = intervalSequencing[selectedMode];
    var tonicPitch = selectedTonic.pitch;
    generatedScale = intervalSequence?.map((interval) {
      intervalSum += interval;
      return tonicPitch + intervalSum;
    }).toList();
    generatedScale?.insert(0, selectedTonic.pitch);
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
          onSelected: (String? selectedNote) {
            setState(() {
              var noteString = selectedNote?[0];
              selectedNote = selectedNote?.substring(1); //#5
              if (selectedNote!.isNotEmpty) {
                accidental = EnumToString.fromString(
                  Accidental.values,
                  "Sharp",
                );
              } else {
                accidental = EnumToString.fromString(Accidental.values, "None");
              }

              //get note from the enum class
              var note = EnumToString.fromString(Note.values, noteString!);
              selectedTonic = NotePosition(
                note: note!,
                octave: octave,
                accidental: accidental!,
              );
              generateScale();
            });
          },
        ),
        Text(
          "this is the generated scale in its midi numbered format $generatedScale",
        ),
        // InheritedScale(
        //   scale: generatedScale!,
        //   child: Column(children: [ChordGenerator()]),
        // ),
      ],
    );
  }
}
