import '../entities/class_entity.dart';
import '../errors/class_exceptions.dart';
import '../repositories/class_repository.dart';

/// Parameters required for a student to join a class.
class JoinClassParams {
  final String joinCode;
  final String studentId;

  const JoinClassParams({
    required this.joinCode,
    required this.studentId,
  });
}

/// Use case that enables a student to discover and enroll in a class using its 6-character code.
class JoinClassByCodeUseCase {
  final ClassRepository repository;

  const JoinClassByCodeUseCase(this.repository);

  Future<ClassEntity> call(JoinClassParams params) async {
    final sanitizedCode = params.joinCode.trim().toUpperCase();
    final sanitizedStudentId = params.studentId.trim();

    if (sanitizedCode.isEmpty || sanitizedStudentId.isEmpty) {
      throw const InvalidJoinCodeException('Join code and student ID cannot be blank.');
    }

    // 1. Locate the class by join code
    final targetClass = await repository.getClassByJoinCode(sanitizedCode);
    if (targetClass == null) {
      throw const ClassNotFoundException();
    }

    // 2. Validate that the class is active
    if (!targetClass.isActive) {
      throw const ClassNotActiveException();
    }

    // 3. Verify that student is not already enrolled
    final isAlreadyEnrolled = await repository.isStudentEnrolled(
      classId: targetClass.id,
      studentId: sanitizedStudentId,
    );
    if (isAlreadyEnrolled) {
      throw const StudentAlreadyEnrolledException();
    }

    // 4. Enroll the student in the repository
    await repository.joinClass(
      classId: targetClass.id,
      studentId: sanitizedStudentId,
    );

    // Return the updated class entity with the student added
    return targetClass.copyWith(
      enrolledStudentIds: [...targetClass.enrolledStudentIds, sanitizedStudentId],
    );
  }
}
