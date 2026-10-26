import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/features/classes/presentation/widgets/join_class_dialog.dart';

void main() {
  Widget createWidgetUnderTest({required Function(String code) onSubmit}) {
    return MaterialApp(
      home: Scaffold(
        body: JoinClassDialog(onSubmit: onSubmit),
      ),
    );
  }

  group('JoinClassDialog Widget Tests', () {
    testWidgets('should render title, input field, and action buttons', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      expect(find.text('Join a class'), findsOneWidget);
      expect(find.text('Enter 6-character code'), findsOneWidget);
      expect(find.text('Join class'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should show validation error when submitted empty or less than 6 characters', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(onSubmit: (_) {}));

      // Tap submit with empty field
      await tester.tap(find.text('Join class'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid 6-character code'), findsOneWidget);

      // Enter 4 characters
      await tester.enterText(find.byType(TextFormField), 'ABCD');
      await tester.tap(find.text('Join class'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid 6-character code'), findsOneWidget);
    });

    testWidgets('should submit uppercase code when valid 6 characters are entered', (tester) async {
      String? submittedCode;

      await tester.pumpWidget(createWidgetUnderTest(
        onSubmit: (code) => submittedCode = code,
      ));

      await tester.enterText(find.byType(TextFormField), 'ct89ab');
      await tester.tap(find.text('Join class'));
      await tester.pumpAndSettle();

      expect(submittedCode, 'CT89AB');
    });
  });
}
