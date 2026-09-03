import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/ops/blueprint/models/v1_blueprint_manifest.dart';
import 'package:siraj/services/bot/ops/blueprint/services/v1_blueprint_validator.dart';

void main() {
  group('M25 V1 Blueprint Adversarial & Validation Suite (§28, §37, §69, §70)', () {
    const validator = V1BlueprintValidator();

    test('Blueprint 1: Standard approved V1 Blueprint passes all governance and architectural checks', () {
      final manifest = V1BlueprintManifest.standardV1();
      final result = validator.validateBlueprint(manifest);

      expect(result.isValid, isTrue);
      expect(result.violationsArabic, isEmpty);
      expect(manifest.mustShipCapabilities.length, equals(12));
      expect(manifest.goldenJourneys.length, equals(10));
      expect(manifest.coreEpics.length, equals(11));
    });

    test('Adversarial 1: Attempting to embed Mobile AI Runtime in blueprint triggers instant rejection', () {
      final invalidManifest = V1BlueprintManifest(
        version: '1.0.0',
        mustShipCapabilities: const ['Prayer'],
        excludedCapabilities: const [],
        goldenJourneys: List.generate(10, (i) => 'Journey $i'),
        coreEpics: const ['EPIC 1'],
        backlogItems: const [],
        hasMobileAiRuntime: true, // Violation
        hasPietyScoring: false,
        finalizedAt: DateTime.now(),
      );

      final result = validator.validateBlueprint(invalidManifest);
      expect(result.isValid, isFalse);
      expect(result.violationsArabic.any((v) => v.contains('محركات الذكاء الاصطناعي داخل تطبيق الهاتف')), isTrue);
    });

    test('Adversarial 2: Attempting to introduce Piety/Faith scoring triggers instant rejection', () {
      final invalidManifest = V1BlueprintManifest(
        version: '1.0.0',
        mustShipCapabilities: const ['Prayer'],
        excludedCapabilities: const [],
        goldenJourneys: List.generate(10, (i) => 'Journey $i'),
        coreEpics: const ['EPIC 1'],
        backlogItems: const [],
        hasMobileAiRuntime: false,
        hasPietyScoring: true, // Violation
        finalizedAt: DateTime.now(),
      );

      final result = validator.validateBlueprint(invalidManifest);
      expect(result.isValid, isFalse);
      expect(result.violationsArabic.any((v) => v.contains('تقييمات لمستوى تدين المستخدم')), isTrue);
    });
  });
}
