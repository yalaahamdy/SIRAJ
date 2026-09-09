import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/audio/siraj_audio_boost_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SirajAudioBoostService Test Suite (§14, §20, §32)', () {
    late SirajAudioBoostService boostService;

    setUp(() {
      boostService = SirajAudioBoostService();
    });

    test('Initializes with default 100% boost (1.0) and not boosted', () {
      expect(boostService.boostLevel, equals(1.0));
      expect(boostService.isBoosted, isFalse);
      expect(boostService.gainMilliBels, equals(0));
      expect(boostService.presetLevels, equals([1.0, 1.25, 1.5, 1.75, 2.0]));
    });

    test('Sets boost level and notifies listeners', () async {
      int notifyCount = 0;
      boostService.addListener(() => notifyCount++);

      await boostService.setBoostLevel(1.5);
      expect(boostService.boostLevel, equals(1.5));
      expect(boostService.isBoosted, isTrue);
      expect(boostService.gainMilliBels, equals(800)); // (1.5 - 1.0) * 1600 = 800 mB
      expect(notifyCount, equals(1));
    });

    test('Clamps boost levels to valid bounds [1.0, 2.0]', () async {
      await boostService.setBoostLevel(0.5);
      expect(boostService.boostLevel, equals(1.0));
      expect(boostService.isBoosted, isFalse);

      await boostService.setBoostLevel(2.5);
      expect(boostService.boostLevel, equals(2.0));
      expect(boostService.isBoosted, isTrue);
      expect(boostService.gainMilliBels, equals(1600));
    });

    test('Cycles cleanly through preset levels (100% -> 125% -> 150% -> 175% -> 200% -> 100%)', () async {
      expect(boostService.boostLevel, equals(1.0));

      await boostService.cycleNext();
      expect(boostService.boostLevel, equals(1.25));

      await boostService.cycleNext();
      expect(boostService.boostLevel, equals(1.5));

      await boostService.cycleNext();
      expect(boostService.boostLevel, equals(1.75));

      await boostService.cycleNext();
      expect(boostService.boostLevel, equals(2.0));

      await boostService.cycleNext();
      expect(boostService.boostLevel, equals(1.0));
      expect(boostService.isBoosted, isFalse);
    });

    test('Resets boost level back to 100%', () async {
      await boostService.setBoostLevel(1.75);
      expect(boostService.isBoosted, isTrue);

      await boostService.reset();
      expect(boostService.boostLevel, equals(1.0));
      expect(boostService.isBoosted, isFalse);
    });

    test('Initializes with de-noise enabled and toggles cleanly', () async {
      expect(boostService.isDeNoiseEnabled, isTrue);

      int notifyCount = 0;
      boostService.addListener(() => notifyCount++);

      await boostService.setDeNoise(false);
      expect(boostService.isDeNoiseEnabled, isFalse);
      expect(notifyCount, equals(1));

      await boostService.toggleDeNoise();
      expect(boostService.isDeNoiseEnabled, isTrue);
      expect(notifyCount, equals(2));
    });
  });
}
