import 'dart:math';
import '../models/class_model.dart';
import '../../domain/errors/class_exceptions.dart';

/// Abstract contract for remote class operations.
///
/// Decouples data fetching from specific backend implementations
/// (Firestore, REST API, or In-Memory Mock).
abstract class ClassRemoteDataSource {
  /// Persists a new [ClassModel] and returns the persisted model with an assigned ID.
  Future<ClassModel> createClass(ClassModel model);

  /// Retrieves all classes created by the specified [teacherId].
  Future<List<ClassModel>> getTeacherClasses(String teacherId);

  /// Retrieves a class by its unique document ID [classId].
  Future<ClassModel?> getClassById(String classId);

  /// Finds an active class by its 6-character [joinCode].
  Future<ClassModel?> getClassByJoinCode(String joinCode);

  /// Adds a student identified by [studentId] to the class identified by [classId].
  Future<void> joinClass({
    required String classId,
    required String studentId,
  });

  /// Checks whether [studentId] is in [classId]'s enrolled students list.
  Future<bool> isStudentEnrolled({
    required String classId,
    required String studentId,
  });
}

/// In-Memory implementation of [ClassRemoteDataSource].
///
/// Enables fast, deterministic, offline unit and widget testing without
/// requiring Firebase emulator or live internet connection.
class InMemoryClassRemoteDataSource implements ClassRemoteDataSource {
  final Map<String, ClassModel> _storage = {};

  @override
  Future<ClassModel> createClass(ClassModel model) async {
    final assignedId = model.id.trim().isNotEmpty
        ? model.id.trim()
        : 'cls_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';

    final createdModel = ClassModel(
      id: assignedId,
      name: model.name,
      courseCode: model.courseCode,
      description: model.description,
      joinCode: model.joinCode,
      teacherId: model.teacherId,
      teacherName: model.teacherName,
      enrolledStudentIds: model.enrolledStudentIds,
      createdAt: model.createdAt,
      isActive: model.isActive,
      room: model.room,
      schedule: model.schedule,
      term: model.term,
    );

    _storage[assignedId] = createdModel;
    return createdModel;
  }

  @override
  Future<List<ClassModel>> getTeacherClasses(String teacherId) async {
    return _storage.values
        .where((c) => c.teacherId == teacherId)
        .toList();
  }

  @override
  Future<ClassModel?> getClassById(String classId) async {
    return _storage[classId];
  }

  @override
  Future<ClassModel?> getClassByJoinCode(String joinCode) async {
    final normalized = joinCode.trim().toUpperCase();
    try {
      return _storage.values.firstWhere(
        (c) => c.joinCode.trim().toUpperCase() == normalized,
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
    final existing = _storage[classId];
    if (existing == null) {
      throw const ClassNotFoundException();
    }
    if (!existing.isActive) {
      throw const ClassNotActiveException();
    }
    if (existing.enrolledStudentIds.contains(studentId)) {
      throw const StudentAlreadyEnrolledException();
    }

    final updated = ClassModel(
      id: existing.id,
      name: existing.name,
      courseCode: existing.courseCode,
      description: existing.description,
      joinCode: existing.joinCode,
      teacherId: existing.teacherId,
      teacherName: existing.teacherName,
      enrolledStudentIds: [...existing.enrolledStudentIds, studentId],
      createdAt: existing.createdAt,
      isActive: existing.isActive,
      room: existing.room,
      schedule: existing.schedule,
      term: existing.term,
    );

    _storage[classId] = updated;
  }

  @override
  Future<bool> isStudentEnrolled({
    required String classId,
    required String studentId,
  }) async {
    final existing = _storage[classId];
    if (existing == null) return false;
    return existing.enrolledStudentIds.contains(studentId);
  }
}
