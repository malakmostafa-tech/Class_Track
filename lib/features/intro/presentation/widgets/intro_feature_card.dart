import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';

/// Presentation card displaying key product features on the Intro / Onboarding screen.
///
/// Supports highlighted styling (with leading badge/graphic) and standard clean
/// bordered card styling with optional note/callout text.
class IntroFeatureCard extends StatelessWidget {
  /// Primary title of the feature.
  final String title;

  /// Secondary explanatory description.
  final String description;

  /// Optional leading widget (e.g., [DashedCircleBadge]).
  final Widget? leading;

  /// Optional highlight text displayed below the description (e.g., "A perfect score isn't required.").
  final String? highlightText;

  /// Color override for the highlight text.
  final Color? highlightTextColor;

  /// Whether this card is visually emphasized with the brand tint background.
  final bool isHighlighted;

  /// Optional tap handler for interactive preview.
  final VoidCallback? onTap;

  const IntroFeatureCard({
    super.key,
    required this.title,
    required this.description,
    this.leading,
    this.highlightText,
    this.highlightTextColor,
    this.isHighlighted = false,
    this.onTap,
  });

  /// Named constructor for the highlighted classroom card with leading badge.
  const IntroFeatureCard.highlighted({
    super.key,
    required this.title,
    required this.description,
    required Widget this.leading,
    this.onTap,
  })  : highlightText = null,
        highlightTextColor = null,
        isHighlighted = true;

  /// Named constructor for the standard white bordered feature card.
  const IntroFeatureCard.standard({
    super.key,
    required this.title,
    required this.description,
    this.highlightText,
    this.highlightTextColor,
    this.onTap,
  })  : leading = null,
        isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    // Card Colors based on theme & highlight state
    final Color backgroundColor;
    final Color borderColor;

    if (isHighlighted) {
      backgroundColor = isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF0F6FE); // Soft ice blue tint
      borderColor = isDark
          ? const Color(0xFF334155)
          : const Color(0xFFDBEAFE); // Subtle blue border
    } else {
      backgroundColor = isDark
          ? AppColors.darkSurface
          : AppColors.lightSurface;
      borderColor = isDark
          ? AppColors.darkBorder
          : AppColors.lightBorder;
    }

    final Color titleColor = isDark
        ? AppColors.darkTextPrimary
        : const Color(0xFF1E293B);

    final Color descColor = isDark
        ? AppColors.darkTextSecondary
        : const Color(0xFF64748B);

    final Color effectiveHighlightColor = highlightTextColor ??
        (isDark ? AppColors.secondaryLight : const Color(0xFF0F766E));

    Widget content;

    if (leading != null) {
      // Row layout for leading icon + text
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading!,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                    color: descColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Column layout for standard cards
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              height: 1.45,
              color: descColor,
            ),
          ),
          if (highlightText != null) ...[
            const SizedBox(height: 10),
            Text(
              highlightText!,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: effectiveHighlightColor,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ],
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: content,
          ),
        ),
      ),
    );
  }
}
