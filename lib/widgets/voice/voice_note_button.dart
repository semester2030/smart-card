import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/voice_note_service.dart';
import '../../services/ai_text_processor.dart';
import '../../utils/helpers.dart';

/// Voice Note Button Widget
/// زر الملاحظات الصوتية
class VoiceNoteButton extends StatefulWidget {
  final Function(String) onTranscriptionComplete;
  final Function(String)? onPartialTranscription;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  const VoiceNoteButton({
    super.key,
    required this.onTranscriptionComplete,
    this.onPartialTranscription,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  @override
  State<VoiceNoteButton> createState() => _VoiceNoteButtonState();
}

class _VoiceNoteButtonState extends State<VoiceNoteButton>
    with SingleTickerProviderStateMixin {
  final VoiceNoteService _voiceService = VoiceNoteService();
  final AITextProcessor _aiProcessor = AITextProcessor();
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  bool _isListening = false;
  String _currentText = '';
  StreamSubscription<String>? _transcriptionSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    final available = await _voiceService.isAvailable();
    if (!available && mounted) {
      Helpers.showErrorSnackBar(
        context,
        'خدمة التعرف على الصوت غير متاحة',
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transcriptionSubscription?.cancel();
    _voiceService.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    final hasPermission = await _voiceService.hasPermission();
    if (!hasPermission) {
      final granted = await _voiceService.requestPermission();
      if (!granted && mounted) {
        Helpers.showErrorSnackBar(
          context,
          'يجب السماح بالوصول إلى الميكروفون',
        );
        return;
      }
    }

    final started = await _voiceService.startListening();
    if (!started && mounted) {
      Helpers.showErrorSnackBar(
        context,
        'فشل بدء التسجيل',
      );
      return;
    }

    setState(() {
      _isListening = true;
      _currentText = '';
    });

    _animationController.repeat(reverse: true);

    // Listen to transcription stream
    _transcriptionSubscription?.cancel();
    _transcriptionSubscription = _voiceService.transcriptionStream.listen(
      (text) {
        setState(() {
          _currentText = text;
        });
        widget.onPartialTranscription?.call(text);
      },
    );

    if (mounted) {
      Helpers.showSuccessSnackBar(context, 'جاري التسجيل...');
    }
  }

  Future<void> _stopListening() async {
    await _voiceService.stopListening();
    _transcriptionSubscription?.cancel();

    setState(() {
      _isListening = false;
    });

    _animationController.stop();
    _animationController.reset();

    // Process transcription with AI
    final rawText = _voiceService.getLastWords();
    if (rawText.isNotEmpty) {
      if (mounted) {
        Helpers.showSuccessSnackBar(context, 'جاري معالجة النص...');
      }

      // Process with AI
      final processedText = await _aiProcessor.processTranscription(rawText);
      
      if (mounted) {
        widget.onTranscriptionComplete(processedText);
        Helpers.showSuccessSnackBar(context, 'تم تحويل الصوت إلى نص!');
      }
    } else {
      if (mounted) {
        Helpers.showErrorSnackBar(context, 'لم يتم التعرف على أي نص');
      }
    }

    setState(() {
      _currentText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size ?? 56.0;
    final backgroundColor = widget.backgroundColor ?? 
        (_isListening 
            ? Theme.of(context).colorScheme.error 
            : Theme.of(context).colorScheme.primary);
    final iconColor = widget.iconColor ?? Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isListening && _currentText.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _currentText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        GestureDetector(
          onTap: _toggleListening,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isListening ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: _isListening
                        ? [
                            BoxShadow(
                              color: backgroundColor.withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: iconColor,
                    size: size * 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

