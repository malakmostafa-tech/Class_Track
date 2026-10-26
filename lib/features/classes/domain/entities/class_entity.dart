/// Represents the core business entity for a university course/class in ClassTrack.
/// 
/// This is a pure Dart entity with zero dependencies on frameworks, databases,
/// or UI libraries, adhering strictly to Clean Architecture principles.
class ClassEntity {
  /// Unique identifier of the class (e.g. Firestore Document ID).
  final String id;

  /// The official name of the class (e.g., 'Mobile Programming II').
  final String name;

  /// The university course code (e.g., 'CS402').
  final String courseCode;

  /// A brief summary or syllabus description for the course.
  final String description;

  /// A unique 6-character code used by students to discover and join this class.
  final String joinCode;

  /// The unique identifier (UID) of the doctor/teacher who created and owns this class.
  final String teacherId;

  /// The display name of the doctor/teacher.
  final String teacherName;

  /// List of student UIDs officially enrolled in this class.
  final List<String> enrolledStudentIds;

  /// The exact timestamp when this class was created.
  final DateTime createdAt;

  /// Whether the class is actively running or archived/disabled.
  final bool isActive;

  /// The lecture room or hall (e.g., 'Engineering 204') as defined in Figma.
  final String room;

  /// The lecture timing/schedule (e.g., 'Mon / Wed • 10:00 AM') as defined in Figma.
  final String schedule;

  /// The academic semester/term (e.g., 'Fall 2026') as defined in Figma.
  final String term;

  const ClassEntity({
    required this.id,
    required this.name,
    required this.courseCode,
    required this.description,
    required this.joinCode,
    required this.teacherId,
    required this.teacherName,
    this.enrolledStudentIds = const [],
    required this.createdAt,
    this.isActive = true,
    this.room = '',
    this.schedule = '',
    this.term = '',
  });

  /// The total number of enrolled students in this class.
  int get studentCount => enrolledStudentIds.length;

  /// Creates a copy of this [ClassEntity] with optional updated fields.
  ClassEntity copyWith({
    String? id,
    String? name,
    String? courseCode,
    String? description,
    String? joinCode,
    String? teacherId,
    String? teacherName,
    List<String>? enrolledStudentIds,
    DateTime? createdAt,
    bool? isActive,
    String? room,
    String? schedule,
    String? term,
  }) {
    return ClassEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      courseCode: courseCode ?? this.courseCode,
      description: description ?? this.description,
      joinCode: joinCode ?? this.joinCode,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      enrolledStudentIds: enrolledStudentIds ?? this.enrolledStudentIds,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      room: room ?? this.room,
      schedule: schedule ?? this.schedule,
      term: term ?? this.term,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClassEntity &&
        other.id == id &&
        other.name == name &&
        other.courseCode == courseCode &&
        other.description == description &&
        other.joinCode == joinCode &&
        other.teacherId == teacherId &&
        other.teacherName == teacherName &&
        _listEquals(other.enrolledStudentIds, enrolledStudentIds) &&
        other.createdAt == createdAt &&
        other.isActive == isActive &&
        other.room == room &&
        other.schedule == schedule &&
        other.term == term;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        courseCode.hashCode ^
        description.hashCode ^
        joinCode.hashCode ^
        teacherId.hashCode ^
        teacherName.hashCode ^
        _listHashCode(enrolledStudentIds) ^
        createdAt.hashCode ^
        isActive.hashCode ^
        room.hashCode ^
        schedule.hashCode ^
        term.hashCode;
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static int _listHashCode(List<String> list) {
    int hash = 0;
    for (final item in list) {
      hash = hash ^ item.hashCode;
    }
    return hash;
  }

  @override
  String toString() {
    return 'ClassEntity(id: $id, name: $name, courseCode: $courseCode, joinCode: $joinCode, teacherName: $teacherName, studentCount: $studentCount, room: $room, schedule: $schedule, term: $term, isActive: $isActive)';
  }
}
