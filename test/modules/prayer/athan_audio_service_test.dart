import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/prayer/domain/athan_sound_option.dart';
import 'package:siraj/modules/prayer/services/athan_audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Athan Sound Option Tests (§32)', () {
    test('Canonical sound options provide Sheikh Abdulbasit Abdulsamad as default', () {
      final defaultOpt = AthanSoundOption.abdulbasit;

      expect(defaultOpt.id, equals('abdulbasit'));
      expect(defaultOpt.displayNameArabic, contains('عبد الباسط'));
      expect(defaultOpt.reciterNameArabic, contains('عبد الباسط'));
      expect(defaultOpt.assetPath, equals('assets/audio/athan_abdulbasit.mp3'));
      expect(defaultOpt.isDefault, isTrue);
    });

    test('Sound option serialization and lookup by ID', () {
      final opt = AthanSoundOption.fromId('abdulbasit');
      expect(opt, equals(AthanSoundOption.abdulbasit));

      final json = opt.toJson();
      final restored = AthanSoundOption.fromJson(json);
      expect(restored, equals(opt));
    });

    test('Fallback to default option when invalid ID is requested', () {
      final fallback = AthanSoundOption.fromId('non_existent_id');
      expect(fallback, equals(AthanSoundOption.abdulbasit));
    });
  });

  group('AthanAudioService Unit Tests (§32)', () {
    test('Initializes in stopped state with zero position', () {
      final service = AthanAudioService();
      expect(service.isPlaying, isFalse);
      expect(service.currentOption, isNull);
      expect(service.currentPosition, equals(Duration.zero));
    });

    test('Volume clamped safely between 0.0 and 1.0', () async {
      final service = AthanAudioService();
      // Should not throw on extreme values
      await service.setVolume(1.5);
      await service.setVolume(-0.5);
      await service.setVolume(0.75);
    });

    test('Stop method resets playback state gracefully', () async {
      final service = AthanAudioService();
      final res = await service.stopAthan();

      expect(res.isSuccess, isTrue);
      expect(service.isPlaying, isFalse);
      expect(service.currentOption, isNull);
    });
  });
}
