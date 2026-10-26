import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/class_entity.dart';
import '../bloc/classes_cubit.dart';
import '../bloc/classes_state.dart';
import '../widgets/class_card.dart';
import '../widgets/create_class_dialog.dart';
import 'class_details_page.dart';

/// Doctor's dashboard page displaying all created classes with search, filters, and creation action.
class TeacherClassesPage extends StatefulWidget {
  final String teacherId;
  final String teacherName;

  const TeacherClassesPage({
    super.key,
    required this.teacherId,
    this.teacherName = 'Doctor',
  });

  @override
  State<TeacherClassesPage> createState() => _TeacherClassesPageState();
}

class _TeacherClassesPageState extends State<TeacherClassesPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadClasses() {
    context.read<ClassesCubit>().loadTeacherClasses(widget.teacherId);
  }

  void _openCreateDialog() {
    CreateClassDialog.show(
      context: context,
      teacherId: widget.teacherId,
      teacherName: widget.teacherName,
      onSubmit: (params) {
        context.read<ClassesCubit>().createClass(params);
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
          'My Classes',
          style: TextStyle(
            color: AppColors.primaryNavy,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryNavy),
            onPressed: _loadClasses,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.brandBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create class', style: TextStyle(fontWeight: FontWeight.w600)),
        onPressed: _openCreateDialog,
      ),
      body: BlocConsumer<ClassesCubit, ClassesState>(
        listener: (context, state) {
          if (state is ClassCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Class "${state.newClass.name}" created! Join code: ${state.newClass.joinCode}'),
                backgroundColor: AppColors.tealDark,
                behavior: SnackBarBehavior.floating,
              ),
            );
            _loadClasses();
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
          if (state is ClassesLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            );
          }

          if (state is ClassesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.errorRed),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandBlue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _loadClasses,
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TeacherClassesLoaded) {
            return _buildContent(state.classes);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(List<ClassEntity> classes) {
    final filtered = classes.where((c) {
      if (_searchQuery.isEmpty) return true;
      final nameMatches = c.name.toLowerCase().contains(_searchQuery);
      final codeMatches = c.courseCode.toLowerCase().contains(_searchQuery);
      return nameMatches || codeMatches;
    }).toList();

    return Column(
      children: [
        // Search bar (matching Figma "Class name or code")
        Container(
          color: AppColors.cardWhite,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Class name or code...',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.textMuted),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textMuted),
                      onPressed: () => _searchController.clear(),
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
              ),
            ),
          ),
        ),

        // List or Empty State
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState(isSearchResult: _searchQuery.isNotEmpty)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final classItem = filtered[index];
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
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required bool isSearchResult}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearchResult ? Icons.search_off_rounded : Icons.school_outlined,
              size: 56,
              color: AppColors.textMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              isSearchResult ? 'No classes match your search' : 'No classes created yet',
              style: const TextStyle(
                color: AppColors.primaryNavy,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearchResult
                  ? 'Try checking the spelling or searching for another code'
                  : 'Tap the button below to create your first class and share the code with your students.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
