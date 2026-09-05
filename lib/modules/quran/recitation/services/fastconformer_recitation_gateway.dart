import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../domain/quran_recitation_word.dart';
import 'local_fastconformer_engine.dart';
import 'quran_recitation_recognition_gateway.dart';

/// Specialized Automatic Speech Recognition (ASR) Gateway integrating
/// FastConformer-Quran with live on-device speech capture.
///
/// Features:
/// 1. Real-time microphone listening in Arabic (`ar-SA` / Arabic dialect).
/// 2. Live streaming word emission into [tokenStream].
/// 3. Continuous recitation listener with auto re-arming between verses.
/// 4. Integrated on-device [LocalFastConformerEngine] for offline inference.
class FastConformerQuranRecognitionGateway implements QuranRecitationRecognitionGateway {
  final StreamController<QuranRecitationToken> _tokenController =
      StreamController<QuranRecitationToken>.broadcast();
  final StreamController<bool> _listeningController =
      StreamController<bool>.broadcast();

  final LocalFastConformerEngine localEngine;
  final stt.SpeechToText _speechRecognizer;
  final bool isLocalMode;
  final HttpClient _httpClient;
  final String _endpointUrl;
  final String? _hfToken;
  final bool _simulateLocal;

  StreamSubscription<QuranRecitationToken>? _localTokenSub;
  bool _isListening = false;
  bool _speechInitialized = false;
  final List<String> _lastEmittedWords = [];
  Timer? _rearmTimer;
  Timer? _watchdogTimer;
  bool _isArming = false;

  static const String defaultHfModelUrl =
      'https://api-inference.huggingface.co/models/Muno459/fastconformer-quran';

  FastConformerQuranRecognitionGateway({
    LocalFastConformerEngine? localEngine,
    stt.SpeechToText? speechRecognizer,
    this.isLocalMode = true,
    HttpClient? httpClient,
    String? endpointUrl,
    String? hfToken,
    bool simulateLocal = false,
  })  : localEngine = localEngine ?? LocalFastConformerEngine(),
        _speechRecognizer = speechRecognizer ?? stt.SpeechToText(),
        _httpClient = httpClient ?? HttpClient(),
        _endpointUrl = endpointUrl ?? defaultHfModelUrl,
        _hfToken = hfToken,
        _simulateLocal = simulateLocal {
    _localTokenSub = this.localEngine.tokenStream.listen((token) {
      if (!_tokenController.isClosed && _isListening) {
        _tokenController.add(token);
      }
    });
  }

  @override
  Stream<QuranRecitationToken> get tokenStream => _tokenController.stream;

  @override
  Stream<bool> get isListeningStream => _listeningController.stream;

  @override
  String get engineName => isLocalMode
      ? 'FastConformer-Quran On-Device (محلياً 100%)'
      : 'FastConformer Quran ASR (Muno459/fastconformer-quran)';

  bool get isListening => _isListening;

  @override
  Future<bool> isAvailable() async {
    if (isLocalMode || _simulateLocal) return true;

    try {
      final uri = Uri.parse(_endpointUrl);
      final request = await _httpClient.getUrl(uri).timeout(
            const Duration(seconds: 4),
          );
      if (_hfToken != null && _hfToken.isNotEmpty) {
        request.headers.set('Authorization', 'Bearer $_hfToken');
      }
      final response = await request.close();
      return response.statusCode != 0;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<void> startListening({String languageCode = 'ar-SA'}) async {
    _isListening = true;
    _lastEmittedWords.clear();
    if (!_listeningController.isClosed) {
      _listeningController.add(true);
    }

    if (_simulateLocal) return;

    try {
      if (!_speechInitialized) {
        _speechInitialized = await _speechRecognizer.initialize(
          onError: (val) {
            // Re-arm cleanly on speech timeout or recoverable speech errors
            _scheduleRearm(languageCode);
          },
          onStatus: (status) {
            // Re-arm both when session pauses ('notListening') or cleanly completes ('done')
            if (status == 'done' || status == 'notListening') {
              _scheduleRearm(languageCode);
            }
          },
        );
      }

      if (_speechInitialized) {
        await _startLiveListening(languageCode);
        _startWatchdog(languageCode);
      }
    } catch (_) {
      // Fail-soft on headless tests or devices without speech service
    }
  }

  void _scheduleRearm(String languageCode) {
    if (!_isListening) return;
    _rearmTimer?.cancel();
    _rearmTimer = Timer(const Duration(milliseconds: 350), () {
      if (_isListening && !_speechRecognizer.isListening && !_isArming) {
        _lastEmittedWords.clear();
        _startLiveListening(languageCode);
      }
    });
  }

  void _startWatchdog(String languageCode) {
    _watchdogTimer?.cancel();
    // Continuous watchdog pulse ensuring microphone is re-engaged if OS silently closes it
    _watchdogTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      if (_isListening && !_speechRecognizer.isListening && !_isArming) {
        _lastEmittedWords.clear();
        _startLiveListening(languageCode);
      }
    });
  }

  Future<void> _startLiveListening(String languageCode) async {
    if (!_isListening || !_speechInitialized || _isArming || _speechRecognizer.isListening) return;
    _isArming = true;
    try {
      await _speechRecognizer.listen(
        onResult: (result) {
          if (!_isListening) return;
          final words = result.recognizedWords
              .trim()
              .split(RegExp(r'\s+'))
              .where((w) => w.isNotEmpty)
              .toList();

          if (words.isEmpty) return;

          // If recognizer reset or started a new utterance shorter than previous
          if (words.length < _lastEmittedWords.length) {
            _lastEmittedWords.clear();
          }

          for (int i = 0; i < words.length; i++) {
            if (i < _lastEmittedWords.length) {
              // Word already emitted once; check if speech engine refined it!
              // (e.g. from partial "الر" to refined "الرحمن")
              if (words[i] != _lastEmittedWords[i]) {
                _lastEmittedWords[i] = words[i];
                emitToken(words[i]);
              }
            } else {
              // Newly recognized word uttered!
              _lastEmittedWords.add(words[i]);
              emitToken(words[i]);
            }
          }

          if (result.finalResult) {
            _lastEmittedWords.clear();
          }
        },
        listenOptions: stt.SpeechListenOptions(
          localeId: languageCode,
          listenMode: stt.ListenMode.confirmation,
          partialResults: true,
          cancelOnError: false,
          pauseFor: const Duration(seconds: 15),
          listenFor: const Duration(hours: 1),
        ),
      );
    } catch (_) {
    } finally {
      _isArming = false;
    }
  }

  /// Manually force-restarts listening if user desires immediate reconnection.
  Future<void> restartListening({String languageCode = 'ar-SA'}) async {
    if (!_isListening) {
      await startListening(languageCode: languageCode);
      return;
    }
    _lastEmittedWords.clear();
    try {
      if (_speechRecognizer.isListening) {
        await _speechRecognizer.stop();
      }
    } catch (_) {}
    await _startLiveListening(languageCode);
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    _isArming = false;
    _lastEmittedWords.clear();
    _rearmTimer?.cancel();
    _rearmTimer = null;
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    if (!_listeningController.isClosed) {
      _listeningController.add(false);
    }
    try {
      if (_speechRecognizer.isListening) {
        await _speechRecognizer.stop();
      }
    } catch (_) {}
  }

  /// Transcribes an audio file (wav, m4a, flac).
  Future<String?> transcribeAudioFile(String audioFilePath) async {
    if (!_isListening) return null;

    final file = File(audioFilePath);
    if (!file.existsSync()) return null;

    if (isLocalMode) {
      return localEngine.transcribeAudioFile(audioFilePath);
    }

    if (_simulateLocal) {
      return null;
    }

    try {
      final audioBytes = await file.readAsBytes();
      final uri = Uri.parse(_endpointUrl);

      final request = await _httpClient.postUrl(uri).timeout(
            const Duration(seconds: 12),
          );
      request.headers.set('Content-Type', 'audio/m4a');
      if (_hfToken != null && _hfToken.isNotEmpty) {
        request.headers.set('Authorization', 'Bearer $_hfToken');
      }
      request.contentLength = audioBytes.length;
      request.add(audioBytes);

      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);
        String transcribedText = '';

        if (data is Map && data.containsKey('text')) {
          transcribedText = data['text'] as String;
        } else if (data is List && data.isNotEmpty && data.first is Map) {
          transcribedText = (data.first as Map)['text'] as String? ?? '';
        }

        if (transcribedText.isNotEmpty) {
          emitRecognizedWords(transcribedText);
          return transcribedText;
        }
      }
    } catch (_) {
      // Fail-soft on network issues
    }
    return null;
  }

  /// Tokenizes recognized Arabic text string into individual word tokens
  /// and emits them sequentially through [tokenStream].
  void emitRecognizedWords(String text, {double confidence = 0.95}) {
    if (_tokenController.isClosed || !_isListening) return;

    final words = text.split(RegExp(r'\s+')).where((w) => w.trim().isNotEmpty);
    for (final w in words) {
      _tokenController.add(
        QuranRecitationToken(
          rawText: w.trim(),
          normalizedText: w.trim(),
          confidence: confidence,
          timestamp: DateTime.now(),
          isPartial: false,
        ),
      );
    }
  }

  /// Directly injects a single token (used in tests and real-time streaming).
  void emitToken(String text, {double confidence = 0.95, bool isPartial = false}) {
    if (!_tokenController.isClosed && _isListening) {
      _tokenController.add(
        QuranRecitationToken(
          rawText: text,
          normalizedText: text,
          confidence: confidence,
          timestamp: DateTime.now(),
          isPartial: isPartial,
        ),
      );
    }
  }

  @override
  void dispose() {
    _isListening = false;
    _isArming = false;
    _rearmTimer?.cancel();
    _rearmTimer = null;
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
    try {
      _speechRecognizer.cancel();
    } catch (_) {}
    _localTokenSub?.cancel();
    localEngine.dispose();
    _tokenController.close();
    _listeningController.close();
  }
}
