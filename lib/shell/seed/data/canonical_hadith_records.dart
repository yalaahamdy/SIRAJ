import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import 'canonical_hadith_bukhari.dart';
import 'canonical_hadith_muslim.dart';
import 'canonical_hadith_nawawi.dart';
import 'canonical_hadith_sunan.dart';

/// Authentic Canonical Hadith Records across 8 major Sunnah collections (§7..§12, M05.1).
/// Composes authentic corpora from Sahih Al-Bukhari, Sahih Muslim, the 40 Nawawi, and the 6 Sunan & Masanid.
class CanonicalHadithRecords {
  static List<HadithEntity> buildHadiths({
    required SourceRecord srcBukhari,
    required SourceRecord srcMuslim,
    required SourceRecord srcAbuDawud,
    required SourceRecord srcTirmidhi,
    required SourceRecord srcNasai,
    required SourceRecord srcIbnMajah,
    required SourceRecord srcMuwatta,
    required SourceRecord srcMusnad,
  }) {
    return [
      ...CanonicalHadithBukhari.buildHadiths(srcBukhari),
      ...CanonicalHadithMuslim.buildHadiths(srcMuslim),
      ...CanonicalHadithNawawi.buildHadiths(
        srcBukhari: srcBukhari,
        srcMuslim: srcMuslim,
        srcAbuDawud: srcAbuDawud,
        srcTirmidhi: srcTirmidhi,
        srcNasai: srcNasai,
        srcIbnMajah: srcIbnMajah,
      ),
      ...CanonicalHadithSunan.buildHadiths(
        srcAbuDawud: srcAbuDawud,
        srcTirmidhi: srcTirmidhi,
        srcNasai: srcNasai,
        srcIbnMajah: srcIbnMajah,
        srcMuwatta: srcMuwatta,
        srcMusnad: srcMusnad,
      ),
    ];
  }
}
