import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/errors/class_exceptions.dart';
import '../../domain/usecases/check_student_enrollment_usecase.dart';
import '../../domain/usecases/create_class_usecase.dart';
import '../../domain/usecases/get_teacher_classes_usecase.dart';
import '../../domain/usecases/join_class_by_code_usecase.dart';
import 'classes_state.dart';

/// State management controller for all Class-related user interactions.
///
/// Orchestrates the 4 business use cases and emits clean, immutable UI states.
class ClassesCubit extends Cubit<ClassesState> {
  final CreateClassUseCase createClassUseCase;
  final GetTeacherClassesUseCase getTeacherClassesUseCase;
  final JoinClassByCodeUseCase joinClassByCodeUseCase;
  final CheckStudentEnrollmentUseCase checkStudentEnrollmentUseCase;

  ClassesCubit({
    required this.createClassUseCase,
    required this.getTeacherClassesUseCase,
    required this.joinClassByCodeUseCase,
    required this.checkStudentEnrollmentUseCase,
  }) : super(const ClassesInitial());

  /// Loads all classes belonging to the specified doctor/teacher.
  Future<void> loadTeacherClasses(String teacherId) async {
    emit(const ClassesLoading());
    try {
      final classes = await getTeacherClassesUseCase(teacherId);
      emit(TeacherClassesLoaded(classes));
    } on ClassException catch (e) {
      emit(ClassesError(e.message));
    } catch (e) {
      emit(ClassesError('Failed to load classes: ${e.toString()}'));
    }
  }

  /// Triggers the creation of a new course by a doctor.
  Future<void> createClass(CreateClassParams params) async {
    emit(const ClassesLoading());
    try {
      final newClass = await createClassUseCase(params);
      emit(ClassCreatedSuccess(newClass));
    } on ClassException catch (e) {
      emit(ClassesError(e.message));
    } catch (e) {
      emit(ClassesError('Failed to create class: ${e.toString()}'));
    }
  }

  /// Handles a student's attempt to join a class using its 6-character join code.
  Future<void> joinClassByCode({
    required String joinCode,
    required String studentId,
  }) async {
    emit(const ClassesLoading());
    try {
      final joinedClass = await joinClassByCodeUseCase(JoinClassParams(
        joinCode: joinCode,
        studentId: studentId,
      ));
      emit(ClassJoinedSuccess(joinedClass));
    } on ClassException catch (e) {
      emit(ClassesError(e.message));
    } catch (e) {
      emit(ClassesError('Failed to join class: ${e.toString()}'));
    }
  }

  /// Verifies if a student is officially registered in a class (Security Guard).
  Future<void> checkEnrollment({
    required String classId,
    required String studentId,
  }) async {
    emit(const ClassesLoading());
    try {
      final isEnrolled = await checkStudentEnrollmentUseCase(EnrollmentParams(
        classId: classId,
        studentId: studentId,
      ));
      emit(EnrollmentStatusChecked(isEnrolled));
    } on ClassException catch (e) {
      emit(ClassesError(e.message));
    } catch (e) {
      emit(ClassesError('Failed to check enrollment: ${e.toString()}'));
    }
  }

  /// Resets the state machine back to [ClassesInitial].
  void resetToInitial() {
    emit(const ClassesInitial());
  }
}
