import '../entities/class_entity.dart';
import '../repositories/class_repository.dart';

/// Use case to retrieve all classes created by a specific teacher.
class GetTeacherClassesUseCase {
  final ClassRepository repository;

  const GetTeacherClassesUseCase(this.repository);

  Future<List<ClassEntity>> call(String teacherId) async {
    final trimmedId = teacherId.trim();
    if (trimmedId.isEmpty) {
      return const [];
    }
    return repository.getTeacherClasses(trimmedId);
  }
}
