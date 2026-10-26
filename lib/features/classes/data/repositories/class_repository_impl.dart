import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/class_repository.dart';
import '../datasources/class_remote_data_source.dart';
import '../models/class_model.dart';

/// Concrete implementation of [ClassRepository] fulfilling Clean Architecture contracts.
///
/// Orchestrates data flow between the domain layer and remote data sources,
/// mapping DTO models to pure domain entities and encapsulating infrastructure logic.
class ClassRepositoryImpl implements ClassRepository {
  final ClassRemoteDataSource remoteDataSource;

  const ClassRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ClassEntity> createClass(ClassEntity newClass) async {
    final model = ClassModel.fromEntity(newClass);
    final persistedModel = await remoteDataSource.createClass(model);
    return persistedModel.toEntity();
  }

  @override
  Future<List<ClassEntity>> getTeacherClasses(String teacherId) async {
    final models = await remoteDataSource.getTeacherClasses(teacherId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ClassEntity?> getClassById(String classId) async {
    final model = await remoteDataSource.getClassById(classId);
    return model?.toEntity();
  }

  @override
  Future<ClassEntity?> getClassByJoinCode(String joinCode) async {
    final model = await remoteDataSource.getClassByJoinCode(joinCode);
    return model?.toEntity();
  }

  @override
  Future<void> joinClass({
    required String classId,
    required String studentId,
  }) async {
    return remoteDataSource.joinClass(
      classId: classId,
      studentId: studentId,
    );
  }

  @override
  Future<bool> isStudentEnrolled({
    required String classId,
    required String studentId,
  }) async {
    return remoteDataSource.isStudentEnrolled(
      classId: classId,
      studentId: studentId,
    );
  }
}
