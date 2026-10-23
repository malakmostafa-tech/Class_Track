import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/class_track_logo.dart';
import '../widgets/dashed_circle_badge.dart';
import '../widgets/intro_feature_card.dart';

/// The onboarding and value proposition screen highlighting core platform features
/// (classroom connectivity, location verification, and timed in-app quizzes)
/// with direct action buttons for registration and sign-in.
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Create 4 staggered animation steps:
    // 0: Header & Hero Title
    // 1: Card 1 (Connected to classroom)
    // 2: Card 2 (Location-verified attendance)
    // 3: Card 3 (Timed quizzes) & Action Buttons
    _fadeAnimations = List.generate(4, (index) {
      final double start = (index * 0.15).clamp(0.0, 0.7);
      final double end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _slideAnimations = List.generate(4, (index) {
      final double start = (index * 0.15).clamp(0.0, 0.7);
      final double end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0.0, 0.08),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onGetStartedPressed() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  void _onSignInPressed() {
    Navigator.of(context).pushNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    final Color headlineColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.primaryDark;

    final Color subtitleColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Section 0: Top Header Logo & Hero Title
                        FadeTransition(
                          opacity: _fadeAnimations[0],
                          child: SlideTransition(
                            position: _slideAnimations[0],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ClassTrack Header
                                ClassTrackLogo.header(
                                  iconSize: 36,
                                  fontSize: 20,
                                ),
                                const SizedBox(height: 28),

                                // Headline
                                Text(
                                  'Your class.\nYour presence.',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.6,
                                    height: 1.25,
                                    color: headlineColor,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Subtitle
                                Text(
                                  'Attendance and quick quizzes, all in one place.',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w400,
                                    color: subtitleColor,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Section 1: Feature Card 1 (Connected to classroom)
                        FadeTransition(
                          opacity: _fadeAnimations[1],
                          child: SlideTransition(
                            position: _slideAnimations[1],
                            child: IntroFeatureCard.highlighted(
                              title: 'Connected to your classroom',
                              description: 'A simple check. A clear record.',
                              leading: const DashedCircleBadge(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Section 2: Feature Card 2 (Location-verified attendance)
                        FadeTransition(
                          opacity: _fadeAnimations[2],
                          child: SlideTransition(
                            position: _slideAnimations[2],
                            child: const IntroFeatureCard.standard(
                              title: 'Location-verified attendance',
                              description:
                                  "See active sessions anywhere. Attend within your teacher's allowed radius.",
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Section 3: Feature Card 3 (Timed in-app quizzes)
                        FadeTransition(
                          opacity: _fadeAnimations[3],
                          child: SlideTransition(
                            position: _slideAnimations[3],
                            child: const IntroFeatureCard.standard(
                              title: 'Timed in-app quizzes',
                              description:
                                  'Answer in the time left in the 2-minute session.',
                              highlightText: "A perfect score isn't required.",
                            ),
                          ),
                        ),

                        // Flexible spacer to push action buttons comfortably to the bottom
                        const Spacer(),
                        const SizedBox(height: 28),

                        // Section 4: Bottom Action Button & Sign In Link
                        FadeTransition(
                          opacity: _fadeAnimations[3],
                          child: SlideTransition(
                            position: _slideAnimations[3],
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Get Started Primary Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _onGetStartedPressed,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Get started',
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Already have an account? Sign in
                                Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account? ',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w400,
                                          color: subtitleColor,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _onSignInPressed,
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            'Sign in',
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
