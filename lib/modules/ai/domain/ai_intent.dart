import 'package:equatable/equatable.dart';

/// Categories of Islamic knowledge and application queries (§8, §9).
enum IntentCategory {
  quranLookup,
  hadithLookup,
  dhikrLookup,
  fiqhInformation,
  learning,
  seerah,
  hajjUmrah,
  prayer,
  zakat,
  fasting,
  generalIslamicKnowledge,
  appHelp,
  // High-Risk Intents (§9)
  personalFatwa,
  personalWorshipValidity,
  medicalReligious,
  financialReligious,
  marriageDivorce,
  inheritance,
  criminalLegal,
  takfirOrJudgment,
  outOfScope;

  String get labelArabic {
    switch (this) {
      case IntentCategory.quranLookup:
        return 'بحث قرآني';
      case IntentCategory.hadithLookup:
        return 'بحث في الحديث الشريف';
      case IntentCategory.dhikrLookup:
        return 'بحث في الأذكار والأدعية';
      case IntentCategory.fiqhInformation:
        return 'معلومات فقهية توثيقية';
      case IntentCategory.learning:
        return 'مناهج ومسارات تعليمية';
      case IntentCategory.seerah:
        return 'السيرة النبوية والتاريخ';
      case IntentCategory.hajjUmrah:
        return 'مناسك الحج والعمرة';
      case IntentCategory.prayer:
        return 'مواقيت الصلاة والقبلة';
      case IntentCategory.zakat:
        return 'حساب الزكاة';
      case IntentCategory.fasting:
        return 'الصيام وقضاء رمضان';
      case IntentCategory.generalIslamicKnowledge:
        return 'معرفة إسلامية عامة';
      case IntentCategory.appHelp:
        return 'مساعدة في استخدام التطبيق';
      case IntentCategory.personalFatwa:
        return 'طلب فتوى شخصية (عالي الخطورة)';
      case IntentCategory.personalWorshipValidity:
        return 'حكم بصحة عبادة شخصية (عالي الخطورة)';
      case IntentCategory.medicalReligious:
        return 'مسألة طبية-شرعية (عالي الخطورة)';
      case IntentCategory.financialReligious:
        return 'معاملة مالية خاصة (عالي الخطورة)';
      case IntentCategory.marriageDivorce:
        return 'قضايا نكاح وطلاق (عالي الخطورة)';
      case IntentCategory.inheritance:
        return 'قسمة مواريث (عالي الخطورة)';
      case IntentCategory.criminalLegal:
        return 'قضايا جنائية وقضائية (عالي الخطورة)';
      case IntentCategory.takfirOrJudgment:
        return 'تكفير وتصنيف أشخاص (محظور)';
      case IntentCategory.outOfScope:
        return 'خارج نطاق المنظومة الموثقة';
    }
  }

  bool get isHighRisk =>
      this == IntentCategory.personalFatwa ||
      this == IntentCategory.personalWorshipValidity ||
      this == IntentCategory.medicalReligious ||
      this == IntentCategory.financialReligious ||
      this == IntentCategory.marriageDivorce ||
      this == IntentCategory.inheritance ||
      this == IntentCategory.criminalLegal ||
      this == IntentCategory.takfirOrJudgment;
}

/// Risk level assigned to a classified intent.
enum RiskLevel {
  low,
  medium,
  high,
  critical;

  String get labelArabic {
    switch (this) {
      case RiskLevel.low:
        return 'منخفض';
      case RiskLevel.medium:
        return 'متوسط';
      case RiskLevel.high:
        return 'عالي الخطورة';
      case RiskLevel.critical:
        return 'حرج / محظور';
    }
  }
}

/// Classified Intent for an incoming user query (§8, §9).
class AIIntent extends Equatable {
  final IntentCategory category;
  final RiskLevel riskLevel;
  final double confidence;
  final String? targetModuleId;
  final List<String> extractedKeywords;

  const AIIntent({
    required this.category,
    required this.riskLevel,
    this.confidence = 1.0,
    this.targetModuleId,
    this.extractedKeywords = const [],
  });

  bool get requiresAbstention =>
      category == IntentCategory.personalFatwa ||
      category == IntentCategory.personalWorshipValidity ||
      category == IntentCategory.takfirOrJudgment ||
      category == IntentCategory.criminalLegal;

  @override
  List<Object?> get props => [
        category,
        riskLevel,
        confidence,
        targetModuleId,
        extractedKeywords,
      ];
}
