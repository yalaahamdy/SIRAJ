import 'dart:async';
import '../domain/quran_recitation_word.dart';
export 'fastconformer_recitation_gateway.dart';

/// Gateway abstraction for Quranic recitation speech recognition (§5, §6).
/// Strictly decoupling Flutter UI from specific speech recognition backends.
/// Complies with zero generative AI rule and provides honest availability disclosure.
abstract class QuranRecitationRecognitionGateway {
  /// Stream of recognized spoken tokens emitted by the speech engine.
  Stream<QuranRecitationToken> get tokenStream;

  /// Whether the microphone and speech engine are currently listening.
  Stream<bool> get isListeningStream;

  /// Disclosed human-readable name of the underlying engine.
  String get engineName;

  /// Whether this recognition engine is confirmed available and functional on this device.
  Future<bool> isAvailable();

  /// Starts listening to speech via the microphone.
  Future<void> startListening({String languageCode = 'ar-SA'});

  /// Stops speech capture and closes current recognition session.
  Future<void> stopListening();

  /// Cleans up subscriptions and hardware resources.
  void dispose();
}

/// Simulated recognition gateway for headless unit tests and deterministic verification (§20).
class MockRecitationRecognitionGateway implements QuranRecitationRecognitionGateway {
  final StreamController<QuranRecitationToken> _tokenController =
      StreamController<QuranRecitationToken>.broadcast();
  final StreamController<bool> _listeningController =
      StreamController<bool>.broadcast();

  bool _isListening = false;
  bool simulateAvailable;

  MockRecitationRecognitionGateway({this.simulateAvailable = true});

  @override
  Stream<QuranRecitationToken> get tokenStream => _tokenController.stream;

  @override
  Stream<bool> get isListeningStream => _listeningController.stream;

  @override
  String get engineName => 'Mock Recitation Recognizer (Test)';

  @override
  Future<bool> isAvailable() async => simulateAvailable;

  @override
  Future<void> startListening({String languageCode = 'ar-SA'}) async {
    _isListening = true;
    _listeningController.add(true);
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    if (!_listeningController.isClosed) {
      _listeningController.add(false);
    }
  }

  /// Injects a recognized speech token into the stream during testing.
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
    _tokenController.close();
    _listeningController.close();
  }
}

/// Device-dependent native speech recognition adapter (§5).
/// Discloses honest device limitations and marks recognition as experimental
/// unless certified on the physical Android/iOS device.
class NativeSpeechRecognitionGateway implements QuranRecitationRecognitionGateway {
  final StreamController<QuranRecitationToken> _tokenController =
      StreamController<QuranRecitationToken>.broadcast();
  final StreamController<bool> _listeningController =
      StreamController<bool>.broadcast();

  bool _isListening = false;
  final bool _isHardwareAvailable;

  bool get isListening => _isListening;

  NativeSpeechRecognitionGateway({bool isHardwareAvailable = false})
      : _isHardwareAvailable = isHardwareAvailable;

  @override
  Stream<QuranRecitationToken> get tokenStream => _tokenController.stream;

  @override
  Stream<bool> get isListeningStream => _listeningController.stream;

  @override
  String get engineName => 'Native Speech Recognizer (Device Dependent)';

  @override
  Future<bool> isAvailable() async {
    // In production without certified local Arabic Quran ASR model,
    // we fail-closed honestly to prevent false religious assurances.
    return _isHardwareAvailable;
  }

  @override
  Future<void> startListening({String languageCode = 'ar-SA'}) async {
    final available = await isAvailable();
    if (!available) {
      throw StateError('محرك التعرف الصوتي غير متاح على هذا الجهاز حالياً.');
    }
    _isListening = true;
    _listeningController.add(true);
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    if (!_listeningController.isClosed) {
      _listeningController.add(false);
    }
  }

  @override
  void dispose() {
    _tokenController.close();
    _listeningController.close();
  }
}

/// Architecture stub for future dedicated SIRAJ remote recitation service (§6).
class RemoteRecitationRecognitionGateway implements QuranRecitationRecognitionGateway {
  final StreamController<QuranRecitationToken> _tokenController =
      StreamController<QuranRecitationToken>.broadcast();
  final StreamController<bool> _listeningController =
      StreamController<bool>.broadcast();

  @override
  Stream<QuranRecitationToken> get tokenStream => _tokenController.stream;

  @override
  Stream<bool> get isListeningStream => _listeningController.stream;

  @override
  String get engineName => 'SIRAJ Dedicated Recitation Backend (Future)';

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<void> startListening({String languageCode = 'ar-SA'}) async {
    throw UnsupportedError('الخدمة السحابية المتخصصة غير مفعلة في الإصدار الحالي.');
  }

  @override
  Future<void> stopListening() async {}

  @override
  void dispose() {
    _tokenController.close();
    _listeningController.close();
  }
}
