import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:class_track/features/classes/domain/entities/class_entity.dart';
import 'package:class_track/features/classes/domain/usecases/create_class_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/get_teacher_classes_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/join_class_by_code_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/check_student_enrollment_usecase.dart';
import 'package:class_track/features/classes/data/datasources/class_remote_data_source.dart';
import 'package:class_track/features/classes/data/repositories/class_repository_impl.dart';
import 'package:class_track/features/classes/presentation/bloc/classes_state.dart';
import 'package:class_track/features/classes/presentation/bloc/classes_cubit.dart';

void main() {
  late InMemoryClassRemoteDataSource dataSource;
  late ClassRepositoryImpl repository;
  late CreateClassUseCase createClassUseCase;
  late GetTeacherClassesUseCase getTeacherClassesUseCase;
  late JoinClassByCodeUseCase joinClassByCodeUseCase;
  late CheckStudentEnrollmentUseCase checkStudentEnrollmentUseCase;

  setUp(() {
    dataSource = InMemoryClassRemoteDataSource();
    repository = ClassRepositoryImpl(remoteDataSource: dataSource);
    createClassUseCase = CreateClassUseCase(repository);
    getTeacherClassesUseCase = GetTeacherClassesUseCase(repository);
    joinClassByCodeUseCase = JoinClassByCodeUseCase(repository);
    checkStudentEnrollmentUseCase = CheckStudentEnrollmentUseCase(repository);
  });

  ClassesCubit buildCubit() {
    return ClassesCubit(
      createClassUseCase: createClassUseCase,
      getTeacherClassesUseCase: getTeacherClassesUseCase,
      joinClassByCodeUseCase: joinClassByCodeUseCase,
      checkStudentEnrollmentUseCase: checkStudentEnrollmentUseCase,
    );
  }

  group('ClassesCubit', () {
    test('initial state should be ClassesInitial', () {
      final cubit = buildCubit();
      expect(cubit.state, isA<ClassesInitial>());
      cubit.close();
    });

    blocTest<ClassesCubit, ClassesState>(
      'loadTeacherClasses emits [ClassesLoading, TeacherClassesLoaded] on success',
      build: buildCubit,
      setUp: () async {
        await createClassUseCase(const CreateClassParams(
          name: 'Algorithms',
          courseCode: 'CS201',
          description: 'Sorting',
          teacherId: 'teacher_tarek',
          teacherName: 'Dr. Tarek',
        ));
      },
      act: (cubit) => cubit.loadTeacherClasses('teacher_tarek'),
      expect: () => [
        isA<ClassesLoading>(),
        isA<TeacherClassesLoaded>().having(
          (s) => s.classes.length,
          'classes length',
          1,
        ),
      ],
    );

    blocTest<ClassesCubit, ClassesState>(
      'createClass emits [ClassesLoading, ClassCreatedSuccess] on valid parameters',
      build: buildCubit,
      act: (cubit) => cubit.createClass(const CreateClassParams(
        name: 'Mobile Programming II',
        courseCode: 'CS402',
        description: 'Flutter Clean Architecture',
        teacherId: 'teacher_1',
        teacherName: 'Dr. Ahmed',
      )),
      expect: () => [
        isA<ClassesLoading>(),
        isA<ClassCreatedSuccess>().having(
          (s) => s.newClass.name,
          'class name',
          'Mobile Programming II',
        ),
      ],
    );

    blocTest<ClassesCubit, ClassesState>(
      'createClass emits [ClassesLoading, ClassesError] when params are invalid',
      build: buildCubit,
      act: (cubit) => cubit.createClass(const CreateClassParams(
        name: '', // Empty name triggers validation failure
        courseCode: '',
        description: '',
        teacherId: '',
        teacherName: '',
      )),
      expect: () => [
        isA<ClassesLoading>(),
        isA<ClassesError>(),
      ],
    );

    late ClassEntity activeClass;

    blocTest<ClassesCubit, ClassesState>(
      'joinClassByCode emits [ClassesLoading, ClassJoinedSuccess] when join code is valid',
      build: buildCubit,
      setUp: () async {
        activeClass = await createClassUseCase(const CreateClassParams(
          name: 'Database Systems',
          courseCode: 'CS202',
          description: 'SQL & NoSQL',
          teacherId: 'teacher_1',
          teacherName: 'Dr. Ahmed',
        ));
      },
      act: (cubit) => cubit.joinClassByCode(
        joinCode: activeClass.joinCode,
        studentId: 'student_99',
      ),
      expect: () => [
        isA<ClassesLoading>(),
        isA<ClassJoinedSuccess>().having(
          (s) => s.joinedClass.enrolledStudentIds,
          'enrolled students',
          contains('student_99'),
        ),
      ],
    );

    blocTest<ClassesCubit, ClassesState>(
      'joinClassByCode emits [ClassesLoading, ClassesError] when join code is non-existent',
      build: buildCubit,
      act: (cubit) => cubit.joinClassByCode(
        joinCode: 'INVALID',
        studentId: 'student_99',
      ),
      expect: () => [
        isA<ClassesLoading>(),
        isA<ClassesError>(),
      ],
    );

    blocTest<ClassesCubit, ClassesState>(
      'checkEnrollment emits [ClassesLoading, EnrollmentStatusChecked]',
      build: buildCubit,
      setUp: () async {
        activeClass = await createClassUseCase(const CreateClassParams(
          name: 'Security',
          courseCode: 'CS305',
          description: 'Network Security',
          teacherId: 'teacher_1',
          teacherName: 'Dr. Ahmed',
        ));
      },
      act: (cubit) => cubit.checkEnrollment(
        classId: activeClass.id,
        studentId: 'student_unregistered',
      ),
      expect: () => [
        isA<ClassesLoading>(),
        isA<EnrollmentStatusChecked>().having(
          (s) => s.isEnrolled,
          'isEnrolled',
          isFalse,
        ),
      ],
    );
  });
}
