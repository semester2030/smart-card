import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

/// Voice Note Service
/// خدمة الملاحظات الصوتية وتحويلها إلى نص
class VoiceNoteService {
  static final VoiceNoteService _instance = VoiceNoteService._internal();
  factory VoiceNoteService() => _instance;
  VoiceNoteService._internal();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  String _lastWords = '';
  final StreamController<String> _transcriptionController = StreamController<String>.broadcast();

  /// Stream for real-time transcription
  Stream<String> get transcriptionStream => _transcriptionController.stream;

  /// Check if speech recognition is available
  Future<bool> isAvailable() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (error) {
          debugPrint('Speech recognition error: $error');
        },
        onStatus: (status) {
          debugPrint('Speech recognition status: $status');
        },
      );
    }
    return _isInitialized;
  }

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Check microphone permission
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  /// Start listening for voice input
  Future<bool> startListening({
    String localeId = 'ar_SA', // Arabic (Saudi Arabia)
    bool listenFor = true,
    Duration? pauseFor,
    Duration? listenOptions,
  }) async {
    if (!_isInitialized) {
      final available = await isAvailable();
      if (!available) {
        return false;
      }
    }

    if (!await hasPermission()) {
      final granted = await requestPermission();
      if (!granted) {
        return false;
      }
    }

    if (_isListening) {
      return true;
    }

    _lastWords = '';
    _isListening = true;

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          _lastWords = result.recognizedWords;
          _transcriptionController.add(_lastWords);
          stopListening();
        } else {
          _transcriptionController.add(result.recognizedWords);
        }
      },
      localeId: localeId,
      listenFor: listenFor ? const Duration(seconds: 30) : null,
      pauseFor: pauseFor ?? const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      ),
      onSoundLevelChange: (level) {
        // Can be used for visual feedback
      },
    );

    return true;
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    await _speech.stop();
    _isListening = false;
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    if (!_isListening) return;
    
    await _speech.cancel();
    _isListening = false;
    _lastWords = '';
  }

  /// Get last recognized words
  String getLastWords() => _lastWords;

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Get available locales
  Future<List<stt.LocaleName>> getAvailableLocales() async {
    if (!_isInitialized) {
      await isAvailable();
    }
    return _speech.locales();
  }

  /// Dispose resources
  void dispose() {
    _transcriptionController.close();
  }
}

