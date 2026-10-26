import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/features/classes/domain/entities/class_entity.dart';
import 'package:class_track/features/classes/presentation/widgets/class_card.dart';

void main() {
  final testEntity = ClassEntity(
    id: 'c1',
    name: 'Data Structures',
    courseCode: 'CS201',
    description: 'Algorithms and Data Structures',
    joinCode: 'DS2026',
    teacherId: 't1',
    teacherName: 'Dr. Maya Chen',
    enrolledStudentIds: const ['s1', 's2'],
    createdAt: DateTime(2026, 10, 18),
    isActive: true,
    room: 'Engineering 204',
    schedule: 'Mon / Wed • 10:00 AM',
    term: 'Fall 2026',
  );

  Widget createWidgetUnderTest({VoidCallback? onTap}) {
    return MaterialApp(
      home: Scaffold(
        body: ClassCard(
          classEntity: testEntity,
          onTap: onTap,
        ),
      ),
    );
  }

  group('ClassCard Widget', () {
    testWidgets('should render courseCode and name correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('CS201 • Data Structures'), findsOneWidget);
    });

    testWidgets('should render term and enrolled student count badge', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Fall 2026 • 2 students'), findsOneWidget);
    });

    testWidgets('should render schedule and room', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Mon / Wed • 10:00 AM • Engineering 204'), findsOneWidget);
    });

    testWidgets('should render Active status badge', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('should trigger onTap callback when clicked', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(createWidgetUnderTest(
        onTap: () => wasTapped = true,
      ));

      await tester.tap(find.byType(ClassCard));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });
  });
}
