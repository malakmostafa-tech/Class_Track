import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:class_track/app/router/app_routes.dart';
import 'package:class_track/core/theme/theme.dart';
import 'package:class_track/features/intro/presentation/pages/intro_page.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const IntroPage(),
      routes: {
        AppRoutes.register: (context) => const Scaffold(
              body: Text('Register Screen'),
            ),
        AppRoutes.login: (context) => const Scaffold(
              body: Text('Login Screen'),
            ),
      },
    );
  }

  testWidgets('IntroPage displays header logo, headlines, and all three feature cards',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Verify Brand Logo in Header
    expect(find.text('ClassTrack'), findsOneWidget);
    expect(find.byIcon(Icons.school_rounded), findsOneWidget);

    // Verify Hero Headlines
    expect(find.text('Your class.\nYour presence.'), findsOneWidget);
    expect(
      find.text('Attendance and quick quizzes, all in one place.'),
      findsOneWidget,
    );

    // Verify Card 1
    expect(find.text('Connected to your classroom'), findsOneWidget);
    expect(find.text('A simple check. A clear record.'), findsOneWidget);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    // Verify Card 2
    expect(find.text('Location-verified attendance'), findsOneWidget);
    expect(
      find.text(
        "See active sessions anywhere. Attend within your teacher's allowed radius.",
      ),
      findsOneWidget,
    );

    // Verify Card 3
    expect(find.text('Timed in-app quizzes'), findsOneWidget);
    expect(
      find.text('Answer in the time left in the 2-minute session.'),
      findsOneWidget,
    );
    expect(find.text("A perfect score isn't required."), findsOneWidget);

    // Verify Action Buttons
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Already have an account? '), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('Tapping "Get started" navigates to Register route',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final Finder getStartedFinder = find.text('Get started');
    await tester.ensureVisible(getStartedFinder);
    await tester.tap(getStartedFinder);
    await tester.pumpAndSettle();

    expect(find.text('Register Screen'), findsOneWidget);
  });

  testWidgets('Tapping "Sign in" navigates to Login route',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    final Finder signInFinder = find.text('Sign in');
    await tester.ensureVisible(signInFinder);
    await tester.tap(signInFinder);
    await tester.pumpAndSettle();

    expect(find.text('Login Screen'), findsOneWidget);
  });
}
