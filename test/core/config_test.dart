import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/config/app_config.dart';
import 'package:siraj/core/config/feature_flags.dart';

void main() {
  group('L0 AppConfig & FeatureFlags Tests', () {
    test('Default foundation feature flags keep unbuilt modules disabled', () {
      const flags = FeatureFlags.foundationDefaults;

      expect(flags.enablePrayerModule, isFalse);
      expect(flags.enableQuranModule, isFalse);
      expect(flags.enableAdhkarModule, isFalse);
      expect(flags.enableZakatModule, isFalse);
      expect(flags.enableAiCompanion, isFalse);
      expect(flags.enableAnalytics, isFalse);
      expect(flags.enableOfflineSync, isFalse);
    });

    test('AppConfig development factory creates proper environment', () {
      final config = AppConfig.development();

      expect(config.environment, equals(Environment.development));
      expect(config.defaultLocale, equals('ar'));
      expect(config.failClosedOnContentError, isTrue);
    });

    test('FeatureFlags copyWith updates specific flags without mutating others', () {
      const flags = FeatureFlags.foundationDefaults;
      final updated = flags.copyWith(enablePrayerModule: true);

      expect(updated.enablePrayerModule, isTrue);
      expect(updated.enableQuranModule, isFalse);
    });
  });
}
