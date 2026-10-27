import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:class_track/features/classes/domain/entities/class_entity.dart';
import 'package:class_track/features/classes/domain/usecases/create_class_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/get_teacher_classes_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/join_class_by_code_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/check_student_enrollment_usecase.dart';
import 'package:class_track/features/classes/data/datasources/class_remote_data_source.dart';
import 'package:class_track/features/classes/data/repositories/class_repository_impl.dart';
import 'package:class_track/features/classes/presentation/bloc/classes_cubit.dart';
import 'package:class_track/features/classes/presentation/pages/student_classes_page.dart';
import 'package:class_track/features/classes/presentation/widgets/class_card.dart';

void main() {
  late InMemoryClassRemoteDataSource dataSource;
  late ClassRepositoryImpl repository;
  late ClassesCubit cubit;

  setUp(() {
    dataSource = InMemoryClassRemoteDataSource();
    repository = ClassRepositoryImpl(remoteDataSource: dataSource);
    cubit = ClassesCubit(
      createClassUseCase: CreateClassUseCase(repository),
      getTeacherClassesUseCase: GetTeacherClassesUseCase(repository),
      joinClassByCodeUseCase: JoinClassByCodeUseCase(repository),
      checkStudentEnrollmentUseCase: CheckStudentEnrollmentUseCase(repository),
    );
  });

  tearDown(() {
    cubit.close();
  });

  Widget createWidgetUnderTest({
    String studentName = 'Student',
    List<ClassEntity> initialClasses = const [],
  }) {
    return MaterialApp(
      home: BlocProvider<ClassesCubit>.value(
        value: cubit,
        child: StudentClassesPage(
          studentId: 'student_101',
          studentName: studentName,
          initialClasses: initialClasses,
        ),
      ),
    );
  }

  group('StudentClassesPage Widget Tests', () {
    testWidgets('should render ClassTrack title and Join class action button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('ClassTrack'), findsOneWidget);
      expect(find.text('Join class'), findsOneWidget);
    });

    testWidgets('shows greeting header with student name and empty subtitle', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(studentName: 'Ahmed'));
      await tester.pump();

      // Check student name in greeting
      expect(find.textContaining('Ahmed'), findsAtLeastNWidgets(1));

      // Check dynamic time greeting prefix
      final greetingFinder = find.byWidgetPredicate((w) =>
        w is Text &&
        (w.data?.contains('Good Morning') == true ||
         w.data?.contains('Good Afternoon') == true ||
         w.data?.contains('Good Evening') == true ||
         w.textSpan?.toPlainText().contains('Good Morning') == true ||
         w.textSpan?.toPlainText().contains('Good Afternoon') == true ||
         w.textSpan?.toPlainText().contains('Good Evening') == true)
      );
      expect(greetingFinder, findsOneWidget);

      // Check empty state subtitle in greeting header
      expect(find.text('Join your first class below'), findsOneWidget);
    });

    testWidgets('shows enrolled count subtitle when student has classes', (tester) async {
      final sampleClass = ClassEntity(
        id: 'c1',
        name: 'Operating Systems',
        courseCode: 'CS301',
        description: '',
        joinCode: 'OS2026',
        teacherId: 't1',
        teacherName: 'Dr. OS',
        enrolledStudentIds: const ['student_101'],
        createdAt: DateTime.now(),
        room: 'Lab 1',
        schedule: 'Tue • 10:00 AM',
        term: 'Fall 2026',
      );

      await tester.pumpWidget(createWidgetUnderTest(
        studentName: 'Ahmed',
        initialClasses: [sampleClass],
      ));
      await tester.pump();

      expect(find.text('You have 1 class enrolled'), findsOneWidget);
    });

    testWidgets('should render empty state when student has no classes yet', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No classes joined yet'), findsOneWidget);
      expect(find.text('Join your first class'), findsOneWidget);
    });

    testWidgets('should render ClassCard for pre-enrolled classes', (tester) async {
      final preEnrolled = ClassEntity(
        id: 'c1',
        name: 'Operating Systems',
        courseCode: 'CS301',
        description: '',
        joinCode: 'OS2026',
        teacherId: 't1',
        teacherName: 'Dr. OS',
        enrolledStudentIds: const ['student_101'],
        createdAt: DateTime.now(),
        room: 'Lab 1',
        schedule: 'Tue • 10:00 AM',
        term: 'Fall 2026',
      );

      await tester.pumpWidget(createWidgetUnderTest(initialClasses: [preEnrolled]));
      await tester.pumpAndSettle();

      expect(find.byType(ClassCard), findsOneWidget);
      expect(find.text('CS301 • Operating Systems'), findsOneWidget);
    });
  });
}
