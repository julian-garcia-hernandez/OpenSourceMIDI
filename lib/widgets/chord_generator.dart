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
