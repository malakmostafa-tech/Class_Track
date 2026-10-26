import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/features/classes/domain/entities/class_entity.dart';
import 'package:class_track/features/classes/data/models/class_model.dart';

/// Fake object simulating Firestore's Timestamp for unit test isolation.
class FakeFirestoreTimestamp {
  final DateTime date;
  FakeFirestoreTimestamp(this.date);

  DateTime toDate() => date;
}

void main() {
  final testDate = DateTime(2026, 10, 18, 12, 0, 0);

  final testClassModel = ClassModel(
    id: 'class_101',
    name: 'Data Structures',
    courseCode: 'CS201',
    description: 'Algorithms and Data Structures',
    joinCode: 'DS2026',
    teacherId: 'teacher_maya',
    teacherName: 'Dr. Maya Chen',
    enrolledStudentIds: const ['student_1', 'student_2'],
    createdAt: testDate,
    isActive: true,
    room: 'Engineering 204',
    schedule: 'Mon / Wed • 10:00 AM',
    term: 'Fall 2026',
  );

  group('ClassModel', () {
    test('should be a subclass of ClassEntity', () {
      expect(testClassModel, isA<ClassEntity>());
    });

    group('fromMap', () {
      test('should parse a complete map with all valid fields', () {
        final map = <String, dynamic>{
          'name': 'Data Structures',
          'courseCode': 'CS201',
          'description': 'Algorithms and Data Structures',
          'joinCode': 'DS2026',
          'teacherId': 'teacher_maya',
          'teacherName': 'Dr. Maya Chen',
          'enrolledStudentIds': ['student_1', 'student_2'],
          'createdAt': testDate.toIso8601String(),
          'isActive': true,
          'room': 'Engineering 204',
          'schedule': 'Mon / Wed • 10:00 AM',
          'term': 'Fall 2026',
        };

        final result = ClassModel.fromMap(map, 'class_101');

        expect(result.id, 'class_101');
        expect(result.name, 'Data Structures');
        expect(result.courseCode, 'CS201');
        expect(result.description, 'Algorithms and Data Structures');
        expect(result.joinCode, 'DS2026');
        expect(result.teacherId, 'teacher_maya');
        expect(result.teacherName, 'Dr. Maya Chen');
        expect(result.enrolledStudentIds, ['student_1', 'student_2']);
        expect(result.createdAt, testDate);
        expect(result.isActive, isTrue);
        expect(result.room, 'Engineering 204');
        expect(result.schedule, 'Mon / Wed • 10:00 AM');
        expect(result.term, 'Fall 2026');
      });

      test('should safely handle missing optional fields with default values', () {
        final minimalMap = <String, dynamic>{
          'name': 'Minimal Class',
          'courseCode': 'MC101',
          'joinCode': 'MIN101',
          'teacherId': 't_min',
          'teacherName': 'Dr. Min',
          'createdAt': testDate.millisecondsSinceEpoch,
        };

        final result = ClassModel.fromMap(minimalMap, 'min_01');

        expect(result.id, 'min_01');
        expect(result.name, 'Minimal Class');
        expect(result.courseCode, 'MC101');
        expect(result.description, isEmpty);
        expect(result.enrolledStudentIds, isEmpty);
        expect(result.isActive, isTrue);
        expect(result.room, isEmpty);
        expect(result.schedule, isEmpty);
        expect(result.term, isEmpty);
      });

      test('should parse createdAt from Firestore Timestamp object (having toDate())', () {
        final map = <String, dynamic>{
          'name': 'Test',
          'courseCode': 'T100',
          'joinCode': 'TJ100',
          'teacherId': 't1',
          'teacherName': 'Dr. T',
          'createdAt': FakeFirestoreTimestamp(testDate),
        };

        final result = ClassModel.fromMap(map, 'c1');
        expect(result.createdAt, testDate);
      });

      test('should safely convert List<dynamic> into List<String> without runtime type errors', () {
        final dynamicListMap = <String, dynamic>{
          'name': 'Test',
          'courseCode': 'T100',
          'joinCode': 'TJ100',
          'teacherId': 't1',
          'teacherName': 'Dr. T',
          'enrolledStudentIds': <dynamic>['std_A', 'std_B'],
          'createdAt': testDate.toIso8601String(),
        };

        final result = ClassModel.fromMap(dynamicListMap, 'c1');
        expect(result.enrolledStudentIds, isA<List<String>>());
        expect(result.enrolledStudentIds, ['std_A', 'std_B']);
      });
    });

    group('toMap', () {
      test('should return a JSON map containing all required Firestore properties', () {
        final map = testClassModel.toMap();

        expect(map['name'], 'Data Structures');
        expect(map['courseCode'], 'CS201');
        expect(map['description'], 'Algorithms and Data Structures');
        expect(map['joinCode'], 'DS2026');
        expect(map['teacherId'], 'teacher_maya');
        expect(map['teacherName'], 'Dr. Maya Chen');
        expect(map['enrolledStudentIds'], ['student_1', 'student_2']);
        expect(map['createdAt'], testDate.toIso8601String());
        expect(map['isActive'], isTrue);
        expect(map['room'], 'Engineering 204');
        expect(map['schedule'], 'Mon / Wed • 10:00 AM');
        expect(map['term'], 'Fall 2026');
      });
    });

    group('Entity conversion (toEntity & fromEntity)', () {
      test('toEntity should return a pure ClassEntity with matching properties', () {
        final entity = testClassModel.toEntity();

        expect(entity, isA<ClassEntity>());
        expect(entity.id, testClassModel.id);
        expect(entity.name, testClassModel.name);
        expect(entity.room, testClassModel.room);
        expect(entity.schedule, testClassModel.schedule);
        expect(entity.term, testClassModel.term);
      });

      test('fromEntity should construct a ClassModel from a ClassEntity instance', () {
        final entity = ClassEntity(
          id: 'ent_1',
          name: 'Database Systems',
          courseCode: 'CS202',
          description: 'SQL & NoSQL',
          joinCode: 'DB2026',
          teacherId: 't_db',
          teacherName: 'Dr. DB',
          enrolledStudentIds: const ['s1'],
          createdAt: testDate,
          isActive: true,
          room: 'Lab 3',
          schedule: 'Sun / Tue • 12:00 PM',
          term: 'Fall 2026',
        );

        final model = ClassModel.fromEntity(entity);

        expect(model.id, entity.id);
        expect(model.name, entity.name);
        expect(model.courseCode, entity.courseCode);
        expect(model.room, 'Lab 3');
        expect(model.schedule, 'Sun / Tue • 12:00 PM');
        expect(model.term, 'Fall 2026');
      });
    });
  });
}
