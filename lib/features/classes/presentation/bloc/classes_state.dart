import '../../domain/entities/class_entity.dart';

/// Base architectural state for the classes feature.
abstract class ClassesState {
  const ClassesState();
}

/// Initial state when no class action has occurred yet.
class ClassesInitial extends ClassesState {
  const ClassesInitial();
}

/// Emitted when an asynchronous class operation (fetching, creating, joining) is in progress.
class ClassesLoading extends ClassesState {
  const ClassesLoading();
}

/// Emitted when the teacher's classes have been successfully fetched.
class TeacherClassesLoaded extends ClassesState {
  final List<ClassEntity> classes;

  const TeacherClassesLoaded(this.classes);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeacherClassesLoaded && other.classes == classes;
  }

  @override
  int get hashCode => classes.hashCode;
}

/// Emitted when a new class has been created successfully by a doctor.
class ClassCreatedSuccess extends ClassesState {
  final ClassEntity newClass;
  final String message;

  const ClassCreatedSuccess(this.newClass, [this.message = 'Class created successfully!']);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassCreatedSuccess && other.newClass == newClass;
  }

  @override
  int get hashCode => newClass.hashCode;
}

/// Emitted when a student has successfully joined a class using its join code.
class ClassJoinedSuccess extends ClassesState {
  final ClassEntity joinedClass;
  final String message;

  const ClassJoinedSuccess(this.joinedClass, [this.message = 'Joined class successfully!']);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassJoinedSuccess && other.joinedClass == joinedClass;
  }

  @override
  int get hashCode => joinedClass.hashCode;
}

/// Emitted when a student's enrollment status has been verified.
class EnrollmentStatusChecked extends ClassesState {
  final bool isEnrolled;

  const EnrollmentStatusChecked(this.isEnrolled);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EnrollmentStatusChecked && other.isEnrolled == isEnrolled;
  }

  @override
  int get hashCode => isEnrolled.hashCode;
}

/// Emitted when any class operation encounters an error or business violation.
class ClassesError extends ClassesState {
  final String message;

  const ClassesError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
