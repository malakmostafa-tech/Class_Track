import 'package:flutter_test/flutter_test.dart';
import 'package:class_track/features/classes/domain/entities/class_entity.dart';

void main() {
  final testDate = DateTime(2026, 10, 18, 12, 0);

  final testClass = ClassEntity(
    id: 'class_001',
    name: 'Mobile Programming II',
    courseCode: 'CS402',
    description: 'Flutter and Clean Architecture course',
    joinCode: 'CT89AB',
    teacherId: 'teacher_123',
    teacherName: 'Dr. Ahmed',
    enrolledStudentIds: const ['student_1', 'student_2'],
    createdAt: testDate,
    isActive: true,
  );

  group('ClassEntity', () {
    test('should properly instantiate with all required properties', () {
      expect(testClass.id, 'class_001');
      expect(testClass.name, 'Mobile Programming II');
      expect(testClass.courseCode, 'CS402');
      expect(testClass.description, 'Flutter and Clean Architecture course');
      expect(testClass.joinCode, 'CT89AB');
      expect(testClass.teacherId, 'teacher_123');
      expect(testClass.teacherName, 'Dr. Ahmed');
      expect(testClass.enrolledStudentIds, ['student_1', 'student_2']);
      expect(testClass.createdAt, testDate);
      expect(testClass.isActive, isTrue);
    });

    test('studentCount should return exact count of enrolledStudentIds', () {
      expect(testClass.studentCount, 2);

      final emptyClass = testClass.copyWith(enrolledStudentIds: const []);
      expect(emptyClass.studentCount, 0);
    });

    test('copyWith should return a new updated instance while preserving unchanged fields', () {
      final updatedClass = testClass.copyWith(
        name: 'Advanced Mobile Programming',
        isActive: false,
      );

      expect(updatedClass.id, testClass.id);
      expect(updatedClass.name, 'Advanced Mobile Programming');
      expect(updatedClass.isActive, isFalse);
      expect(updatedClass.joinCode, testClass.joinCode);
      expect(updatedClass.enrolledStudentIds, testClass.enrolledStudentIds);
    });

    test('entities with identical properties should be equal and have identical hashCode', () {
      final duplicateClass = ClassEntity(
        id: 'class_001',
        name: 'Mobile Programming II',
        courseCode: 'CS402',
        description: 'Flutter and Clean Architecture course',
        joinCode: 'CT89AB',
        teacherId: 'teacher_123',
        teacherName: 'Dr. Ahmed',
        enrolledStudentIds: const ['student_1', 'student_2'],
        createdAt: testDate,
        isActive: true,
      );

      expect(testClass, equals(duplicateClass));
      expect(testClass.hashCode, equals(duplicateClass.hashCode));
    });
  });
}
