import 'package:flutter/material.dart';

import 'app_routes.dart';

/// Central route generator for the ClassTrack application.
///
/// Configures [onGenerateRoute] to map [RouteSettings.name] strings
/// to their corresponding screen widgets with appropriate transitions.
final class AppRouter {
  const AppRouter._();

  /// Main route generator passed to [MaterialApp.onGenerateRoute].
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Arguments passed during navigation via Navigator.pushNamed(context, route, arguments: ...)
    final Object? arguments = settings.arguments;

    switch (settings.name) {
      // ==========================================
      // Initial / Splash
      // ==========================================
      case AppRoutes.initial:
      case AppRoutes.splash:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Splash Screen',
            routeName: AppRoutes.splash,
            featurePath: 'lib/features/auth/presentation/pages/splash_page.dart',
          ),
          settings: settings,
        );

      // ==========================================
      // Auth Feature
      // ==========================================
      case AppRoutes.login:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Login',
            routeName: AppRoutes.login,
            featurePath: 'lib/features/auth/presentation/pages/login_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.register:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Register / Sign Up',
            routeName: AppRoutes.register,
            featurePath: 'lib/features/auth/presentation/pages/register_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.forgotPassword:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Forgot Password',
            routeName: AppRoutes.forgotPassword,
            featurePath:
                'lib/features/auth/presentation/pages/forgot_password_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.otpVerification:
        return _buildRoute(
          _PlaceholderPage(
            title: 'OTP Verification',
            routeName: AppRoutes.otpVerification,
            featurePath:
                'lib/features/auth/presentation/pages/otp_verification_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      case AppRoutes.resetPassword:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Reset Password',
            routeName: AppRoutes.resetPassword,
            featurePath:
                'lib/features/auth/presentation/pages/reset_password_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      // ==========================================
      // Dashboard Feature
      // ==========================================
      case AppRoutes.dashboard:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Dashboard',
            routeName: AppRoutes.dashboard,
            featurePath:
                'lib/features/dashboard/presentation/pages/dashboard_page.dart',
          ),
          settings: settings,
        );

      // ==========================================
      // Classes Feature
      // ==========================================
      case AppRoutes.classes:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Classes',
            routeName: AppRoutes.classes,
            featurePath:
                'lib/features/classes/presentation/pages/classes_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.classDetails:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Class Details',
            routeName: AppRoutes.classDetails,
            featurePath:
                'lib/features/classes/presentation/pages/class_details_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      case AppRoutes.createClass:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Create Class',
            routeName: AppRoutes.createClass,
            featurePath:
                'lib/features/classes/presentation/pages/create_class_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.editClass:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Edit Class',
            routeName: AppRoutes.editClass,
            featurePath:
                'lib/features/classes/presentation/pages/edit_class_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      // ==========================================
      // Attendance Feature
      // ==========================================
      case AppRoutes.attendance:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Attendance',
            routeName: AppRoutes.attendance,
            featurePath:
                'lib/features/attendance/presentation/pages/attendance_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.takeAttendance:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Take Attendance',
            routeName: AppRoutes.takeAttendance,
            featurePath:
                'lib/features/attendance/presentation/pages/take_attendance_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      case AppRoutes.attendanceScanner:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'QR Attendance Scanner',
            routeName: AppRoutes.attendanceScanner,
            featurePath:
                'lib/features/attendance/presentation/pages/attendance_scanner_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.attendanceDetails:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Attendance Details',
            routeName: AppRoutes.attendanceDetails,
            featurePath:
                'lib/features/attendance/presentation/pages/attendance_details_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      // ==========================================
      // Quiz Feature
      // ==========================================
      case AppRoutes.quizzes:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Quizzes',
            routeName: AppRoutes.quizzes,
            featurePath:
                'lib/features/quiz/presentation/pages/quizzes_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.quizDetails:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Quiz Details',
            routeName: AppRoutes.quizDetails,
            featurePath:
                'lib/features/quiz/presentation/pages/quiz_details_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      case AppRoutes.takeQuiz:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Take Quiz',
            routeName: AppRoutes.takeQuiz,
            featurePath:
                'lib/features/quiz/presentation/pages/take_quiz_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      case AppRoutes.quizResults:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Quiz Results',
            routeName: AppRoutes.quizResults,
            featurePath:
                'lib/features/quiz/presentation/pages/quiz_results_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      case AppRoutes.createQuiz:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Create Quiz',
            routeName: AppRoutes.createQuiz,
            featurePath:
                'lib/features/quiz/presentation/pages/create_quiz_page.dart',
          ),
          settings: settings,
        );

      // ==========================================
      // Enrollments Feature
      // ==========================================
      case AppRoutes.enrollments:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Enrollments',
            routeName: AppRoutes.enrollments,
            featurePath:
                'lib/features/enrollments/presentation/pages/enrollments_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.enrollStudent:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Enroll Student',
            routeName: AppRoutes.enrollStudent,
            featurePath:
                'lib/features/enrollments/presentation/pages/enroll_student_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      // ==========================================
      // Session History Feature
      // ==========================================
      case AppRoutes.sessionHistory:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Session History',
            routeName: AppRoutes.sessionHistory,
            featurePath:
                'lib/features/session_history/presentation/pages/session_history_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.sessionDetails:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Session Details',
            routeName: AppRoutes.sessionDetails,
            featurePath:
                'lib/features/session_history/presentation/pages/session_details_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      // ==========================================
      // Profile Feature
      // ==========================================
      case AppRoutes.profile:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Profile',
            routeName: AppRoutes.profile,
            featurePath:
                'lib/features/profile/presentation/pages/profile_page.dart',
          ),
          settings: settings,
        );

      case AppRoutes.editProfile:
        return _buildRoute(
          _PlaceholderPage(
            title: 'Edit Profile',
            routeName: AppRoutes.editProfile,
            featurePath:
                'lib/features/profile/presentation/pages/edit_profile_page.dart',
            arguments: arguments,
          ),
          settings: settings,
        );

      case AppRoutes.settings:
        return _buildRoute(
          const _PlaceholderPage(
            title: 'Settings',
            routeName: AppRoutes.settings,
            featurePath:
                'lib/features/profile/presentation/pages/settings_page.dart',
          ),
          settings: settings,
        );

      // ==========================================
      // Unknown Route (404 Fallback)
      // ==========================================
      default:
        return _errorRoute(settings);
    }
  }

  /// Helper to build a platform-adaptive route with [RouteSettings].
  static Route<dynamic> _buildRoute(
    Widget page, {
    required RouteSettings settings,
  }) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => page,
      settings: settings,
    );
  }

  /// Builds a fallback route when navigation is requested for an unregistered route name.
  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Route Not Found'),
            centerTitle: true,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 72,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '404 - Page Not Found',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No route defined for "${settings.name}".',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutes.initial,
                        );
                      }
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Temporary placeholder widget displayed until the actual feature page is implemented.
///
/// Once you create the actual page in `lib/features/<feature>/presentation/pages/`,
/// simply import it and replace `_PlaceholderPage` in [AppRouter.onGenerateRoute].
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final String routeName;
  final String featurePath;
  final Object? arguments;

  const _PlaceholderPage({
    required this.title,
    required this.routeName,
    required this.featurePath,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction_rounded,
                  size: 54,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  routeName,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'This screen is currently under development.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: theme.colorScheme.surfaceContainerLow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.code_rounded,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Target implementation file:',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        featurePath,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      if (arguments != null) ...[
                        const Divider(height: 20),
                        Text(
                          'Route Arguments:',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          '$arguments',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
