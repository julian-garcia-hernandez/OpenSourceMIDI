import 'package:flutter/material.dart';
import 'package:opensource_midi/widgets/chord_generator.dart';
import '../widgets/scale_generator.dart';
import 'package:piano/piano.dart';

var noteRange = NoteRange(
  from: NotePosition(note: Note.D, octave: 4),
  to: NotePosition(note: Note.C, octave: 5),
);

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learn Screen")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClefImage(
                              clefColor: Colors.red,
                              noteColor: Colors.red,
                              clef: Clef.Treble,
                              noteRange: noteRange,
                              noteRangeToClip: noteRange,
                              noteImages: [
                                NoteImage(
                                  notePosition: NotePosition(note: Note.C),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ScaleGenerator(),
          ChordGenerator(),

          // SizedBox(
          //   height: 220.0,
          //   child: Container(
          //     color: Colors.black,
          //     child: SafeArea(
          //       child: InteractivePiano(
          //         noteRange: NoteRange.forClefs([
          //           Clef.Treble,
          //           Clef.Alto,
          //           Clef.Bass,
          //         ], extended: true),
          //         keyWidth: 60,
          //         naturalColor: Colors.white,
          //         accidentalColor: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Learn"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ), //TODO: gonna implement later
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                // setState(() {}); //TODO: gonna implement later
              },
            ),
          ],
        ),
      ),
    );
  }
}
