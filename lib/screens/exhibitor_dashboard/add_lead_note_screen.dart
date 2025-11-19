import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/exhibitor_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/forms/note_input_with_voice.dart';
import '../../utils/helpers.dart';

/// Add Lead Note Screen for Exhibitor
/// شاشة إضافة ملاحظة للـ Lead (للعارض)
class AddLeadNoteScreen extends StatefulWidget {
  final String leadId;
  final String leadName;

  const AddLeadNoteScreen({
    super.key,
    required this.leadId,
    required this.leadName,
  });

  @override
  State<AddLeadNoteScreen> createState() => _AddLeadNoteScreenState();
}

class _AddLeadNoteScreenState extends State<AddLeadNoteScreen> {
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (_noteController.text.trim().isEmpty) {
      Helpers.showErrorSnackBar(context, 'يرجى إدخال نص الملاحظة');
      return;
    }

    final exhibitorProvider = Provider.of<ExhibitorProvider>(context, listen: false);
    final lead = exhibitorProvider.getLeadById(widget.leadId);
    
    if (lead != null) {
      final updatedLead = lead.copyWith(
        notes: _noteController.text.trim(),
        updatedAt: DateTime.now(),
      );
      
      final success = await exhibitorProvider.updateLead(updatedLead);

      if (!mounted) return;

      if (success) {
        Helpers.showSuccessSnackBar(context, 'تم حفظ الملاحظة بنجاح!');
        Navigator.of(context).pop();
      } else {
        Helpers.showErrorSnackBar(
          context,
          exhibitorProvider.error ?? 'فشل حفظ الملاحظة',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ملاحظة للـ Lead'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lead',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                widget.leadName,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Note Input with Voice
                NoteInputWithVoice(
                  controller: _noteController,
                  label: 'الملاحظة',
                  hint: 'اكتب ملاحظتك هنا أو اضغط على الميكروفون للتسجيل الصوتي...',
                  maxLines: 8,
                  onSaved: (text) {
                    // Optional: Auto-save when voice transcription completes
                  },
                ),
                const SizedBox(height: 24),
                // Info Card
                Card(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'يمكنك كتابة الملاحظة يدوياً أو استخدام التسجيل الصوتي',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Save Button
                Consumer<ExhibitorProvider>(
                  builder: (context, exhibitorProvider, _) {
                    return PrimaryButton(
                      text: 'حفظ الملاحظة',
                      icon: Icons.save,
                      isLoading: exhibitorProvider.isLoading,
                      onPressed: _saveNote,
                      width: double.infinity,
                    );
                  },
                ),
                const SizedBox(height: 12),
                SecondaryButton(
                  text: 'إلغاء',
                  onPressed: () => Navigator.of(context).pop(),
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

