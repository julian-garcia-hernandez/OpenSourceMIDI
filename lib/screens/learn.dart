import 'package:flutter/material.dart';
import '../widgets/scale_generator.dart';
import 'package:piano/piano.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learn Screen")),
      body: Center(
        child: Column(
          children: [
            // SheetMusicDisplay(),
            ScaleGenerator(),
            // InteractivePiano(noteRange: noteRange)
          ],
        ),
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
