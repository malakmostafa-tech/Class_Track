/// Defines all route names used across the ClassTrack application.
///
/// Centralizing route name constants prevents typos and makes navigation
/// refactoring and maintenance straightforward.
abstract final class AppRoutes {
  const AppRoutes._();

  // ==========================================
  // Core / Splash
  // ==========================================
  static const String initial = '/';
  static const String splash = '/splash';

  // ==========================================
  // Auth Feature
  // ==========================================
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';

  // ==========================================
  // Dashboard Feature
  // ==========================================
  static const String dashboard = '/dashboard';

  // ==========================================
  // Classes Feature
  // ==========================================
  static const String classes = '/classes';
  static const String classDetails = '/class-details';
  static const String createClass = '/create-class';
  static const String editClass = '/edit-class';

  // ==========================================
  // Attendance Feature
  // ==========================================
  static const String attendance = '/attendance';
  static const String takeAttendance = '/take-attendance';
  static const String attendanceScanner = '/attendance-scanner';
  static const String attendanceDetails = '/attendance-details';

  // ==========================================
  // Quiz Feature
  // ==========================================
  static const String quizzes = '/quizzes';
  static const String quizDetails = '/quiz-details';
  static const String takeQuiz = '/take-quiz';
  static const String quizResults = '/quiz-results';
  static const String createQuiz = '/create-quiz';

  // ==========================================
  // Enrollments Feature
  // ==========================================
  static const String enrollments = '/enrollments';
  static const String enrollStudent = '/enroll-student';

  // ==========================================
  // Session History Feature
  // ==========================================
  static const String sessionHistory = '/session-history';
  static const String sessionDetails = '/session-details';

  // ==========================================
  // Profile Feature
  // ==========================================
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
}
