import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/features/classes/data/datasources/class_remote_data_source.dart';
import 'package:class_track/features/classes/data/models/class_model.dart';
import 'package:class_track/features/classes/domain/errors/class_exceptions.dart';

void main() {
  late ClassRemoteDataSource dataSource;
  final testDate = DateTime(2026, 10, 18, 12, 0);

  final sampleModel = ClassModel(
    id: '',
    name: 'Operating Systems',
    courseCode: 'CS301',
    description: 'Processes and Threads',
    joinCode: 'OS301X',
    teacherId: 'teacher_os',
    teacherName: 'Dr. OS',
    enrolledStudentIds: const [],
    createdAt: testDate,
    isActive: true,
    room: 'Hall A',
    schedule: 'Sun / Tue • 9:00 AM',
    term: 'Fall 2026',
  );

  setUp(() {
    dataSource = InMemoryClassRemoteDataSource();
  });

  group('InMemoryClassRemoteDataSource', () {
    test('createClass should store model and assign a unique ID if empty', () async {
      final created = await dataSource.createClass(sampleModel);

      expect(created.id, isNotEmpty);
      expect(created.name, 'Operating Systems');
      expect(created.joinCode, 'OS301X');

      final fetched = await dataSource.getClassById(created.id);
      expect(fetched, isNotNull);
      expect(fetched?.id, created.id);
    });

    test('getTeacherClasses should return all classes owned by teacherId', () async {
      await dataSource.createClass(sampleModel);
      await dataSource.createClass(sampleModel.copyWith(name: 'Advanced OS'));
      await dataSource.createClass(sampleModel.copyWith(teacherId: 'other_teacher'));

      final list = await dataSource.getTeacherClasses('teacher_os');
      expect(list.length, 2);
      expect(list.every((c) => c.teacherId == 'teacher_os'), isTrue);
    });

    test('getClassByJoinCode should return matching class case-insensitively', () async {
      final created = await dataSource.createClass(sampleModel);

      final matchUpper = await dataSource.getClassByJoinCode('OS301X');
      final matchLower = await dataSource.getClassByJoinCode('os301x');

      expect(matchUpper?.id, created.id);
      expect(matchLower?.id, created.id);
    });

    test('getClassByJoinCode should return null when code is not found', () async {
      final notFound = await dataSource.getClassByJoinCode('UNKNOWN');
      expect(notFound, isNull);
    });

    test('joinClass should append studentId to enrolledStudentIds', () async {
      final created = await dataSource.createClass(sampleModel);

      await dataSource.joinClass(classId: created.id, studentId: 'std_99');

      final updated = await dataSource.getClassById(created.id);
      expect(updated?.enrolledStudentIds, contains('std_99'));
      expect(updated?.studentCount, 1);
    });

    test('joinClass should throw ClassNotFoundException if classId does not exist', () async {
      expect(
        () => dataSource.joinClass(classId: 'invalid_id', studentId: 'std_99'),
        throwsA(isA<ClassNotFoundException>()),
      );
    });

    test('isStudentEnrolled should return true only after student joins', () async {
      final created = await dataSource.createClass(sampleModel);

      final before = await dataSource.isStudentEnrolled(
        classId: created.id,
        studentId: 'std_100',
      );
      expect(before, isFalse);

      await dataSource.joinClass(classId: created.id, studentId: 'std_100');

      final after = await dataSource.isStudentEnrolled(
        classId: created.id,
        studentId: 'std_100',
      );
      expect(after, isTrue);
    });
  });
}
