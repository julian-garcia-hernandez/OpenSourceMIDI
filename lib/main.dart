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

enum NoteX {
  c(midiNote: 60, letterNote: "C"),
  cSharp(midiNote: 61, letterNote: "C#"),
  d(midiNote: 62, letterNote: "D"),
  dSharp(midiNote: 3, letterNote: "D#"),
  e(midiNote: 64, letterNote: "E"),
  f(midiNote: 65, letterNote: "F"),
  fSharp(midiNote: 66, letterNote: "F#"),
  g(midiNote: 67, letterNote: "G"),
  gSharp(midiNote: 68, letterNote: "G#"),
  a(midiNote: 69, letterNote: "A"),
  aSharp(midiNote: 70, letterNote: "A#"),
  b(midiNote: 71, letterNote: "B");

  const Note({
    required this.midiNote,
    required this.letterNote,
  });

  final int midiNote;
  final String letterNote;
}


class ScaleGenerator extends StatefulWidget {
  const ScaleGenerator({super.key});

  @override
  ScaleGeneratorState createState() => ScaleGeneratorState();
}

class ScaleGeneratorState extends State<ScaleGenerator> {
  List<Note>? generatedScale = [Note.C, Note.D, Note.E, Note.F, Note.G, Note.A, Note.B];
  List<int>? intervalSequence = [];
  DiatonicMode? selectedMode = DiatonicMode.ionian;
  NotePosition selectedTonic = NotePosition(note: Note.C, octave: 4);

  void generateScale() {
    int intervalSum = 0;
    intervalSequence = intervalSequencing[selectedMode];
    generatedScale = intervalSequence?.map((interval) {
      intervalSum += interval;
      return selectedTonic.pitch + intervalSum;
    }).toList();
    generatedScale?.insert(0, selectedTonic);
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
            DropdownMenuEntry(value: "c", label: "C"),
            DropdownMenuEntry(value: "cSharp", label: "C#"),
            DropdownMenuEntry(value: "d", label: "D"),
            DropdownMenuEntry(value: "dSharp", label: "D#"),
            DropdownMenuEntry(value: "e", label: "E"),
            DropdownMenuEntry(value: "f", label: "F"),
            DropdownMenuEntry(value: "fSharp", label: "F#"),
            DropdownMenuEntry(value: "g", label: "G"),
            DropdownMenuEntry(value: "gSharp", label: "G#"),
            DropdownMenuEntry(value: "a", label: "A"),
            DropdownMenuEntry(value: "aSharp", label: "A#"),
            DropdownMenuEntry(value: "b", label: "B"),
          ],
          onSelected: (String? tonic) {
            setState(() {
              selectedTonic = Note.values.byName(tonic!);
              generateScale();
            });
          },
        ),
        Text(
          "this is the generated scale in its midi numbered format $generatedScale",
        ),
        InheritedScale(scale: generatedScale!, child: Column(
          children: [InteractivePiano(noteRange: NoteRange(from: NotePosition(note: Note.C, octave: 3), to: NotePosition(note: Note.C, octave: 4)),), ChordGenerator()],
        )),
      ],
    );
  }
}

//this is immutable, it will only pass data down to its children, chord generator which will then generate the chords
class InheritedScale extends InheritedWidget {
  const InheritedScale({super.key, required this.scale, required super.child});
  final List<Note> scale;
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

Map<ChordType, List<int>> chordIntervals = {
  ChordType.major: [0, 4, 7],
  ChordType.minor: [0, 3, 7],
};

class Chord {
  Chord({required this.type, required this.midiNotes});
  ChordType type;
  List<Note> midiNotes = [];
}

class ChordGenerator extends StatefulWidget {
  const ChordGenerator({super.key});

  @override
  ChordGeneratorState createState() => ChordGeneratorState();
}

class ChordGeneratorState extends State<ChordGenerator> {
  List<int> midiIntervals = [], midiScale = [];
  List<Chord> chords = [];
  Map<String, bool> chordTypeChecks = {"Major": false, "Minor": false};
  void generateChords() {
    int root = 0, scaleDegree = 0, interval = 0;
    List<Note> chordMidiNotes = [];
    midiScale = InheritedScale.of(context).scale;
    midiIntervals = midiScale.map<int>((midiNote) {
      midiNote %= 12;
      return midiNote;
    }).toList();

    for (var i = 0; i < midiScale.length; ++i) {
      root = midiScale[i];
      for (var j = 0; j < chordIntervals[ChordType.major]!.length; ++j) {
        interval = chordIntervals[ChordType.major]![j];
        scaleDegree = root + interval;
        if (!(midiIntervals.contains(scaleDegree % 12))) {
          chordMidiNotes.clear();
          break;
        }
        chordMidiNotes.add(Note.values[scaleDegree % 12]);
      }
      if (chordMidiNotes.isNotEmpty) {
        chords.add(
          Chord(type: ChordType.major, midiNotes: [...chordMidiNotes]),
        );
        chordMidiNotes.clear();
      }
    }
  }

  void deleteChords() {
    chords.removeWhere((chord) => chord.type == ChordType.major);
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
              if (value) {
                generateChords();
              } else {
                deleteChords();
              }
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
        for (int i = 0; i < chords.length; i++)
          Text("chord $i: ${chords[i].midiNotes}")
      ],
    );
  }
}
