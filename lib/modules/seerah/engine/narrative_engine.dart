import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../knowledge/domain/hadith_entity.dart';
import '../../knowledge/domain/source_record.dart';
import '../../knowledge/knowledge_module.dart';
import '../domain/seerah_event.dart';
import '../store/read_only_seerah_store.dart';

/// Resolved references payload for a Seerah Event (§17, §19).
class ResolvedEventReferences {
  final SeerahEvent event;
  final List<SourceRecord> sources;
  final List<HadithEntity> hadiths;

  const ResolvedEventReferences({
    required this.event,
    required this.sources,
    required this.hadiths,
  });
}

/// Engine managing narrative decomposition, variant segregation, and Quran/Hadith reference resolution (§13, §14, §15).
class NarrativeEngine {
  final ReadOnlySeerahStore _seerahStore;
  final KnowledgeModule? _knowledgeModule;

  const NarrativeEngine({
    required ReadOnlySeerahStore seerahStore,
    KnowledgeModule? knowledgeModule,
  })  : _seerahStore = seerahStore,
        _knowledgeModule = knowledgeModule;

  /// Resolves all underlying Sources and Hadith entities for a given Seerah Event.
  Result<ResolvedEventReferences, Failure> resolveEventReferences(String eventId) {
    final eventRes = _seerahStore.getEvent(eventId);
    if (eventRes.isFailure) return Result.err(eventRes.failureOrNull!);

    final event = eventRes.valueOrNull!;
    final sourcesList = <SourceRecord>[];
    final hadithsList = <HadithEntity>[];

    if (_knowledgeModule != null) {
      for (final srcId in event.sourceIds) {
        final srcRes = _knowledgeModule.getSource(srcId);
        if (srcRes.isSuccess) sourcesList.add(srcRes.valueOrNull!);
      }

      for (final hId in event.relatedHadithIds) {
        final hRes = _knowledgeModule.getHadith(hId);
        if (hRes.isSuccess) hadithsList.add(hRes.valueOrNull!);
      }
    }

    return Result.ok(
      ResolvedEventReferences(
        event: event,
        sources: sourcesList,
        hadiths: hadithsList,
      ),
    );
  }
}
