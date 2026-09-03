import '../domain/ai_intent.dart';

/// Classifies user queries into semantic intent categories and evaluates security risk level (§8, §9).
class IntentClassifier {
  const IntentClassifier();

  static const _stopWords = {
    'ما', 'هو', 'هي', 'هل', 'في', 'من', 'عن', 'على', 'إلى', 'اريد', 'أريد',
    'نص', 'معنى', 'فضل', 'كيف', 'متى', 'اين', 'أين', '؟', '!', '،', ',',
    'حكم', 'احكام', 'أحكام', 'مسألة', 'مساله', 'قول', 'بيان', 'شرح', 'كتاب'
  };

  AIIntent classify(String query) {
    // Strip zero-width and control characters (§45)
    final clean = query
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF\u202E\u202A-\u202D]'), '')
        .trim();
    final q = clean.toLowerCase();
    if (q.isEmpty) {
      return const AIIntent(
        category: IntentCategory.outOfScope,
        riskLevel: RiskLevel.low,
      );
    }

    final rawTokens = q
        .replaceAll(RegExp(r'[؟!?،,.]'), ' ')
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 2 && !_stopWords.contains(w))
        .toList();

    // 1. High-Risk / Forbidden: Takfir or Personal Judgment (§9)
    if (q.contains('كافر') ||
        q.contains('منافق') ||
        q.contains('مبتدع') ||
        q.contains('هل فلان في النار') ||
        q.contains('مرتد') ||
        q.contains('تكفير')) {
      return AIIntent(
        category: IntentCategory.takfirOrJudgment,
        riskLevel: RiskLevel.critical,
        extractedKeywords: rawTokens,
      );
    }

    // 2. High-Risk: Personal Fatwa & Worship Validity Requests (§10, §15, §19, §20)
    if (q.contains('هل صلاتي صحيحة') ||
        q.contains('هل صلاتي باطلة') ||
        q.contains('هل بطل صومي') ||
        q.contains('هل بطلت عمرتي') ||
        q.contains('هل حجي صحيح') ||
        q.contains('هل عمرتي صحيحة') ||
        q.contains('هل نسكي صحيح') ||
        q.contains('هل يجزئني') ||
        q.contains('هل تقبل توبتي') ||
        q.contains('هل أنا آثم') ||
        q.contains('هل علي ذنب') ||
        q.contains('نسيت الركوع') ||
        q.contains('نسيت التشهد')) {
      return AIIntent(
        category: IntentCategory.personalWorshipValidity,
        riskLevel: RiskLevel.high,
        extractedKeywords: rawTokens,
      );
    }

    if (q.contains('افتني') ||
        q.contains('أفتني') ||
        q.contains('أفتِ لي') ||
        q.contains('أفت لي') ||
        q.contains('صحة صيام') ||
        q.contains('صحة صلات') ||
        q.contains('ما حكمي') ||
        q.contains('هل يجب علي') ||
        q.contains('ماذا يلزمني شخصيا') ||
        q.contains('based on my situation')) {
      return AIIntent(
        category: IntentCategory.personalFatwa,
        riskLevel: RiskLevel.high,
        extractedKeywords: rawTokens,
      );
    }

    // 3. High-Risk: Medical + Religion (§17)
    if ((q.contains('حالتي الصحية') || q.contains('صحتي') || q.contains('مرض') || q.contains('مرضي') || q.contains('دواء') || q.contains('طبيب') || q.contains('علاج')) &&
        (q.contains('صوم') || q.contains('صيام') || q.contains('رمضان') || q.contains('حج') || q.contains('صلاة'))) {
      return AIIntent(
        category: IntentCategory.medicalReligious,
        riskLevel: RiskLevel.high,
        extractedKeywords: rawTokens,
      );
    }

    // 4. High-Risk: Complex Financial + Religion (§18)
    if ((q.contains('أسهم') || q.contains('محفظ') || q.contains('تداول') || q.contains('بيتكوين') || q.contains('كريبتو')) &&
        (q.contains('زكاة') || q.contains('تجب') || q.contains('حلال') || q.contains('حرام'))) {
      return AIIntent(
        category: IntentCategory.financialReligious,
        riskLevel: RiskLevel.high,
        extractedKeywords: rawTokens,
      );
    }

    // 5. High-Risk: Family, Inheritance, and Criminal Legal (§9)
    if (q.contains('طلاق') || q.contains('خلع') || q.contains('طالق') || q.contains('هل وقع طلاقي')) {
      return AIIntent(
        category: IntentCategory.marriageDivorce,
        riskLevel: RiskLevel.high,
        extractedKeywords: rawTokens,
      );
    }
    if (q.contains('ميراث') || q.contains('تركة') || q.contains('ورثة') || q.contains('تقسيم التركة')) {
      return AIIntent(
        category: IntentCategory.inheritance,
        riskLevel: RiskLevel.high,
        extractedKeywords: rawTokens,
      );
    }
    if (q.contains('جناية') || q.contains('سرقة') || q.contains('قتل') || q.contains('حد ')) {
      return AIIntent(
        category: IntentCategory.criminalLegal,
        riskLevel: RiskLevel.critical,
        extractedKeywords: rawTokens,
      );
    }

    // 6. Standard Categories: Quran Lookup
    if (q.contains('اية') || q.contains('آية') || q.contains('سورة') || q.contains('مصحف') || q.contains('قران') || q.contains('قرآن')) {
      return AIIntent(
        category: IntentCategory.quranLookup,
        riskLevel: RiskLevel.low,
        targetModuleId: 'quran',
        extractedKeywords: rawTokens,
      );
    }

    // 7. Hadith Lookup
    if (q.contains('حديث') || q.contains('رواية') || q.contains('سنة') || q.contains('صحيح البخاري') || q.contains('مسلم')) {
      return AIIntent(
        category: IntentCategory.hadithLookup,
        riskLevel: RiskLevel.low,
        targetModuleId: 'knowledge',
        extractedKeywords: rawTokens,
      );
    }

    // 8. Adhkar / Dua Lookup
    if (q.contains('ذكر') || q.contains('اذكار') || q.contains('أذكار') || q.contains('دعاء') || q.contains('استغفار')) {
      return AIIntent(
        category: IntentCategory.dhikrLookup,
        riskLevel: RiskLevel.low,
        targetModuleId: 'adhkar',
        extractedKeywords: rawTokens,
      );
    }

    // 9. Prayer & Timings
    if (q.contains('صلاة') || q.contains('قبلة') || q.contains('اذان') || q.contains('أذان') || q.contains('مواقيت')) {
      return AIIntent(
        category: IntentCategory.prayer,
        riskLevel: RiskLevel.low,
        targetModuleId: 'prayer',
        extractedKeywords: rawTokens,
      );
    }

    // 10. Fasting & Ramadan
    if (q.contains('صوم') || q.contains('صيام') || q.contains('رمضان') || q.contains('امساك') || q.contains('إفطار')) {
      return AIIntent(
        category: IntentCategory.fasting,
        riskLevel: RiskLevel.low,
        targetModuleId: 'fasting',
        extractedKeywords: rawTokens,
      );
    }

    // 11. Zakat
    if (q.contains('زكاة') || q.contains('نصاب') || q.contains('حول') || q.contains('صدقة الفطر')) {
      return AIIntent(
        category: IntentCategory.zakat,
        riskLevel: RiskLevel.low,
        targetModuleId: 'zakat',
        extractedKeywords: rawTokens,
      );
    }

    // 12. Hajj & Umrah
    if (q.contains('حج') || q.contains('عمرة') || q.contains('طواف') || q.contains('سعي') || q.contains('احرام') || q.contains('ميقات')) {
      return AIIntent(
        category: IntentCategory.hajjUmrah,
        riskLevel: RiskLevel.low,
        targetModuleId: 'hajj',
        extractedKeywords: rawTokens,
      );
    }

    // 13. Seerah & History
    if (q.contains('سيرة') || q.contains('غزوة') || q.contains('هجرة') || q.contains('صحابي') || q.contains('النبي')) {
      return AIIntent(
        category: IntentCategory.seerah,
        riskLevel: RiskLevel.low,
        targetModuleId: 'seerah',
        extractedKeywords: rawTokens,
      );
    }

    // 14. Learning / Modules
    if (q.contains('منهاج') || q.contains('مسار') || q.contains('درس') || q.contains('اختبار')) {
      return AIIntent(
        category: IntentCategory.learning,
        riskLevel: RiskLevel.low,
        targetModuleId: 'learning',
        extractedKeywords: rawTokens,
      );
    }

    // Default: General Knowledge
    return AIIntent(
      category: IntentCategory.generalIslamicKnowledge,
      riskLevel: RiskLevel.low,
      extractedKeywords: rawTokens,
    );
  }
}
