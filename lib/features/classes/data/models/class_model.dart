import '../../domain/entities/class_entity.dart';

/// Data Transfer Object (DTO) for [ClassEntity].
///
/// Responsible for JSON/Map serialization and deserialization, network boundary
/// translation, and Firestore document mapping.
class ClassModel extends ClassEntity {
  const ClassModel({
    required super.id,
    required super.name,
    required super.courseCode,
    required super.description,
    required super.joinCode,
    required super.teacherId,
    required super.teacherName,
    super.enrolledStudentIds = const [],
    required super.createdAt,
    super.isActive = true,
    super.room = '',
    super.schedule = '',
    super.term = '',
  });

  /// Factory constructor to deserialize a raw Firestore/JSON [map] into a [ClassModel].
  ///
  /// Safely handles null values, dynamic type conversions, and multiple timestamp formats.
  factory ClassModel.fromMap(Map<String, dynamic> map, String id) {
    return ClassModel(
      id: id,
      name: (map['name'] as String?)?.trim() ?? '',
      courseCode: (map['courseCode'] as String?)?.trim() ?? '',
      description: (map['description'] as String?)?.trim() ?? '',
      joinCode: (map['joinCode'] as String?)?.trim() ?? '',
      teacherId: (map['teacherId'] as String?)?.trim() ?? '',
      teacherName: (map['teacherName'] as String?)?.trim() ?? '',
      enrolledStudentIds: _parseStringList(map['enrolledStudentIds']),
      createdAt: _parseDateTime(map['createdAt']),
      isActive: map['isActive'] as bool? ?? true,
      room: (map['room'] as String?)?.trim() ?? '',
      schedule: (map['schedule'] as String?)?.trim() ?? '',
      term: (map['term'] as String?)?.trim() ?? '',
    );
  }

  /// Serializes this [ClassModel] into a standard Map suitable for Cloud Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'courseCode': courseCode,
      'description': description,
      'joinCode': joinCode,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'enrolledStudentIds': enrolledStudentIds,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'room': room,
      'schedule': schedule,
      'term': term,
    };
  }

  /// Converts this [ClassModel] into its corresponding domain [ClassEntity].
  ClassEntity toEntity() {
    return ClassEntity(
      id: id,
      name: name,
      courseCode: courseCode,
      description: description,
      joinCode: joinCode,
      teacherId: teacherId,
      teacherName: teacherName,
      enrolledStudentIds: enrolledStudentIds,
      createdAt: createdAt,
      isActive: isActive,
      room: room,
      schedule: schedule,
      term: term,
    );
  }

  @override
  ClassModel copyWith({
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
    return ClassModel(
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

  /// Constructs a [ClassModel] from a pure domain [ClassEntity].
  factory ClassModel.fromEntity(ClassEntity entity) {
    return ClassModel(
      id: entity.id,
      name: entity.name,
      courseCode: entity.courseCode,
      description: entity.description,
      joinCode: entity.joinCode,
      teacherId: entity.teacherId,
      teacherName: entity.teacherName,
      enrolledStudentIds: entity.enrolledStudentIds,
      createdAt: entity.createdAt,
      isActive: entity.isActive,
      room: entity.room,
      schedule: entity.schedule,
      term: entity.term,
    );
  }

  /// Safely converts a dynamic list to a [List<String>] without casting exceptions.
  static List<String> _parseStringList(dynamic rawList) {
    if (rawList is List) {
      return rawList.map((item) => item.toString().trim()).where((s) => s.isNotEmpty).toList();
    }
    return const [];
  }

  /// Robust parser for [DateTime] supporting ISO Strings, milliseconds, and Firestore Timestamps.
  static DateTime _parseDateTime(dynamic rawValue) {
    if (rawValue == null) {
      return DateTime.now();
    }
    if (rawValue is DateTime) {
      return rawValue;
    }
    if (rawValue is String) {
      return DateTime.tryParse(rawValue) ?? DateTime.now();
    }
    if (rawValue is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawValue);
    }
    // Dynamic check for Firestore Timestamp object with .toDate() method
    try {
      final dynamic dynamicVal = rawValue;
      if (dynamicVal.toDate is Function) {
        return dynamicVal.toDate() as DateTime;
      }
    } catch (_) {}

    return DateTime.now();
  }
}
