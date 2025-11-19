import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/visitor_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/secondary_button.dart';
import '../../widgets/forms/note_input_with_voice.dart';
import '../../utils/helpers.dart';

/// Add Note Screen for Visitor
/// شاشة إضافة ملاحظة للزائر
class AddNoteScreen extends StatefulWidget {
  final String? contactId;
  final String? contactName;

  const AddNoteScreen({
    super.key,
    this.contactId,
    this.contactName,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
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

    final visitorProvider = Provider.of<VisitorProvider>(context, listen: false);
    
    final success = await visitorProvider.addNote(
      contactId: widget.contactId,
      contactName: widget.contactName,
      content: _noteController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Helpers.showSuccessSnackBar(context, 'تم حفظ الملاحظة بنجاح!');
      Navigator.of(context).pop();
    } else {
      Helpers.showErrorSnackBar(
        context,
        visitorProvider.error ?? 'فشل حفظ الملاحظة',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ملاحظة'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.contactName != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'جهة الاتصال',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  widget.contactName!,
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
                ],
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
                Consumer<VisitorProvider>(
                  builder: (context, visitorProvider, _) {
                    return PrimaryButton(
                      text: 'حفظ الملاحظة',
                      icon: Icons.save,
                      isLoading: visitorProvider.isLoading,
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

