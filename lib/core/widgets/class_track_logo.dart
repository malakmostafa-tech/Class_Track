import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/theme_extensions.dart';

/// Reusable brand logo widget for ClassTrack displaying the academic mortarboard
/// icon inside a rounded container alongside the stylized brand name.
class ClassTrackLogo extends StatelessWidget {
  /// The width and height of the icon container.
  final double iconSize;

  /// The font size of the "ClassTrack" brand text.
  final double? fontSize;

  /// Whether to display the text next to the icon container.
  final bool showText;

  /// Optional override for the icon container background color.
  final Color? containerColor;

  /// Optional override for the mortarboard icon color.
  final Color? iconColor;

  /// Optional override for the brand text color.
  final Color? textColor;

  /// Custom border radius for the icon container.
  final double? borderRadius;

  /// Spacing between the icon container and the brand text.
  final double? spacing;

  /// Horizontal layout alignment for the row.
  final MainAxisAlignment alignment;

  /// Whether to apply a subtle soft shadow beneath the icon box.
  final bool showShadow;

  /// Optional tap handler for the logo.
  final VoidCallback? onTap;

  const ClassTrackLogo({
    super.key,
    this.iconSize = 40.0,
    this.fontSize,
    this.showText = true,
    this.containerColor,
    this.iconColor,
    this.textColor,
    this.borderRadius,
    this.spacing,
    this.alignment = MainAxisAlignment.start,
    this.showShadow = false,
    this.onTap,
  });

  /// Factory constructor configured for the centered Splash screen presentation.
  factory ClassTrackLogo.splash({
    Key? key,
    double iconSize = 48.0,
    double fontSize = 26.0,
  }) {
    return ClassTrackLogo(
      key: key,
      iconSize: iconSize,
      fontSize: fontSize,
      alignment: MainAxisAlignment.center,
      showShadow: true,
    );
  }

  /// Factory constructor configured for the Header/AppBar presentation.
  factory ClassTrackLogo.header({
    Key? key,
    double iconSize = 36.0,
    double fontSize = 20.0,
  }) {
    return ClassTrackLogo(
      key: key,
      iconSize: iconSize,
      fontSize: fontSize,
      alignment: MainAxisAlignment.start,
      showShadow: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color effectiveContainerColor = containerColor ??
        (isDark ? AppColors.primary : AppColors.primaryDark);

    final Color effectiveTextColor = textColor ??
        (isDark ? AppColors.darkTextPrimary : AppColors.primaryDark);

    final double effectiveFontSize = fontSize ?? (iconSize * 0.55);
    final double effectiveRadius = borderRadius ?? (iconSize * 0.26);
    final double effectiveSpacing = spacing ?? (iconSize * 0.28);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: effectiveContainerColor,
            borderRadius: BorderRadius.circular(effectiveRadius),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: effectiveContainerColor.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.school_rounded,
            size: iconSize * 0.58,
            color: iconColor ?? AppColors.white,
          ),
        ),
        if (showText) ...[
          SizedBox(width: effectiveSpacing),
          Text(
            'ClassTrack',
            style: TextStyle(
              fontSize: effectiveFontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: effectiveTextColor,
              height: 1.1,
            ),
          ),
        ],
      ],
    );

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
