import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opensource_midi/main.dart';
import '../lib/widgets/scale_generator.dart';

void main() {
  testWidgets("ScaleGenerator loads C Major by default", (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Directionality(
            textDirection: TextDirection.ltr,
            child: ScaleGenerator(),
          ),
        ),
      ),
    ); //renders the ui from the given widget
    await tester.pump(); //advances time to
    final scaleFinder = find.text(
      "this is the generated scale in its midi numbered format [60, 62, 64, 65, 67, 69, 71, 72]",
    );
    expect(scaleFinder, findsOneWidget);
  });
}
