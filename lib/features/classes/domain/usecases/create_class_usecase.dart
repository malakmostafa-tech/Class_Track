import '../../../../core/utils/join_code_generator.dart';
import '../entities/class_entity.dart';
import '../errors/class_exceptions.dart';
import '../repositories/class_repository.dart';

/// Parameters required to create a new class.
class CreateClassParams {
  final String name;
  final String courseCode;
  final String description;
  final String teacherId;
  final String teacherName;

  const CreateClassParams({
    required this.name,
    required this.courseCode,
    required this.description,
    required this.teacherId,
    required this.teacherName,
  });
}

/// Use case responsible for creating a new class, automatically generating its
/// unique join code, and associating it with the creating teacher.
class CreateClassUseCase {
  final ClassRepository repository;

  const CreateClassUseCase(this.repository);

  Future<ClassEntity> call(CreateClassParams params) async {
    final trimmedName = params.name.trim();
    final trimmedCode = params.courseCode.trim();

    if (trimmedName.isEmpty || trimmedCode.isEmpty || params.teacherId.trim().isEmpty) {
      throw const InvalidClassDataException();
    }

    final generatedJoinCode = JoinCodeGenerator.generate();

    final newClass = ClassEntity(
      id: '', // Will be assigned by database/repository
      name: trimmedName,
      courseCode: trimmedCode.toUpperCase(),
      description: params.description.trim(),
      joinCode: generatedJoinCode,
      teacherId: params.teacherId.trim(),
      teacherName: params.teacherName.trim(),
      enrolledStudentIds: const [],
      createdAt: DateTime.now(),
      isActive: true,
    );

    return repository.createClass(newClass);
  }
}
