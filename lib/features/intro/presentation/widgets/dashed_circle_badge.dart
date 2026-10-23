import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';

/// A custom-painted circular badge featuring a dashed outer perimeter ring,
/// a centered location pin icon, and a floating green checkmark badge.
class DashedCircleBadge extends StatelessWidget {
  /// Overall diameter of the badge area.
  final double size;

  /// Diameter of the inner filled circle.
  final double innerCircleSize;

  /// Color of the dashed outer circle.
  final Color? dashColor;

  /// Background color of the inner circle.
  final Color? innerBackgroundColor;

  /// Color of the centered icon.
  final Color? iconColor;

  /// The icon displayed in the center.
  final IconData icon;

  /// Whether to show the bottom-right status check badge.
  final bool showCheckBadge;

  /// Background color of the status badge.
  final Color? checkBadgeColor;

  const DashedCircleBadge({
    super.key,
    this.size = 56.0,
    this.innerCircleSize = 44.0,
    this.dashColor,
    this.innerBackgroundColor,
    this.iconColor,
    this.icon = Icons.location_on_outlined,
    this.showCheckBadge = true,
    this.checkBadgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    final Color effectiveDashColor = dashColor ??
        (isDark
            ? AppColors.primaryLight.withValues(alpha: 0.45)
            : const Color(0xFF93C5FD)); // Light sky blue

    final Color effectiveInnerBg = innerBackgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.white);

    final Color effectiveIconColor = iconColor ?? AppColors.primary;

    final Color effectiveBadgeColor = checkBadgeColor ??
        const Color(0xFF10B981); // Emerald green

    final Color badgeBorderColor = isDark
        ? const Color(0xFF1E293B)
        : const Color(0xFFEFF6FF);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Dashed outer ring
          CustomPaint(
            size: Size(size, size),
            painter: _DashedCirclePainter(
              color: effectiveDashColor,
              strokeWidth: 1.5,
              dashCount: 22,
            ),
          ),

          // Inner solid circle
          Container(
            width: innerCircleSize,
            height: innerCircleSize,
            decoration: BoxDecoration(
              color: effectiveInnerBg,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: effectiveIconColor.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: innerCircleSize * 0.52,
              color: effectiveIconColor,
            ),
          ),

          // Bottom-Right checkmark status badge
          if (showCheckBadge)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: effectiveBadgeColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: badgeBorderColor,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: effectiveBadgeColor.withValues(alpha: 0.35),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_rounded,
                  size: 11,
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Custom painter that draws a dashed circular circumference with exact spacing.
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  const _DashedCirclePainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashCount = 22,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = (size.width - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double sweepAngle = (2 * math.pi) / dashCount;
    final double dashAngle = sweepAngle * 0.52;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * sweepAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashCount != dashCount;
}
