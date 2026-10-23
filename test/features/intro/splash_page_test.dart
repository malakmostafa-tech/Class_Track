import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:class_track/app/router/app_routes.dart';
import 'package:class_track/core/theme/theme.dart';
import 'package:class_track/features/intro/presentation/pages/splash_page.dart';

void main() {
  Widget buildTestWidget({Duration? duration}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: SplashPage(
        displayDuration: duration ?? const Duration(milliseconds: 500),
      ),
      routes: {
        AppRoutes.intro: (context) => const Scaffold(
              body: Text('Intro Destination'),
            ),
      },
    );
  }

  testWidgets('SplashPage renders brand logo, title, and slogan',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());

    expect(find.text('ClassTrack'), findsOneWidget);
    expect(
      find.text('University attendance,\nconnected to your classroom.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);

    // Drain timer to prevent pending timer error
    await tester.pumpAndSettle();
  });

  testWidgets('SplashPage auto-navigates to Intro after timeout',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(duration: const Duration(milliseconds: 300)),
    );

    expect(find.text('Intro Destination'), findsNothing);

    // Fast-forward past splash duration
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    expect(find.text('Intro Destination'), findsOneWidget);
  });

  testWidgets('SplashPage tap navigates to Intro immediately',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestWidget(duration: const Duration(seconds: 10)),
    );

    expect(find.text('Intro Destination'), findsNothing);

    // Tap anywhere on splash to skip
    await tester.tap(find.byType(SplashPage));
    await tester.pumpAndSettle();

    expect(find.text('Intro Destination'), findsOneWidget);
  });
}
