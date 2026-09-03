import '../../modules/adhkar/adhkar_module.dart';
import '../../modules/hajj/hajj_module.dart';
import '../../modules/knowledge/knowledge_module.dart';
import '../../modules/learning/learning_module.dart';
import '../../modules/quran/quran_module.dart';
import '../../modules/seerah/seerah_module.dart';
import 'default_canonical_seed_provider.dart';

/// Deterministic, offline-first, idempotent content seeding engine for SIRAJ v1.0 MVP (§20).
/// Strictly populates in-memory and local modules with authenticated canonical data.
class ContentSeedEngine {
  static const String seedVersion = '1.0.0';
  static bool _isSeeded = false;

  const ContentSeedEngine._();

  /// Synchronously seeds all core knowledge and worship modules.
  /// Idempotent: Can be called repeatedly on hot reload or app restart without duplicate entries.
  static void seedAllModules({
    required QuranModule quranModule,
    required AdhkarModule adhkarModule,
    required KnowledgeModule knowledgeModule,
    required LearningModule learningModule,
    required SeerahModule seerahModule,
    required HajjModule hajjModule,
  }) {
    // 1. Seed Quran Canonical Package
    final quranPkg = DefaultCanonicalSeedProvider.getQuranSeedPackage();
    quranModule.store.mountPackage(quranPkg);

    // 2. Seed Adhkar Canonical Package
    final adhkarPkg = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
    adhkarModule.mountPackage(adhkarPkg);

    // 3. Seed Knowledge & Hadith Package
    final knowledgePkg = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
    knowledgeModule.mountPackage(knowledgePkg);

    // 4. Seed Learning & Curriculum Package
    final learningPkg = DefaultCanonicalSeedProvider.getLearningSeedPackage();
    learningModule.mountPackage(learningPkg);

    // 5. Seed Seerah & Islamic History Package
    final seerahPkg = DefaultCanonicalSeedProvider.getSeerahSeedPackage();
    seerahModule.mountPackage(seerahPkg);

    // 6. Seed Hajj & Umrah Guidance Package
    final hajjPkg = DefaultCanonicalSeedProvider.getHajjSeedPackage();
    hajjModule.mountPackage(hajjPkg);

    _isSeeded = true;
  }

  static bool get isSeeded => _isSeeded;
}
