import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../platform/content/domain/content_record.dart';

/// Contract definition for Quran module (To be implemented in Phase 3).
/// Reads canonical text strictly via ContentStore.
abstract class QuranModuleContract {
  /// Retrieves Ayah by Surah number and Ayah number.
  Future<Result<ContentRecord, Failure>> getAyah({
    required int surahNumber,
    required int ayahNumber,
  });

  /// Retrieves Ayahs on a specific Mushaf page (1..604).
  Future<Result<List<ContentRecord>, Failure>> getPageAyahs(int pageNumber);
}
