/// Base domain exception for class-related business logic errors.
abstract class ClassException implements Exception {
  final String message;
  const ClassException(this.message);

  @override
  String toString() => message;
}

/// Thrown when a class cannot be found by its ID or join code.
class ClassNotFoundException extends ClassException {
  const ClassNotFoundException([super.message = 'Class not found. Please verify the join code.']);
}

/// Thrown when attempting to interact with an archived or inactive class.
class ClassNotActiveException extends ClassException {
  const ClassNotActiveException([super.message = 'This class is currently inactive or archived.']);
}

/// Thrown when a student attempts to join a class they are already enrolled in.
class StudentAlreadyEnrolledException extends ClassException {
  const StudentAlreadyEnrolledException([super.message = 'You are already enrolled in this class.']);
}

/// Thrown when class creation data is invalid (e.g. empty name or courseCode).
class InvalidClassDataException extends ClassException {
  const InvalidClassDataException([super.message = 'Class name and course code cannot be blank.']);
}

/// Thrown when an invalid format join code is provided.
class InvalidJoinCodeException extends ClassException {
  const InvalidJoinCodeException([super.message = 'The provided join code format is invalid.']);
}
