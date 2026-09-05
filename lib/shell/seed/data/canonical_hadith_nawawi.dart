import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import 'canonical_hadith_nawawi_part1.dart';
import 'canonical_hadith_nawawi_part2.dart';

/// جامع متون الأربعين النووية كاملاً (42 حديثاً محققاً) للإمام محيي الدين يحيى بن شرف النووي.
/// يجمع أصول الدين وقواعد الأحكام مع الشروح والأسانيد والأحكام الحديثية (§7..§12).
class CanonicalHadithNawawi {
  static List<HadithEntity> buildHadiths({
    required SourceRecord srcBukhari,
    required SourceRecord srcMuslim,
    required SourceRecord srcAbuDawud,
    required SourceRecord srcTirmidhi,
    required SourceRecord srcNasai,
    required SourceRecord srcIbnMajah,
  }) {
    return [
      ...CanonicalHadithNawawiPart1.buildHadiths(
        srcBukhari: srcBukhari,
        srcMuslim: srcMuslim,
        srcAbuDawud: srcAbuDawud,
        srcTirmidhi: srcTirmidhi,
        srcNasai: srcNasai,
        srcIbnMajah: srcIbnMajah,
      ),
      ...CanonicalHadithNawawiPart2.buildHadiths(
        srcBukhari: srcBukhari,
        srcMuslim: srcMuslim,
        srcAbuDawud: srcAbuDawud,
        srcTirmidhi: srcTirmidhi,
        srcNasai: srcNasai,
        srcIbnMajah: srcIbnMajah,
      ),
    ];
  }
}
