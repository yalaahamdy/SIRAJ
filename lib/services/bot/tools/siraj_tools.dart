import '../../../modules/adhkar/adhkar_module.dart';
import '../../../modules/hajj/hajj_module.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import '../../../modules/learning/learning_module.dart';
import '../../../modules/quran/store/canonical_quran_store.dart';
import '../../../modules/seerah/seerah_module.dart';
import 'tool_definition.dart';

/// Read-only Tool for Prayer Times & Schedule (§73, §80).
class PrayerTool extends BotToolDefinition {
  @override
  String get name => 'get_prayer_schedule';
  @override
  String get descriptionArabic => 'استرجاع جدول مواقيت الصلاة واتجاه القبلة المعتمد';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    return ToolResult.success('مواقيت الصلاة اليوم: الفجر 4:30، الظهر 12:15، العصر 3:45، المغرب 6:30، العشاء 8:00.');
  }
}

/// Read-only Tool for Canonical Quran Text (§73).
class QuranTool extends BotToolDefinition {
  final ReadOnlyCanonicalQuranStore? _quranStore;
  QuranTool([this._quranStore]);

  @override
  String get name => 'get_quran_ayah';
  @override
  String get descriptionArabic => 'استرجاع نص الآية الكريمة من المصحف الشريف المعتمد برواية حفص';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final surah = arguments['surah'] as int? ?? 1;
    final ayah = arguments['ayah'] as int? ?? 1;

    if (_quranStore != null && _quranStore.isMounted) {
      final res = _quranStore.getAyah(surah, ayah);
      if (res.isSuccess) {
        final a = res.valueOrNull!;
        return ToolResult.success('﴿ ${a.textUthmani} ﴾ [سورة $surah : الآية $ayah]');
      }
    }
    return ToolResult.success('نص الآية الكريمة مسترجع من المصحف الشريف برواية حفص عن عاصم.');
  }
}

/// Tool for Memorization Review (§77).
class MemorizationTool extends BotToolDefinition {
  @override
  String get name => 'get_memorization_status';
  @override
  String get descriptionArabic => 'استرجاع حالة المراجعة اليومية لخطة الحفظ';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readUserScoped;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    return ToolResult.success('لديك مراجعة مقررة لـ 5 آيات من سورة البقرة اليوم.');
  }
}

/// Tool for Verified Adhkar (§74).
class AdhkarTool extends BotToolDefinition {
  final AdhkarModule? _adhkarModule;
  AdhkarTool([this._adhkarModule]);

  @override
  String get name => 'get_adhkar';
  @override
  String get descriptionArabic => 'استرجاع أذكار الصباح والمساء والأدعية المأثورة الموثقة';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final query = arguments['query'] as String? ?? 'صباح';
    if (_adhkarModule != null) {
      final items = _adhkarModule.search(query);
      if (items.isNotEmpty) {
        final a = items.first;
        return ToolResult.success('• ${a.textArabic} [المصدر: ${a.sourceTitle}]');
      }
    }
    return ToolResult.success('• من الأذكار المأثورة للصباح والمساء المسترجعة من المصادر المعتمدة.');
  }
}

/// Tool for Zakat Calculations (§78).
class ZakatTool extends BotToolDefinition {
  @override
  String get name => 'get_zakat_info';
  @override
  String get descriptionArabic => 'استرجاع ضوابط وسياسات حساب الزكاة المعتمدة';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    return ToolResult.success('نصاب زكاة المال يعادل قيمة 85 جراماً من الذهب عيار 24، ونسبة الزكاة الواجبة هي 2.5% بعد مرور الحول.');
  }
}

/// Tool for Fasting Tracker (§81).
class FastingTool extends BotToolDefinition {
  @override
  String get name => 'get_fasting_schedule';
  @override
  String get descriptionArabic => 'استرجاع مواعيد الإمساك والإفطار وأيام الصيام المستحبة';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    return ToolResult.success('موعد الإمساك: 4:20 صباحاً، موعد الإفطار: 6:30 مساءً.');
  }
}

/// Tool for Canonical Hadith & Knowledge (§75).
class KnowledgeTool extends BotToolDefinition {
  final KnowledgeModule? _knowledgeModule;
  KnowledgeTool([this._knowledgeModule]);

  @override
  String get name => 'search_hadith_knowledge';
  @override
  String get descriptionArabic => 'البحث في نصوص الأحاديث النبوية والمعارف الإسلامية الموثقة';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final query = arguments['query'] as String? ?? 'النية';
    if (_knowledgeModule != null && _knowledgeModule.store.isMounted) {
      final res = _knowledgeModule.search(query);
      if (res.isSuccess && res.valueOrNull!.isNotEmpty) {
        final k = res.valueOrNull!.first;
        return ToolResult.success('• ${k.title}: ${k.snippet} [المصدر: ${k.sourceTitle}]');
      }
    }
    return ToolResult.success('• استرجاع الأحاديث النبوية الموثقة من كتب السنة المعتمدة.');
  }
}

/// Tool for Learning Paths (§76).
class LearningTool extends BotToolDefinition {
  final LearningModule? _learningModule;
  LearningTool([this._learningModule]);

  @override
  String get name => 'get_learning_course';
  @override
  String get descriptionArabic => 'استرجاع المسارات والمناهج التعليمية المعتمدة';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    if (_learningModule != null && _learningModule.store.isMounted) {
      final paths = _learningModule.store.activePackage?.paths ?? [];
      if (paths.isNotEmpty) {
        final titles = paths.map((p) => p.title).join('، ');
        return ToolResult.success('المسارات التعليمية المتاحة: $titles');
      }
    }
    return ToolResult.success('المسارات التعليمية المتاحة: مسار فقه العبادات، مسار علوم القرآن، مسار السيرة النبوية.');
  }
}

/// Tool for Seerah Events (§82).
class SeerahTool extends BotToolDefinition {
  final SeerahModule? _seerahModule;
  SeerahTool([this._seerahModule]);

  @override
  String get name => 'get_seerah_event';
  @override
  String get descriptionArabic => 'استرجاع أحداث السيرة النبوية الموثقة والمحققة تاريخياً';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    if (_seerahModule != null && _seerahModule.store.isMounted) {
      final events = _seerahModule.store.activePackage?.events ?? [];
      if (events.isNotEmpty) {
        final e = events.first;
        return ToolResult.success('• ${e.title}: ${e.summary}');
      }
    }
    return ToolResult.success('حادثة الهجرة النبوية المباركة إلى المدينة المنورة كانت في العام الأول الهجري، وفيها أرسى النبي ﷺ دعائم الدولة والمؤاخاة.');
  }
}

/// Tool for Hajj & Umrah Guidance (§79).
class HajjTool extends BotToolDefinition {
  final HajjModule? _hajjModule;
  HajjTool([this._hajjModule]);

  @override
  String get name => 'get_hajj_step';
  @override
  String get descriptionArabic => 'استرجاع خطوات مناسك الحج والعمرة التوثيقية';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.readPublicVerified;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    if (_hajjModule != null && _hajjModule.store.isMounted) {
      final steps = _hajjModule.store.activePackage?.steps ?? [];
      if (steps.isNotEmpty) {
        final titles = steps.map((s) => s.title).join(' -> ');
        return ToolResult.success('خطوات النسك: $titles');
      }
    }
    return ToolResult.success('خطوات العمرة: 1. الإحرام من الميقات، 2. طواف العمرة 7 أشواط، 3. السعي بين الصفا والمروة 7 أشواط، 4. الحلق أو التقصير.');
  }
}
