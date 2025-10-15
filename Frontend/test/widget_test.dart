import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('Cricket Scoreboard app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CricketScoreboardApp());

    // Verify that the home screen loads
    expect(find.text('Cricket Scoreboard'), findsOneWidget);

    // Verify that action cards are present
    expect(find.text('New Match'), findsOneWidget);
  });

  testWidgets('Navigation to match setup works', (WidgetTester tester) async {
    await tester.pumpWidget(const CricketScoreboardApp());

    // Find and tap the New Match button
    await tester.tap(find.text('New Match'));
    await tester.pumpAndSettle();

    // Verify navigation to match setup screen
    expect(find.text('Setup New Match'), findsOneWidget);
  });
}
