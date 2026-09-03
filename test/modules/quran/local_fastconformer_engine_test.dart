import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_word.dart';
import 'package:siraj/modules/quran/recitation/services/local_fastconformer_engine.dart';
import 'package:siraj/modules/quran/recitation/services/fastconformer_recitation_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late LocalFastConformerEngine engine;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('siraj_local_fc_test_');
    engine = LocalFastConformerEngine(customModelDirectory: tempDir);
  });

  tearDown(() {
    engine.dispose();
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  group('LocalFastConformerEngine On-Device Tests (Muno459/fastconformer-quran)', () {
    test('Initializes successfully with embedded local on-device engine ready', () async {
      await engine.initialize();
      expect(engine.isReady, isTrue);
      expect(
        engine.status == LocalModelStatus.ready ||
            engine.status == LocalModelStatus.embeddedLocalReady,
        isTrue,
      );
    });

    test('Reports accurate model configuration metadata', () {
      final cfg = engine.config;
      expect(cfg.modelName, contains('FastConformer-Quran'));
      expect(cfg.huggingFaceId, equals('Muno459/fastconformer-quran'));
      expect(cfg.architecture, contains('FastConformer'));
      expect(cfg.sampleRate, equals(16000));
      expect(cfg.melBands, equals(80));
    });

    test('Transcribes simulated audio bytes on-device without internet', () async {
      final audioBytes = Uint8List.fromList(List.generate(1600, (i) => (i % 256)));
      final result = await engine.transcribeBytes(audioBytes);
      expect(result, isNotNull);
    });

    test('Emits discrete QuranRecitationTokens through streaming broadcast', () async {
      final tokens = <QuranRecitationToken>[];
      final sub = engine.tokenStream.listen(tokens.add);

      engine.emitRecognizedWords('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ');

      await Future.delayed(const Duration(milliseconds: 15));

      expect(tokens.length, equals(4));
      expect(tokens[0].rawText, equals('الْحَمْدُ'));
      expect(tokens[1].rawText, equals('لِلَّهِ'));
      expect(tokens[2].rawText, equals('رَبِّ'));
      expect(tokens[3].rawText, equals('الْعَالَمِينَ'));
      expect(tokens.every((t) => t.confidence >= 0.90), isTrue);

      await sub.cancel();
    });

    test('Imports external ONNX model file into local model directory', () async {
      final dummyOnnx = File('${tempDir.path}/external_model.onnx');
      await dummyOnnx.writeAsBytes(List.filled(2048, 42));

      final imported = await engine.importModelFile(dummyOnnx);
      expect(imported, isTrue);
      expect(engine.status, equals(LocalModelStatus.ready));
      expect(engine.activeModelPath, isNotNull);
      expect(File(engine.activeModelPath!).existsSync(), isTrue);
    });

    test('Gateway with LocalFastConformerEngine runs 100% on-device', () async {
      final gateway = FastConformerQuranRecognitionGateway(
        localEngine: engine,
        isLocalMode: true,
      );

      expect(gateway.engineName, contains('On-Device'));
      expect(gateway.engineName, contains('محلياً'));
      expect(await gateway.isAvailable(), isTrue);

      final tokens = <QuranRecitationToken>[];
      final sub = gateway.tokenStream.listen(tokens.add);

      await gateway.startListening();
      gateway.emitToken('الرحمن');

      await Future.delayed(const Duration(milliseconds: 10));

      expect(tokens.length, equals(1));
      expect(tokens[0].rawText, equals('الرحمن'));

      await sub.cancel();
      gateway.dispose();
    });
  });
}
