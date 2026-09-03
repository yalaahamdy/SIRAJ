import '../models/v1_blueprint_manifest.dart';

/// Result of evaluating V1 Blueprint Readiness (§69, §72).
class BlueprintValidationResult {
  final bool isValid;
  final List<String> violationsArabic;

  const BlueprintValidationResult({
    required this.isValid,
    this.violationsArabic = const [],
  });

  static const BlueprintValidationResult valid = BlueprintValidationResult(isValid: true);
}

/// Validator ensuring V1 Blueprint adheres strictly to governance rules and acyclic architecture (§28, §37, §46, §69).
class V1BlueprintValidator {
  const V1BlueprintValidator();

  /// Validates a blueprint manifest against core constraints (§28, §37, §46).
  BlueprintValidationResult validateBlueprint(V1BlueprintManifest manifest) {
    final violations = <String>[];

    // 1. Check Mobile AI Runtime constraint (§28)
    if (manifest.hasMobileAiRuntime) {
      violations.add('انتهاك معماري: يمنع منعاً باتاً تشغيل محركات الذكاء الاصطناعي داخل تطبيق الهاتف.');
    }

    // 2. Check Piety Scoring constraint (§37)
    if (manifest.hasPietyScoring) {
      violations.add('انتهاك شرعي وحوكمي: يمنع منعاً باتاً وضع أي درجات أو تقييمات لمستوى تدين المستخدم.');
    }

    // 3. Check Minimum Golden Journeys (§8, §64)
    if (manifest.goldenJourneys.length < 10) {
      violations.add('قصور في المخطط: يجب تحديد المسارات الذهبية الـ 10 الحاكمة للإصدار الأول.');
    }

    // 4. Check Core Epics Coverage (§45)
    if (manifest.coreEpics.isEmpty) {
      violations.add('قصور في المخطط: لا توجد ملاحم برمجية محددة.');
    }

    if (violations.isNotEmpty) {
      return BlueprintValidationResult(
        isValid: false,
        violationsArabic: violations,
      );
    }

    return BlueprintValidationResult.valid;
  }
}
