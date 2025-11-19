import 'package:flutter/material.dart';
import '../voice/voice_note_button.dart';
import 'text_input.dart';

/// Note Input with Voice Recording
/// حقل إدخال الملاحظات مع تسجيل صوتي
class NoteInputWithVoice extends StatefulWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Function(String)? onSaved;
  final int? maxLines;

  const NoteInputWithVoice({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.onSaved,
    this.maxLines = 5,
  });

  @override
  State<NoteInputWithVoice> createState() => _NoteInputWithVoiceState();
}

class _NoteInputWithVoiceState extends State<NoteInputWithVoice> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTranscriptionComplete(String text) {
    _controller.text = text;
    widget.onSaved?.call(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextInput(
                controller: _controller,
                hint: widget.hint ?? 'اكتب ملاحظتك هنا...',
                maxLines: widget.maxLines,
              ),
            ),
            const SizedBox(width: 12),
            VoiceNoteButton(
              onTranscriptionComplete: _onTranscriptionComplete,
              onPartialTranscription: (text) {
                // Optional: Update text field in real-time
                // _controller.text = text;
              },
              size: 48,
            ),
          ],
        ),
      ],
    );
  }
}

