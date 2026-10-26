import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/class_entity.dart';

/// Reusable class card widget matching the Figma design specifications.
class ClassCard extends StatelessWidget {
  final ClassEntity classEntity;
  final VoidCallback? onTap;

  const ClassCard({
    super.key,
    required this.classEntity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final termText = classEntity.term.isNotEmpty ? classEntity.term : 'Current Term';
    final countText = '${classEntity.studentCount} ${classEntity.studentCount == 1 ? 'student' : 'students'}';

    final scheduleDetails = [
      if (classEntity.schedule.isNotEmpty) classEntity.schedule,
      if (classEntity.room.isNotEmpty) classEntity.room,
    ].join(' • ');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Course Code & Name + Active Status Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '${classEntity.courseCode} • ${classEntity.name}',
                        style: const TextStyle(
                          color: AppColors.primaryNavy,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(isActive: classEntity.isActive),
                  ],
                ),
                const SizedBox(height: 10),

                // Row 2: Term & Student Count Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blueLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.blueBorder, width: 0.8),
                  ),
                  child: Text(
                    '$termText • $countText',
                    style: const TextStyle(
                      color: AppColors.brandBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Row 3: Schedule & Room (if available)
                if (scheduleDetails.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          scheduleDetails,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isActive;

  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final bgColor = isActive ? AppColors.tealLight : AppColors.borderLight;
    final textColor = isActive ? AppColors.tealDark : AppColors.textMuted;
    final text = isActive ? 'Active' : 'Closed';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.tealSuccess.withValues(alpha: 0.3) : Colors.transparent,
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
