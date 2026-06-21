import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechService extends ChangeNotifier {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;
  String _lastWords = '';
  double _soundLevel = 0.0;

  bool get isListening => _isListening;
  String get lastWords => _lastWords;
  double get soundLevel => _soundLevel;

  final _soundLevelController = StreamController<double>.broadcast();
  Stream<double> get soundLevelStream => _soundLevelController.stream;

  Future<bool> initSpeech() async {
    if (_isInitialized) return true;

    try {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        debugPrint('Microphone permission denied');
        return false;
      }

      _isInitialized = await _speech.initialize(
        onError: (val) {
          debugPrint('Speech recognition error: $val');
          _isListening = false;
          notifyListeners();
        },
        onStatus: (val) {
          debugPrint('Speech recognition status: $val');
          if (val == 'listening') {
            _isListening = true;
          } else {
            _isListening = false;
          }
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Error initializing SpeechToText: $e');
      _isInitialized = false;
    }
    return _isInitialized;
  }

  Future<void> startListening(Function(String) onResult) async {
    final available = await initSpeech();
    if (!available) {
      // Fallback for emulator / mock speech input
      _isListening = true;
      _lastWords = 'Listening (Mock mode)...';
      notifyListeners();
      _mockListeningSequence(onResult);
      return;
    }

    _lastWords = '';
    _isListening = true;
    notifyListeners();

    await _speech.listen(
      onResult: (val) {
        _lastWords = val.recognizedWords;
        onResult(_lastWords);
        notifyListeners();
      },
      onSoundLevelChange: (level) {
        // Convert speech_to_text dB level (-2.0 to 10.0+) to 0.0 - 1.0 range
        final normalized = ((level + 2.0) / 12.0).clamp(0.0, 1.0);
        _soundLevel = normalized;
        _soundLevelController.add(normalized);
        notifyListeners();
      },
    );
  }

  Future<void> stopListening() async {
    if (!_isInitialized) {
      _isListening = false;
      _soundLevel = 0.0;
      _soundLevelController.add(0.0);
      notifyListeners();
      return;
    }
    await _speech.stop();
    _isListening = false;
    _soundLevel = 0.0;
    _soundLevelController.add(0.0);
    notifyListeners();
  }

  Timer? _mockTimer;
  void _mockListeningSequence(Function(String) onResult) {
    _mockTimer?.cancel();
    int count = 0;
    final List<String> mockWords = [
      'What',
      'What is',
      'What is digital',
      'What is digital abstract',
      'What is digital abstract design',
      'What is digital abstract design and',
      'What is digital abstract design and find',
      'What is digital abstract design and find 3',
      'What is digital abstract design and find 3 examples',
      'What is digital abstract design and find 3 examples of abstract design'
    ];

    _mockTimer = Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }
      if (count < mockWords.length) {
        _lastWords = mockWords[count];
        onResult(_lastWords);
        // Generate random mock sound levels
        final level = math.Random().nextDouble();
        _soundLevel = level;
        _soundLevelController.add(level);
        notifyListeners();
        count++;
      } else {
        stopListening();
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _mockTimer?.cancel();
    _soundLevelController.close();
    super.dispose();
  }
}
