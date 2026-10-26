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
import 'package:class_track/features/classes/presentation/pages/teacher_classes_page.dart';
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

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ClassesCubit>.value(
        value: cubit,
        child: const TeacherClassesPage(
          teacherId: 'teacher_tarek',
          teacherName: 'Dr. Tarek',
        ),
      ),
    );
  }

  group('TeacherClassesPage Widget Tests', () {
    testWidgets('should render AppBar title and Create Class button', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('My Classes'), findsOneWidget);
      expect(find.text('Create class'), findsOneWidget);
    });

    testWidgets('should render empty state message when doctor has no classes', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No classes created yet'), findsOneWidget);
    });

    testWidgets('should render ClassCard when classes are loaded', (tester) async {
      // Pre-populate class in the repository
      await repository.createClass(ClassEntity(
        id: 'c1',
        name: 'Database Systems',
        courseCode: 'CS202',
        description: 'SQL',
        joinCode: 'DB2026',
        teacherId: 'teacher_tarek',
        teacherName: 'Dr. Tarek',
        enrolledStudentIds: const [],
        createdAt: DateTime.now(),
        isActive: true,
        room: 'Hall 1',
        schedule: 'Sun • 10:00 AM',
        term: 'Fall 2026',
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ClassCard), findsOneWidget);
      expect(find.text('CS202 • Database Systems'), findsOneWidget);
    });

    testWidgets('should filter classes based on search query', (tester) async {
      await repository.createClass(ClassEntity(
        id: 'c1',
        name: 'Algorithms',
        courseCode: 'CS201',
        description: '',
        joinCode: 'ALG001',
        teacherId: 'teacher_tarek',
        teacherName: 'Dr. Tarek',
        createdAt: DateTime.now(),
      ));
      await repository.createClass(ClassEntity(
        id: 'c2',
        name: 'Web Development',
        courseCode: 'CS308',
        description: '',
        joinCode: 'WEB002',
        teacherId: 'teacher_tarek',
        teacherName: 'Dr. Tarek',
        createdAt: DateTime.now(),
      ));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ClassCard), findsNWidgets(2));

      // Enter search query
      await tester.enterText(find.byType(TextField), 'Web');
      await tester.pumpAndSettle();

      expect(find.text('CS308 • Web Development'), findsOneWidget);
      expect(find.text('CS201 • Algorithms'), findsNothing);
    });
  });
}
