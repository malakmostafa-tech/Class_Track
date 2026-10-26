import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/features/classes/domain/entities/class_entity.dart';
import 'package:class_track/features/classes/domain/repositories/class_repository.dart';
import 'package:class_track/features/classes/data/datasources/class_remote_data_source.dart';
import 'package:class_track/features/classes/data/repositories/class_repository_impl.dart';

void main() {
  late ClassRemoteDataSource dataSource;
  late ClassRepository repository;
  final testDate = DateTime(2026, 10, 18, 12, 0);

  final testEntity = ClassEntity(
    id: '',
    name: 'Computer Networks',
    courseCode: 'CS302',
    description: 'TCP/IP and Routing',
    joinCode: 'NET302',
    teacherId: 'teacher_net',
    teacherName: 'Dr. Net',
    enrolledStudentIds: const [],
    createdAt: testDate,
    isActive: true,
    room: 'Lab 2',
    schedule: 'Mon / Wed • 2:00 PM',
    term: 'Fall 2026',
  );

  setUp(() {
    dataSource = InMemoryClassRemoteDataSource();
    repository = ClassRepositoryImpl(remoteDataSource: dataSource);
  });

  group('ClassRepositoryImpl', () {
    test('should be a concrete implementation of ClassRepository', () {
      expect(repository, isA<ClassRepository>());
    });

    test('createClass should persist entity via dataSource and return ClassEntity with ID', () async {
      final created = await repository.createClass(testEntity);

      expect(created, isA<ClassEntity>());
      expect(created.id, isNotEmpty);
      expect(created.name, 'Computer Networks');
      expect(created.courseCode, 'CS302');
      expect(created.room, 'Lab 2');
    });

    test('getTeacherClasses should return list of domain ClassEntity objects', () async {
      await repository.createClass(testEntity);
      await repository.createClass(testEntity.copyWith(name: 'Wireless Networks'));

      final list = await repository.getTeacherClasses('teacher_net');

      expect(list.length, 2);
      expect(list.first, isA<ClassEntity>());
      expect(list.any((c) => c.name == 'Computer Networks'), isTrue);
      expect(list.any((c) => c.name == 'Wireless Networks'), isTrue);
    });

    test('getClassByJoinCode should return matching ClassEntity', () async {
      final created = await repository.createClass(testEntity);

      final result = await repository.getClassByJoinCode('NET302');
      expect(result, isNotNull);
      expect(result?.id, created.id);
      expect(result?.name, created.name);
    });

    test('joinClass and isStudentEnrolled should integrate properly through repository', () async {
      final created = await repository.createClass(testEntity);

      final isEnrolledBefore = await repository.isStudentEnrolled(
        classId: created.id,
        studentId: 'student_555',
      );
      expect(isEnrolledBefore, isFalse);

      await repository.joinClass(
        classId: created.id,
        studentId: 'student_555',
      );

      final isEnrolledAfter = await repository.isStudentEnrolled(
        classId: created.id,
        studentId: 'student_555',
      );
      expect(isEnrolledAfter, isTrue);
    });
  });
}
