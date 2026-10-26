import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/usecases/create_class_usecase.dart';

/// Modal dialog allowing doctors to input class metadata and trigger creation.
class CreateClassDialog extends StatefulWidget {
  final String teacherId;
  final String teacherName;
  final Function(CreateClassParams params) onSubmit;

  const CreateClassDialog({
    super.key,
    required this.teacherId,
    required this.teacherName,
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required String teacherId,
    required String teacherName,
    required Function(CreateClassParams params) onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (_) => CreateClassDialog(
        teacherId: teacherId,
        teacherName: teacherName,
        onSubmit: onSubmit,
      ),
    );
  }

  @override
  State<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<CreateClassDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _roomController = TextEditingController();
  final _scheduleController = TextEditingController();
  final _termController = TextEditingController(text: 'Fall 2026');
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _roomController.dispose();
    _scheduleController.dispose();
    _termController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      final params = CreateClassParams(
        name: _nameController.text.trim(),
        courseCode: _codeController.text.trim().toUpperCase(),
        description: _descriptionController.text.trim(),
        teacherId: widget.teacherId,
        teacherName: widget.teacherName,
      );

      widget.onSubmit(params);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppColors.cardWhite,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create new class',
                      style: TextStyle(
                        color: AppColors.primaryNavy,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Class Name Field
                _buildField(
                  controller: _nameController,
                  label: 'Class Name',
                  hint: 'e.g. Data Structures',
                  isRequired: true,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter class name' : null,
                ),
                const SizedBox(height: 14),

                // Course Code Field
                _buildField(
                  controller: _codeController,
                  label: 'Course Code',
                  hint: 'e.g. CS201',
                  isRequired: true,
                  textCapitalization: TextCapitalization.characters,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Please enter course code' : null,
                ),
                const SizedBox(height: 14),

                // Term & Room row
                Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        controller: _termController,
                        label: 'Semester / Term',
                        hint: 'e.g. Fall 2026',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _roomController,
                        label: 'Room',
                        hint: 'e.g. Eng 204',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Schedule Field
                _buildField(
                  controller: _scheduleController,
                  label: 'Schedule',
                  hint: 'e.g. Mon / Wed • 10:00 AM',
                ),
                const SizedBox(height: 14),

                // Description Field
                _buildField(
                  controller: _descriptionController,
                  label: 'Description (Optional)',
                  hint: 'Course syllabus and topics...',
                  maxLines: 2,
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: AppColors.borderLight),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.brandBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: _handleCreate,
                        child: const Text('Create Class', style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: const TextStyle(
            color: AppColors.primaryNavy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          textCapitalization: textCapitalization,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.brandBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
