import 'package:flutter_test/flutter_test.dart';

import 'package:class_track/main.dart';

void main() {
  testWidgets('App initializes with Splash screen on startup', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that ClassTrack brand title and subtitle render.
    expect(find.text('ClassTrack'), findsOneWidget);
    expect(
      find.text('University attendance,\nconnected to your classroom.'),
      findsOneWidget,
    );
  });
}
