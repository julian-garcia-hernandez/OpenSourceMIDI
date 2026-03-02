import 'screens/learn_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_midi_command/flutter_midi_command.dart'; TODO: implement MIDI functionality

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LearnScreen());
  }
}