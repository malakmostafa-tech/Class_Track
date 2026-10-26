import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/class_entity.dart';

/// Screen displaying in-depth class information, student roster, and the 6-character Join Code.
class ClassDetailsPage extends StatelessWidget {
  final ClassEntity classEntity;

  const ClassDetailsPage({
    super.key,
    required this.classEntity,
  });

  void _copyJoinCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: classEntity.joinCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Join Code "${classEntity.joinCode}" copied to clipboard!'),
        backgroundColor: AppColors.tealDark,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryNavy),
        title: Text(
          classEntity.courseCode,
          style: const TextStyle(
            color: AppColors.primaryNavy,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Join Code Highlight Box
            _buildJoinCodeCard(context),
            const SizedBox(height: 16),

            // Class Information Card
            _buildInfoCard(),
            const SizedBox(height: 16),

            // Enrolled Students Roster
            _buildStudentsRoster(),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinCodeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandBlue.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'STUDENT JOIN CODE',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            classEntity.joinCode,
            style: const TextStyle(
              color: AppColors.brandBlue,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.brandBlue,
              side: const BorderSide(color: AppColors.brandBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: const Text('Copy Code', style: TextStyle(fontWeight: FontWeight.w600)),
            onPressed: () => _copyJoinCode(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            classEntity.name,
            style: const TextStyle(
              color: AppColors.primaryNavy,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (classEntity.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              classEntity.description,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
          const Divider(height: 24, color: AppColors.borderLight),
          _buildInfoRow(Icons.person_outline_rounded, 'Instructor', classEntity.teacherName),
          if (classEntity.schedule.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(Icons.schedule_rounded, 'Schedule', classEntity.schedule),
          ],
          if (classEntity.room.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(Icons.location_on_outlined, 'Room', classEntity.room),
          ],
          if (classEntity.term.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildInfoRow(Icons.school_outlined, 'Semester', classEntity.term),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryNavy,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsRoster() {
    final students = classEntity.enrolledStudentIds;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Enrolled Students',
                style: TextStyle(
                  color: AppColors.primaryNavy,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.blueLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${classEntity.studentCount}',
                  style: const TextStyle(
                    color: AppColors.brandBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (students.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No students enrolled yet.\nShare the join code above with your class.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              separatorBuilder: (_, __) => const Divider(height: 12, color: AppColors.borderLight),
              itemBuilder: (context, index) {
                final studentId = students[index];
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.blueLight,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: AppColors.brandBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Student ID: $studentId',
                        style: const TextStyle(
                          color: AppColors.primaryNavy,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppColors.tealSuccess,
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
