import 'package:equatable/equatable.dart';
import 'v1_feature_backlog_item.dart';

/// Structured V1 Blueprint Manifest uniting Scope, Epics, Golden Journeys, and Sprint 0 (§0, §5, §8, §45, §48).
class V1BlueprintManifest extends Equatable {
  final String version;
  final List<String> mustShipCapabilities;
  final List<String> excludedCapabilities;
  final List<String> goldenJourneys;
  final List<String> coreEpics;
  final List<V1FeatureBacklogItem> backlogItems;
  final bool hasMobileAiRuntime;
  final bool hasPietyScoring;
  final DateTime finalizedAt;

  const V1BlueprintManifest({
    required this.version,
    required this.mustShipCapabilities,
    required this.excludedCapabilities,
    required this.goldenJourneys,
    required this.coreEpics,
    required this.backlogItems,
    this.hasMobileAiRuntime = false,
    this.hasPietyScoring = false,
    required this.finalizedAt,
  });

  /// Factory creating standard approved SIRAJ v1.0 Blueprint Manifest (§0, §5, §8).
  factory V1BlueprintManifest.standardV1() {
    return V1BlueprintManifest(
      version: '1.0.0',
      mustShipCapabilities: const [
        'Prayer Times & Qibla Engine',
        'Uthmani Hafs Quran Reader',
        'Spaced Repetition Memorization',
        'Canonical Adhkar & Interactive Counter',
        'Comparative Fiqh & Hadith Explorer',
        'Islamic Learning Paths',
        'Seerah Chronological Timeline',
        'Hajj & Umrah Interactive Guide',
        'Zakat Calculator & Fasting Tracker',
        'Home Command Center & 5-Tab Navigation',
        'Federated Search Platform',
        'External Telegram Bot & Verified AI Retrieval',
      ],
      excludedCapabilities: const [
        'Mobile AI Runtime (Strictly Excluded)',
        'Piety & Faith Scoring (Strictly Excluded)',
        'Social Networking & Public Feeds (Strictly Excluded)',
        'Direct Production Content Modification (Strictly Excluded)',
      ],
      goldenJourneys: const [
        'Journey 1: Fast Onboarding & Location Setup',
        'Journey 2: Morning Routine & Adhkar',
        'Journey 3: Prayer Tracking & Qibla Direction',
        'Journey 4: Quran Reading in Uthmani Text',
        'Journey 5: Memorization Spaced Review Session',
        'Journey 6: Post-Prayer Adhkar with Counter',
        'Journey 7: Islamic Learning Path Progress',
        'Journey 8: Fasting & Zakat Calculation',
        'Journey 9: Federated Knowledge Search',
        'Journey 10: Bot Islamic Query & Verified Evidence',
      ],
      coreEpics: const [
        'EPIC 1: Foundation & Design System',
        'EPIC 2: Home Command Center & Navigation',
        'EPIC 3: Prayer Times & Qibla',
        'EPIC 4: Quran Core Reader',
        'EPIC 5: Memorization Spaced Repetition',
        'EPIC 6: Adhkar & Interactive Counter',
        'EPIC 7: Knowledge, Fiqh & Learning',
        'EPIC 8: Fasting & Zakat Tracker',
        'EPIC 9: Federated Search Engine',
        'EPIC 10: External Bot Platform & AI Retrieval',
        'EPIC 11: Release QA & Human Acceptance',
      ],
      backlogItems: const [
        V1FeatureBacklogItem(
          itemId: 'FEAT-001',
          titleArabic: 'هيكل التطبيق والشاشة الرئيسية المنسقة',
          userValueDescriptionArabic: 'واجهة هادئة تعرض ما يحتاجه المسلم الآن',
          associatedModule: 'app_shell',
          epicId: 'EPIC 2',
        ),
        V1FeatureBacklogItem(
          itemId: 'FEAT-002',
          titleArabic: 'محرك حساب مواقيت الصلاة والقبلة',
          userValueDescriptionArabic: 'مواقيت دقيقة محلية دون إنترنت',
          associatedModule: 'prayer',
          epicId: 'EPIC 3',
        ),
        V1FeatureBacklogItem(
          itemId: 'FEAT-003',
          titleArabic: 'تصفح وبحث المصحف العثماني',
          userValueDescriptionArabic: 'قراءة مريحة بالرسم العثماني المعتمد',
          associatedModule: 'quran',
          epicId: 'EPIC 4',
        ),
        V1FeatureBacklogItem(
          itemId: 'FEAT-004',
          titleArabic: 'بطاقات الحفظ والتكرار المتباعد',
          userValueDescriptionArabic: 'تثبيت حفظ الآيات بخوارزمية SM-2',
          associatedModule: 'memorization',
          epicId: 'EPIC 5',
        ),
        V1FeatureBacklogItem(
          itemId: 'FEAT-005',
          titleArabic: 'قائمة الأذكار والعداد التفاعلي',
          userValueDescriptionArabic: 'أذكار الصباح والمساء بعداد لمسي',
          associatedModule: 'adhkar',
          epicId: 'EPIC 6',
        ),
      ],
      hasMobileAiRuntime: false,
      hasPietyScoring: false,
      finalizedAt: DateTime(2026, 9, 1),
    );
  }

  @override
  List<Object?> get props => [
        version,
        mustShipCapabilities,
        excludedCapabilities,
        goldenJourneys,
        coreEpics,
        backlogItems,
        hasMobileAiRuntime,
        hasPietyScoring,
        finalizedAt,
      ];
}
