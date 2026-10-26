import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/class_entity.dart';
import '../bloc/classes_cubit.dart';
import '../bloc/classes_state.dart';
import '../widgets/class_card.dart';
import '../widgets/join_class_dialog.dart';
import 'class_details_page.dart';

/// Student's classes page displaying all enrolled courses and a join code action.
class StudentClassesPage extends StatefulWidget {
  final String studentId;
  final String studentName;
  final List<ClassEntity> initialClasses;

  const StudentClassesPage({
    super.key,
    required this.studentId,
    this.studentName = 'Student',
    this.initialClasses = const [],
  });

  @override
  State<StudentClassesPage> createState() => _StudentClassesPageState();
}

class _StudentClassesPageState extends State<StudentClassesPage> {
  late List<ClassEntity> _enrolledClasses;

  @override
  void initState() {
    super.initState();
    _enrolledClasses = List.from(widget.initialClasses);
  }

  void _openJoinDialog() {
    JoinClassDialog.show(
      context: context,
      onSubmit: (code) {
        context.read<ClassesCubit>().joinClassByCode(
          joinCode: code,
          studentId: widget.studentId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardWhite,
        elevation: 0,
        title: const Text(
          'Your classes',
          style: TextStyle(
            color: AppColors.primaryNavy,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Join class', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              onPressed: _openJoinDialog,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ClassesCubit, ClassesState>(
        listener: (context, state) {
          if (state is ClassJoinedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Enrolled in "${state.joinedClass.name}" successfully!'),
                backgroundColor: AppColors.tealDark,
                behavior: SnackBarBehavior.floating,
              ),
            );
            setState(() {
              // Add or update class in local list
              final index = _enrolledClasses.indexWhere((c) => c.id == state.joinedClass.id);
              if (index >= 0) {
                _enrolledClasses[index] = state.joinedClass;
              } else {
                _enrolledClasses.add(state.joinedClass);
              }
            });
          } else if (state is ClassesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorRed,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ClassesLoading && _enrolledClasses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            );
          }

          if (_enrolledClasses.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _enrolledClasses.length,
            itemBuilder: (context, index) {
              final classItem = _enrolledClasses[index];
              return ClassCard(
                classEntity: classItem,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ClassDetailsPage(classEntity: classItem),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.blueLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.blueBorder),
              ),
              child: const Icon(
                Icons.class_outlined,
                size: 36,
                color: AppColors.brandBlue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No classes joined yet',
              style: TextStyle(
                color: AppColors.primaryNavy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ask your instructor for the 6-character class code, then tap the button below to join.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              icon: const Icon(Icons.vpn_key_rounded, size: 18),
              label: const Text('Join your first class', style: TextStyle(fontWeight: FontWeight.w600)),
              onPressed: _openJoinDialog,
            ),
          ],
        ),
      ),
    );
  }
}
