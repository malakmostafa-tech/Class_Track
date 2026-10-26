import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/features/classes/domain/entities/class_entity.dart';
import 'package:class_track/features/classes/domain/repositories/class_repository.dart';
import 'package:class_track/features/classes/domain/errors/class_exceptions.dart';
import 'package:class_track/features/classes/domain/usecases/create_class_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/get_teacher_classes_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/join_class_by_code_usecase.dart';
import 'package:class_track/features/classes/domain/usecases/check_student_enrollment_usecase.dart';

/// In-memory fake repository implementation for fast, isolated domain unit testing.
class FakeClassRepository implements ClassRepository {
  final Map<String, ClassEntity> _classes = {};

  @override
  Future<ClassEntity> createClass(ClassEntity newClass) async {
    final classWithId = newClass.id.isEmpty
        ? newClass.copyWith(id: 'generated_${_classes.length + 1}')
        : newClass;
    _classes[classWithId.id] = classWithId;
    return classWithId;
  }

  @override
  Future<List<ClassEntity>> getTeacherClasses(String teacherId) async {
    return _classes.values
        .where((c) => c.teacherId == teacherId)
        .toList();
  }

  @override
  Future<ClassEntity?> getClassById(String classId) async {
    return _classes[classId];
  }

  @override
  Future<ClassEntity?> getClassByJoinCode(String joinCode) async {
    try {
      return _classes.values.firstWhere(
        (c) => c.joinCode.toUpperCase() == joinCode.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> joinClass({
    required String classId,
    required String studentId,
  }) async {
    final existing = _classes[classId];
    if (existing == null) throw const ClassNotFoundException();
    if (!existing.isActive) throw const ClassNotActiveException();
    if (existing.enrolledStudentIds.contains(studentId)) {
      throw const StudentAlreadyEnrolledException();
    }

    final updated = existing.copyWith(
      enrolledStudentIds: [...existing.enrolledStudentIds, studentId],
    );
    _classes[classId] = updated;
  }

  @override
  Future<bool> isStudentEnrolled({
    required String classId,
    required String studentId,
  }) async {
    final existing = _classes[classId];
    if (existing == null) return false;
    return existing.enrolledStudentIds.contains(studentId);
  }
}

void main() {
  late FakeClassRepository fakeRepository;
  late CreateClassUseCase createClassUseCase;
  late GetTeacherClassesUseCase getTeacherClassesUseCase;
  late JoinClassByCodeUseCase joinClassByCodeUseCase;
  late CheckStudentEnrollmentUseCase checkStudentEnrollmentUseCase;

  setUp(() {
    fakeRepository = FakeClassRepository();
    createClassUseCase = CreateClassUseCase(fakeRepository);
    getTeacherClassesUseCase = GetTeacherClassesUseCase(fakeRepository);
    joinClassByCodeUseCase = JoinClassByCodeUseCase(fakeRepository);
    checkStudentEnrollmentUseCase = CheckStudentEnrollmentUseCase(fakeRepository);
  });

  group('CreateClassUseCase', () {
    test('should create and store a class with auto-generated joinCode and active status', () async {
      const params = CreateClassParams(
        name: 'Mobile Programming II',
        courseCode: 'CS402',
        description: 'Clean Architecture with Flutter',
        teacherId: 'teacher_99',
        teacherName: 'Dr. Tarek',
      );

      final result = await createClassUseCase(params);

      expect(result.id, isNotEmpty);
      expect(result.name, 'Mobile Programming II');
      expect(result.courseCode, 'CS402');
      expect(result.teacherId, 'teacher_99');
      expect(result.teacherName, 'Dr. Tarek');
      expect(result.joinCode.length, 6);
      expect(result.isActive, isTrue);
      expect(result.enrolledStudentIds, isEmpty);
      expect(result.studentCount, 0);
    });

    test('should throw InvalidClassDataException when required fields are blank', () async {
      expect(
        () => createClassUseCase(const CreateClassParams(
          name: '',
          courseCode: 'CS402',
          description: '',
          teacherId: 't1',
          teacherName: 'Dr. Test',
        )),
        throwsA(isA<InvalidClassDataException>()),
      );
    });
  });

  group('GetTeacherClassesUseCase', () {
    test('should return only classes owned by the requested teacher', () async {
      await createClassUseCase(const CreateClassParams(
        name: 'Algorithms',
        courseCode: 'CS201',
        description: 'Sorting and graphs',
        teacherId: 'teacher_A',
        teacherName: 'Dr. A',
      ));
      await createClassUseCase(const CreateClassParams(
        name: 'Data Structures',
        courseCode: 'CS202',
        description: 'Trees and hashes',
        teacherId: 'teacher_A',
        teacherName: 'Dr. A',
      ));
      await createClassUseCase(const CreateClassParams(
        name: 'Operating Systems',
        courseCode: 'CS301',
        description: 'Threads and memory',
        teacherId: 'teacher_B',
        teacherName: 'Dr. B',
      ));

      final teacherAClasses = await getTeacherClassesUseCase('teacher_A');
      final teacherBClasses = await getTeacherClassesUseCase('teacher_B');

      expect(teacherAClasses.length, 2);
      expect(teacherBClasses.length, 1);
      expect(teacherBClasses.first.name, 'Operating Systems');
    });

    test('should return empty list when teacher has no classes', () async {
      final classes = await getTeacherClassesUseCase('unknown_teacher');
      expect(classes, isEmpty);
    });
  });

  group('JoinClassByCodeUseCase', () {
    test('should successfully join an existing active class by code', () async {
      final createdClass = await createClassUseCase(const CreateClassParams(
        name: 'Mobile Programming',
        courseCode: 'CS402',
        description: 'Flutter',
        teacherId: 't1',
        teacherName: 'Dr. T',
      ));

      final joinedClass = await joinClassByCodeUseCase(JoinClassParams(
        joinCode: createdClass.joinCode.toLowerCase(), // test case-insensitivity
        studentId: 'student_101',
      ));

      expect(joinedClass.id, createdClass.id);
      expect(joinedClass.enrolledStudentIds, contains('student_101'));
      expect(joinedClass.studentCount, 1);
    });

    test('should throw ClassNotFoundException when join code does not match any class', () async {
      expect(
        () => joinClassByCodeUseCase(const JoinClassParams(
          joinCode: 'NONEXS',
          studentId: 'student_101',
        )),
        throwsA(isA<ClassNotFoundException>()),
      );
    });

    test('should throw StudentAlreadyEnrolledException if student joins twice', () async {
      final createdClass = await createClassUseCase(const CreateClassParams(
        name: 'Mobile Programming',
        courseCode: 'CS402',
        description: 'Flutter',
        teacherId: 't1',
        teacherName: 'Dr. T',
      ));

      await joinClassByCodeUseCase(JoinClassParams(
        joinCode: createdClass.joinCode,
        studentId: 'student_101',
      ));

      expect(
        () => joinClassByCodeUseCase(JoinClassParams(
          joinCode: createdClass.joinCode,
          studentId: 'student_101',
        )),
        throwsA(isA<StudentAlreadyEnrolledException>()),
      );
    });

    test('should throw ClassNotActiveException if class isActive is false', () async {
      final createdClass = await createClassUseCase(const CreateClassParams(
        name: 'Archived Course',
        courseCode: 'CS100',
        description: 'Old course',
        teacherId: 't1',
        teacherName: 'Dr. T',
      ));

      // Deactivate class in repository
      final deactivated = createdClass.copyWith(isActive: false);
      fakeRepository._classes[deactivated.id] = deactivated;

      expect(
        () => joinClassByCodeUseCase(JoinClassParams(
          joinCode: createdClass.joinCode,
          studentId: 'student_101',
        )),
        throwsA(isA<ClassNotActiveException>()),
      );
    });
  });

  group('CheckStudentEnrollmentUseCase', () {
    test('should return true when student is enrolled and false otherwise', () async {
      final createdClass = await createClassUseCase(const CreateClassParams(
        name: 'Security',
        courseCode: 'CS500',
        description: 'Network Security',
        teacherId: 't1',
        teacherName: 'Dr. S',
      ));

      final beforeJoin = await checkStudentEnrollmentUseCase(EnrollmentParams(
        classId: createdClass.id,
        studentId: 'student_777',
      ));
      expect(beforeJoin, isFalse);

      await joinClassByCodeUseCase(JoinClassParams(
        joinCode: createdClass.joinCode,
        studentId: 'student_777',
      ));

      final afterJoin = await checkStudentEnrollmentUseCase(EnrollmentParams(
        classId: createdClass.id,
        studentId: 'student_777',
      ));
      expect(afterJoin, isTrue);
    });
  });
}
