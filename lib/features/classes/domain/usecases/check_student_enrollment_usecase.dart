import '../repositories/class_repository.dart';

/// Parameters for checking student enrollment.
class EnrollmentParams {
  final String classId;
  final String studentId;

  const EnrollmentParams({
    required this.classId,
    required this.studentId,
  });
}

/// Use case that verifies whether a student is officially enrolled in a class.
/// Acts as a security guard check before attendance punch-in or quiz access.
class CheckStudentEnrollmentUseCase {
  final ClassRepository repository;

  const CheckStudentEnrollmentUseCase(this.repository);

  Future<bool> call(EnrollmentParams params) async {
    final trimmedClassId = params.classId.trim();
    final trimmedStudentId = params.studentId.trim();

    if (trimmedClassId.isEmpty || trimmedStudentId.isEmpty) {
      return false;
    }

    return repository.isStudentEnrolled(
      classId: trimmedClassId,
      studentId: trimmedStudentId,
    );
  }
}
