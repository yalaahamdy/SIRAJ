import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/recitation/domain/recitation_playback_policy.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';

void main() {
  group('M02.2 Quran Recitation & Playback Settings Tests (§15, §16)', () {
    test('Defaults are initialized safely for recitation and playback policies', () {
      const config = QuranTypographyConfig();

      expect(config.playbackSpeed, equals(1.0));
      expect(config.repeatCount, equals(1));
      expect(config.repeatPolicy, equals(PlaybackRepeatPolicy.none));
      expect(config.delayBetweenAyahsSeconds, equals(0));
      expect(config.defaultRecitationMode, equals(RecitationMode.recordAndReplay));
      expect(config.hideTextDuringRecitation, isTrue);
      expect(config.autoAdvanceRecitation, isTrue);
    });

    test('copyWith updates recitation and playback properties without side-effects', () {
      const initial = QuranTypographyConfig();

      final updated = initial.copyWith(
        playbackSpeed: 1.25,
        repeatPolicy: PlaybackRepeatPolicy.range,
        repeatCount: 5,
        delayBetweenAyahsSeconds: 2,
        defaultRecitationMode: RecitationMode.recognition,
        hideTextDuringRecitation: false,
      );

      expect(updated.playbackSpeed, equals(1.25));
      expect(updated.repeatPolicy, equals(PlaybackRepeatPolicy.range));
      expect(updated.repeatCount, equals(5));
      expect(updated.delayBetweenAyahsSeconds, equals(2));
      expect(updated.defaultRecitationMode, equals(RecitationMode.recognition));
      expect(updated.hideTextDuringRecitation, isFalse);

      // Verify original config is immutable
      expect(initial.playbackSpeed, equals(1.0));
      expect(initial.repeatPolicy, equals(PlaybackRepeatPolicy.none));
    });

    test('Serializes to JSON and deserializes back faithfully', () {
      const config = QuranTypographyConfig(
        playbackSpeed: 0.75,
        repeatPolicy: PlaybackRepeatPolicy.ayah,
        repeatCount: 3,
        delayBetweenAyahsSeconds: 1,
        defaultRecitationMode: RecitationMode.recordAndReplay,
        hideTextDuringRecitation: true,
        autoAdvanceRecitation: true,
      );

      final json = config.toJson();

      expect(json['playbackSpeed'], equals(0.75));
      expect(json['repeatPolicy'], equals('ayah'));
      expect(json['repeatCount'], equals(3));
      expect(json['delayBetweenAyahsSeconds'], equals(1));
      expect(json['defaultRecitationMode'], equals('recordAndReplay'));
      expect(json['hideTextDuringRecitation'], isTrue);

      final restored = QuranTypographyConfig.fromJson(json);

      expect(restored.playbackSpeed, equals(0.75));
      expect(restored.repeatPolicy, equals(PlaybackRepeatPolicy.ayah));
      expect(restored.repeatCount, equals(3));
      expect(restored.delayBetweenAyahsSeconds, equals(1));
      expect(restored.defaultRecitationMode, equals(RecitationMode.recordAndReplay));
      expect(restored.hideTextDuringRecitation, isTrue);
      expect(restored.autoAdvanceRecitation, isTrue);
    });

    test('Safely falls back to sensible defaults when parsing legacy JSON', () {
      final legacyJson = {
        'fontFamily': 'amiri',
        'fontSize': 26.0,
      };

      final restored = QuranTypographyConfig.fromJson(legacyJson);

      expect(restored.playbackSpeed, equals(1.0));
      expect(restored.repeatPolicy, equals(PlaybackRepeatPolicy.none));
      expect(restored.repeatCount, equals(1));
      expect(restored.defaultRecitationMode, equals(RecitationMode.recordAndReplay));
      expect(restored.hideTextDuringRecitation, isTrue);
    });
  });
}
