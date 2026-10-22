import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Custom theme extension for attendance and educational status indicators.
///
/// Easily accessible via `context.attendanceColors` or
/// `Theme.of(context).extension<AttendanceThemeColors>()`.
class AttendanceThemeColors extends ThemeExtension<AttendanceThemeColors> {
  final Color present;
  final Color presentContainer;
  final Color absent;
  final Color absentContainer;
  final Color lateStatus;
  final Color lateContainer;
  final Color excused;
  final Color excusedContainer;

  const AttendanceThemeColors({
    required this.present,
    required this.presentContainer,
    required this.absent,
    required this.absentContainer,
    required this.lateStatus,
    required this.lateContainer,
    required this.excused,
    required this.excusedContainer,
  });

  /// Default Light mode attendance theme colors
  static const AttendanceThemeColors light = AttendanceThemeColors(
    present: AppColors.attendancePresent,
    presentContainer: AppColors.attendancePresentBg,
    absent: AppColors.attendanceAbsent,
    absentContainer: AppColors.attendanceAbsentBg,
    lateStatus: AppColors.attendanceLate,
    lateContainer: AppColors.attendanceLateBg,
    excused: AppColors.attendanceExcused,
    excusedContainer: AppColors.attendanceExcusedBg,
  );

  /// Default Dark mode attendance theme colors
  static const AttendanceThemeColors dark = AttendanceThemeColors(
    present: Color(0xFF81C784),
    presentContainer: Color(0xFF1B3B1D),
    absent: Color(0xFFE57373),
    absentContainer: Color(0xFF3F1919),
    lateStatus: Color(0xFFFFB74D),
    lateContainer: Color(0xFF3D2A0E),
    excused: Color(0xFF64B5F6),
    excusedContainer: Color(0xFF142B3E),
  );

  @override
  AttendanceThemeColors copyWith({
    Color? present,
    Color? presentContainer,
    Color? absent,
    Color? absentContainer,
    Color? lateStatus,
    Color? lateContainer,
    Color? excused,
    Color? excusedContainer,
  }) {
    return AttendanceThemeColors(
      present: present ?? this.present,
      presentContainer: presentContainer ?? this.presentContainer,
      absent: absent ?? this.absent,
      absentContainer: absentContainer ?? this.absentContainer,
      lateStatus: lateStatus ?? this.lateStatus,
      lateContainer: lateContainer ?? this.lateContainer,
      excused: excused ?? this.excused,
      excusedContainer: excusedContainer ?? this.excusedContainer,
    );
  }

  @override
  AttendanceThemeColors lerp(
    covariant ThemeExtension<AttendanceThemeColors>? other,
    double t,
  ) {
    if (other is! AttendanceThemeColors) {
      return this;
    }
    return AttendanceThemeColors(
      present: Color.lerp(present, other.present, t) ?? present,
      presentContainer:
          Color.lerp(presentContainer, other.presentContainer, t) ??
              presentContainer,
      absent: Color.lerp(absent, other.absent, t) ?? absent,
      absentContainer:
          Color.lerp(absentContainer, other.absentContainer, t) ??
              absentContainer,
      lateStatus:
          Color.lerp(lateStatus, other.lateStatus, t) ?? lateStatus,
      lateContainer:
          Color.lerp(lateContainer, other.lateContainer, t) ??
              lateContainer,
      excused: Color.lerp(excused, other.excused, t) ?? excused,
      excusedContainer:
          Color.lerp(excusedContainer, other.excusedContainer, t) ??
              excusedContainer,
    );
  }
}

/// Convenience extensions on [BuildContext] for streamlined theme access.
extension ThemeContextExtension on BuildContext {
  /// Quick access to the active [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// Quick access to the active [ColorScheme].
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Quick access to the active [TextTheme].
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns true if the active brightness is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Quick access to custom attendance theme status colors.
  AttendanceThemeColors get attendanceColors =>
      Theme.of(this).extension<AttendanceThemeColors>() ??
      (isDarkMode ? AttendanceThemeColors.dark : AttendanceThemeColors.light);
}
