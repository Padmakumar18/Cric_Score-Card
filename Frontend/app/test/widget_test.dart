// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:cricket_scoreboard/main.dart';
import 'package:cricket_scoreboard/providers/auth_provider.dart';

void main() {
  testWidgets('Cricket Scoreboard app smoke test', (WidgetTester tester) async {
    // Create auth provider for testing
    final authProvider = AuthProvider();
    await authProvider.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(CricketScoreboardApp(authProvider: authProvider));

    // Verify that our app starts with the auth screen
    expect(find.text('Cricket Scoreboard'), findsOneWidget);
  });
}
