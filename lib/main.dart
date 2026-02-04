import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:piano/piano.dart';

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

enum ChordType { major, minor }

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

//this is immutable, it will only pass data down to its children, chord generator which will then generate the chords
class InheritedScale extends InheritedWidget {
  const InheritedScale({super.key, required this.scale, required super.child});
  final List<int> scale;
  static InheritedScale? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedScale>();
  }

  static InheritedScale of(BuildContext context) {
    final InheritedScale? result = maybeOf(context);
    assert(result != null, 'No InheritedScale found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedScale oldWidget) => scale != oldWidget.scale;
}

Map<ChordType, List<int>> intervals = {
  ChordType.major: [0, 4, 7],
  ChordType.minor: [0, 3, 7],
};

class Chord {
  Chord({required this.type, required this.midiNotes});
  ChordType type;
  List<Note> midiNotes = [];
}

// class ChordGenerator extends StatefulWidget {
//   const ChordGenerator({super.key});

//   @override
//   ChordGeneratorState createState() => ChordGeneratorState();
// }

// class ChordGeneratorState extends State<ChordGenerator> {
//   List<int> midiIntervals = [], midiScale = [];
//   List<Chord> chords = [];
//   Map<String, bool> chordTypeChecks = {"Major": false, "Minor": false};
//   void generateChords() {
//     int root = 0, scaleDegree = 0, interval = 0;
//     List<NotePosition> chord = [];
//     midiScale = InheritedScale.of(context).scale;
//     midiIntervals = midiScale.map<int>((midiNote) {
//       midiNote %= 12;
//       return midiNote;
//     }).toList();

//     for (var i = 0; i < midiScale.length; ++i) {
//       root = midiScale[i];
//       for (var j = 0; j < intervals[ChordType.major]!.length; ++j) {
//         interval = intervals[ChordType.major]![j];
//         scaleDegree = root + interval;
//         if (!(midiIntervals.contains(scaleDegree % 12))) {
//           chord.clear();
//           break;
//         }
//         chord.add(NotePosition(scaleDegree % 12)); //TODO: integrate library note typing
//       }
//       if (chord.isNotEmpty) {
//         chords.add(
//           Chord(type: ChordType.major, midiNotes: [...chord]),
//         );
//         chord.clear();
//       }
//     }
//   }

//   void deleteChords() {
//     chords.removeWhere((chord) => chord.type == ChordType.major);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CheckboxListTile(
//           title: Text("Major"),
//           value: chordTypeChecks["Major"],
//           onChanged: (bool? value) {
//             setState(() {
//               chordTypeChecks["Major"] = value!;
//               if (value) {
//                 generateChords();
//               } else {
//                 deleteChords();
//               }
//             });
//           },
//         ),
//         CheckboxListTile(
//           title: Text("Minor"),
//           value: chordTypeChecks["Minor"],
//           onChanged: (bool? value) {
//             setState(() {
//               chordTypeChecks["Minor"] = value!;
//             });
//           },
//         ),
//         for (int i = 0; i < chords.length; i++)
//           Text("chord $i: ${chords[i].midiNotes}"),
//       ],
//     );
//   }
// }
