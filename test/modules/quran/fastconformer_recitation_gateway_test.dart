import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_word.dart';
import 'package:siraj/modules/quran/recitation/services/fastconformer_recitation_gateway.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_matcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FastConformer Quran ASR Gateway Tests (Muno459/fastconformer-quran)', () {
    test('Gateway reports correct engine name and availability in local simulation', () async {
      final gateway = FastConformerQuranRecognitionGateway(simulateLocal: true);

      expect(gateway.engineName, contains('FastConformer-Quran On-Device'));
      expect(gateway.engineName, contains('محلياً'));

      final available = await gateway.isAvailable();
      expect(available, isTrue);

      final remoteGateway = FastConformerQuranRecognitionGateway(
        isLocalMode: false,
        simulateLocal: true,
      );
      expect(remoteGateway.engineName, contains('FastConformer Quran ASR'));
      expect(remoteGateway.engineName, contains('Muno459/fastconformer-quran'));

      gateway.dispose();
      remoteGateway.dispose();
    });

    test('Listening state stream toggles correctly on start/stop', () async {
      final gateway = FastConformerQuranRecognitionGateway(simulateLocal: true);
      final states = <bool>[];

      final sub = gateway.isListeningStream.listen(states.add);

      expect(gateway.isListening, isFalse);

      await gateway.startListening();
      expect(gateway.isListening, isTrue);

      await gateway.stopListening();
      expect(gateway.isListening, isFalse);

      await sub.cancel();
      gateway.dispose();

      expect(states, [true, false]);
    });

    test('emitRecognizedWords splits Arabic text and emits valid QuranRecitationTokens', () async {
      final gateway = FastConformerQuranRecognitionGateway(simulateLocal: true);
      final tokens = <QuranRecitationToken>[];

      final sub = gateway.tokenStream.listen(tokens.add);

      await gateway.startListening();

      gateway.emitRecognizedWords('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ');

      await Future.delayed(const Duration(milliseconds: 10));

      expect(tokens.length, 4);
      expect(tokens[0].rawText, 'الْحَمْدُ');
      expect(tokens[1].rawText, 'لِلَّهِ');
      expect(tokens[2].rawText, 'رَبِّ');
      expect(tokens[3].rawText, 'الْعَالَمِينَ');
      expect(tokens.every((t) => t.confidence >= 0.90), isTrue);

      await sub.cancel();
      gateway.dispose();
    });

    test('FastConformer emitted tokens match canonical Ayah words using QuranRecitationMatcher', () async {
      final gateway = FastConformerQuranRecognitionGateway(simulateLocal: true);
      final testAyah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 2,
        textUthmani: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ',
        textSimple: 'الحمد لله رب العالمين',
        juzNumber: 1,
        pageNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(testAyah);
      expect(words.length, 4);

      final tokens = <QuranRecitationToken>[];
      final sub = gateway.tokenStream.listen(tokens.add);

      await gateway.startListening();

      // Emit recognized tokens from FastConformer ASR
      gateway.emitToken('الحمد');
      gateway.emitToken('لله');
      gateway.emitToken('رب');
      gateway.emitToken('العالمين');

      await Future.delayed(const Duration(milliseconds: 10));

      // Match each token against the canonical words
      for (int i = 0; i < words.length; i++) {
        final similarity = QuranRecitationMatcher.calculateSimilarity(
          words[i].normalizedText,
          tokens[i].normalizedText,
        );
        expect(similarity, greaterThanOrEqualTo(0.85));

        words[i] = words[i].copyWith(
          state: RecitationWordState.recognized,
          confidence: similarity,
          confidenceLevel: RecitationWordConfidence.confirmed,
        );
      }

      expect(words.every((w) => w.isVisible), isTrue);
      expect(words.every((w) => w.state == RecitationWordState.recognized), isTrue);

      await sub.cancel();
      gateway.dispose();
    });

    test('Non-existent audio file returns null fail-soft without error', () async {
      final gateway = FastConformerQuranRecognitionGateway(simulateLocal: false);
      await gateway.startListening();

      final res = await gateway.transcribeAudioFile('non_existent_audio.m4a');
      expect(res, isNull);

      gateway.dispose();
    });

    test('evaluateWordMatch detects mistakes on completely different words and accepts legitimate variations', () {
      // 1. Legitimate matches
      final m1 = QuranRecitationMatcher.evaluateWordMatch(
        QuranRecitationMatcher.normalizeForRecognition('ٱلْحَمْدُ'),
        QuranRecitationMatcher.normalizeForRecognition('الحمد'),
      );
      expect(m1.isMatch, isTrue);
      expect(m1.isMistake, isFalse);

      final m2 = QuranRecitationMatcher.evaluateWordMatch(
        QuranRecitationMatcher.normalizeForRecognition('مَـٰلِكِ'),
        QuranRecitationMatcher.normalizeForRecognition('ملك'),
      );
      expect(m2.isMatch, isTrue);
      expect(m2.isMistake, isFalse);

      // 2. Completely different short words (root consonant change) -> detected as mistakes!
      final err1 = QuranRecitationMatcher.evaluateWordMatch(
        QuranRecitationMatcher.normalizeForRecognition('يَوْمِ'),
        QuranRecitationMatcher.normalizeForRecognition('قوم'),
      );
      expect(err1.isMatch, isFalse);
      expect(err1.isMistake, isTrue);

      final err2 = QuranRecitationMatcher.evaluateWordMatch(
        QuranRecitationMatcher.normalizeForRecognition('نَعْبُدُ'),
        QuranRecitationMatcher.normalizeForRecognition('نفسد'),
      );
      expect(err2.isMatch, isFalse);
      expect(err2.isMistake, isTrue);

      final err3 = QuranRecitationMatcher.evaluateWordMatch(
        QuranRecitationMatcher.normalizeForRecognition('ٱلرَّحْمَـٰنِ'),
        QuranRecitationMatcher.normalizeForRecognition('العليم'),
      );
      expect(err3.isMatch, isFalse);
      expect(err3.isMistake, isTrue);
    });
  });
}
