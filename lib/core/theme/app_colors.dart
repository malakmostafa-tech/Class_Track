import 'package:flutter/material.dart';

/// Centralized color palette for the ClassTrack application.
///
/// Provides brand colors, semantic state colors, neutral scales,
/// and attendance status colors designed for both Light and Dark themes.
abstract final class AppColors {
  const AppColors._();

  // ==========================================
  // Brand Primary Palette (Vibrant Academic Blue & Deep Navy)
  // ==========================================
  static const Color primary = Color(0xFF2563EB); // Blue 600
  static const Color primaryLight = Color(0xFF3B82F6); // Blue 500
  static const Color primaryDark = Color(0xFF172554); // Navy 950 (Brand Banner & Header)
  static const Color primaryContainer = Color(0xFFEFF6FF); // Blue 50
  static const Color onPrimaryContainer = Color(0xFF1E40AF); // Blue 800

  // ==========================================
  // Secondary / Accent Palette (Teal & Cyan)
  // ==========================================
  static const Color secondary = Color(0xFF14B8A6); // Teal 500
  static const Color secondaryLight = Color(0xFF2DD4BF); // Teal 400
  static const Color secondaryDark = Color(0xFF0F766E); // Teal 700
  static const Color secondaryContainer = Color(0xFFCCFBF1); // Teal 100
  static const Color onSecondaryContainer = Color(0xFF115E59); // Teal 800

  // ==========================================
  // Tertiary / Accent Palette (Amber / Gold for Achievements & Warning)
  // ==========================================
  static const Color tertiary = Color(0xFFF59E0B); // Amber 500
  static const Color tertiaryDark = Color(0xFFD97706); // Amber 600
  static const Color tertiaryContainer = Color(0xFFFEF3C7); // Amber 100
  static const Color onTertiaryContainer = Color(0xFF92400E); // Amber 800

  // ==========================================
  // Semantic / Feedback Colors
  // ==========================================
  static const Color success = Color(0xFF16A34A); // Green 600
  static const Color successContainer = Color(0xFFDCFCE7); // Green 100
  static const Color onSuccessContainer = Color(0xFF14532D); // Green 900

  static const Color warning = Color(0xFFD97706); // Amber 600
  static const Color warningContainer = Color(0xFFFEF3C7); // Amber 100
  static const Color onWarningContainer = Color(0xFF78350F); // Amber 900

  static const Color error = Color(0xFFDC2626); // Red 600
  static const Color errorDark = Color(0xFFB91C1C); // Red 700 (Destructive Button)
  static const Color errorContainer = Color(0xFFFEE2E2); // Red 100
  static const Color onErrorContainer = Color(0xFF7F1D1D); // Red 900

  static const Color info = Color(0xFF2563EB); // Blue 600
  static const Color infoContainer = Color(0xFFEFF6FF); // Blue 50
  static const Color onInfoContainer = Color(0xFF1E3A8A); // Blue 900

  // ==========================================
  // Attendance Specific Status Colors
  // ==========================================
  static const Color attendancePresent = Color(0xFF16A34A);
  static const Color attendancePresentBg = Color(0xFFDCFCE7);

  static const Color attendanceAbsent = Color(0xFFDC2626);
  static const Color attendanceAbsentBg = Color(0xFFFEE2E2);

  static const Color attendanceLate = Color(0xFFD97706);
  static const Color attendanceLateBg = Color(0xFFFEF3C7);

  static const Color attendanceExcused = Color(0xFF2563EB);
  static const Color attendanceExcusedBg = Color(0xFFEFF6FF);

  // ==========================================
  // Two-Minute Classroom Specific Tokens
  // ==========================================
  static const Color timerBannerBg = Color(0xFF172554); // Deep Navy timer background
  static const Color timerBannerText = Color(0xFFFFFFFF);

  // ==========================================
  // Light Theme Neutrals & Surfaces (Slate Scale)
  // ==========================================
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSecondary = Color(0xFFF1F5F9); // Slate 100
  static const Color lightBorder = Color(0xFFE2E8F0); // Slate 200
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate 900
  static const Color lightTextSecondary = Color(0xFF64748B); // Slate 500
  static const Color lightTextHint = Color(0xFF94A3B8); // Slate 400

  // ==========================================
  // Dark Theme Neutrals & Surfaces
  // ==========================================
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceSecondary = Color(0xFF334155); // Slate 700
  static const Color darkBorder = Color(0xFF475569); // Slate 600
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkTextHint = Color(0xFF64748B); // Slate 500

  // ==========================================
  // Common Utilities
  // ==========================================
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
