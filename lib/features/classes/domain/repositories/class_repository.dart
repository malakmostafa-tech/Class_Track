import '../entities/class_entity.dart';

/// Abstract contract defining the data operations for classes management.
///
/// Following Clean Architecture's Dependency Inversion Principle, the domain
/// layer defines this interface without knowing whether data comes from
/// Cloud Firestore, an SQLite local database, or an in-memory mock.
abstract class ClassRepository {
  /// Creates a new [ClassEntity] in the system.
  ///
  /// Returns the created [ClassEntity] with its assigned ID and metadata.
  Future<ClassEntity> createClass(ClassEntity newClass);

  /// Retrieves all classes created by a specific teacher identified by [teacherId].
  Future<List<ClassEntity>> getTeacherClasses(String teacherId);

  /// Retrieves a class by its unique identifier [classId].
  ///
  /// Returns `null` if no class matches the given ID.
  Future<ClassEntity?> getClassById(String classId);

  /// Finds an active class associated with the provided 6-character [joinCode].
  ///
  /// Returns `null` if the code is invalid or does not match any active class.
  Future<ClassEntity?> getClassByJoinCode(String joinCode);

  /// Enrolls a student identified by [studentId] into the class identified by [classId].
  ///
  /// Throws an exception if the student is already enrolled or if the class is inactive.
  Future<void> joinClass({
    required String classId,
    required String studentId,
  });

  /// Checks if a student identified by [studentId] is officially enrolled in [classId].
  Future<bool> isStudentEnrolled({
    required String classId,
    required String studentId,
  });
}
