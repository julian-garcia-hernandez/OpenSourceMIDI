import 'package:flutter_test/flutter_test.dart';
import 'package:opensource_midi/main.dart';

void main() {

  testWidgets("ScaleGenerator loads C Major by default", (tester) async {
    await tester.pumpWidget(const ScaleGenerator());
    final scaleFinder = find.text("C, D, E, F, G, A, B, C");
    expect(scaleFinder, findsOneWidget);
  });
}
