import '../domain/ai_intent.dart';
import '../domain/evidence_item.dart';

/// Result of evaluating abstention policies (§44, §45).
class AbstentionEvaluation {
  final bool shouldAbstain;
  final String? reasonArabic;
  final String? referralArabic;

  const AbstentionEvaluation({
    required this.shouldAbstain,
    this.reasonArabic,
    this.referralArabic,
  });

  static const AbstentionEvaluation noAbstention =
      AbstentionEvaluation(shouldAbstain: false);
}

/// Evaluates when SIRAJ must abstain from answering and refer to scholarly authorities (§44, §45, §49).
class AbstentionEngine {
  const AbstentionEngine();

  AbstentionEvaluation evaluate({
    required AIIntent intent,
    required List<EvidenceItem> validatedEvidence,
    required String originalQuery,
  }) {
    final q = originalQuery.toLowerCase();

    // 1. Check for Intentional Hallucination / Invention Demands (§8, §21, §62)
    if (q.contains('اخترع لي') ||
        q.contains('الف لي') ||
        q.contains('ألف لي') ||
        q.contains('من عندك دون مصدر') ||
        q.contains('حتى لو اضطررت لاختراعه') ||
        q.contains('invent') ||
        q.contains('don\'t cite anything') ||
        q.contains('دون استشهاد')) {
      return const AbstentionEvaluation(
        shouldAbstain: true,
        reasonArabic:
            'يمتنع سِراج تماماً عن اختلاق أو توليد نصوص دينية أو أحاديث أو مصادر غير موثقة.',
      );
    }

    // 2. High-Risk: Takfir and Sectarian Classification (§9)
    if (intent.category == IntentCategory.takfirOrJudgment) {
      return const AbstentionEvaluation(
        shouldAbstain: true,
        reasonArabic:
            'يمتنع سِراج قطعياً عن الخوض في تكفير المعينين أو تصنيف الأشخاص والنيات.',
      );
    }

    // 3. High-Risk: Personal Fatwa & Worship Validity Ruling (§10, §15, §16, §19, §20)
    if (intent.category == IntentCategory.personalFatwa ||
        intent.category == IntentCategory.personalWorshipValidity) {
      return const AbstentionEvaluation(
        shouldAbstain: true,
        reasonArabic:
            'سِراج منصة توثيقية للأدلة والمعارف الإسلامية وليست هيئة إفتاء تصدر أحكاماً على الحالات الشخصية أو تقطع بصحة وبطلان عبادة معينة.',
        referralArabic:
            'يُرجى توجيه المسائل والوقائع الشخصية الخاصة إلى الهيئات الإفتائية المعتمدة والعلماء الثقات.',
      );
    }

    // 4. High-Risk: Medical + Religious Questions (§17)
    if (intent.category == IntentCategory.medicalReligious) {
      return const AbstentionEvaluation(
        shouldAbstain: true,
        reasonArabic:
            'المسائل الطبية-الشرعية التي تتعلق بالقدرة الصحية على الصيام أو أداء النسك تتطلب تشخيصاً طبياً مباشراً مع الرجوع لأهل العلم المختصين.',
        referralArabic:
            'يُرجى استشارة الطبيب المعالج والرجوع للجان الفتوى الرسمية.',
      );
    }

    // 5. High-Risk: Complex Financial + Religious Questions (§18)
    if (intent.category == IntentCategory.financialReligious) {
      return const AbstentionEvaluation(
        shouldAbstain: true,
        reasonArabic:
            'المعاملات المالية المعقدة وحسابات المحافظ والأسهم تتطلب تدقيقاً مالياً وشرعياً متخصصاً لا يملكه التطبيق بشكل فردي.',
        referralArabic:
            'يُرجى مراجعة مستشار مالي شرعي معتمد أو الهيئات الفقهية المتخصصة.',
      );
    }

    // 6. High-Risk: Complex Legal / Criminal / Family Questions (§9)
    if (intent.category == IntentCategory.criminalLegal ||
        intent.category == IntentCategory.marriageDivorce ||
        intent.category == IntentCategory.inheritance) {
      return const AbstentionEvaluation(
        shouldAbstain: true,
        reasonArabic:
            'المسائل القضائية والأسرية وقسمة التركات تتطلب فحصاً قضائياً وشرعياً متخصصاً لا يملكه التطبيق.',
        referralArabic:
            'يُرجى مراجعة المحاكم الشرعية أو اللجان الإفتائية الرسمية.',
      );
    }

    // 7. Insufficient Evidence (§1, §44)
    if (validatedEvidence.isEmpty) {
      return const AbstentionEvaluation(
        shouldAbstain: true,
        reasonArabic:
            'لا تتوفر في المصادر والحزم المعتمدة داخل سِراج أدلة كافية وموثقة للإجابة بدقة على هذه المسألة.',
        referralArabic:
            'يمكنك البحث في كتب الحديث والفقه المعتمدة أو الرجوع لأهل العلم المختصين.',
      );
    }

    return AbstentionEvaluation.noAbstention;
  }
}
