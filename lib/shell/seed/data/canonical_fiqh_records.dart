import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import 'canonical_fiqh_transactions.dart';
import 'canonical_fiqh_worship.dart';

/// Authentic Canonical Fiqh Records (32 verified Topics across the Four Madhhabs) (§13..§16).
/// Structured across 6 key jurisprudential categories:
/// 1. فقه الطهارة (4 مسائل)
/// 2. فقه الصلاة (7 مسائل)
/// 3. فقه الجنائز (مسألة واحدة)
/// 4. فقه الزكاة والصوم (5 مسائل)
/// 5. فقه الحج والعمرة (مسألة واحدة)
/// 6. فقه المعاملات المالية والأسرة والآداب (14 مسألة)
class CanonicalFiqhRecords {
  static List<FiqhTopic> buildFiqhTopics({
    required SourceRecord srcMajmoo,
    required SourceRecord srcMughni,
  }) {
    return [
      ...CanonicalFiqhWorship.buildTopics(
        srcMajmoo: srcMajmoo,
        srcMughni: srcMughni,
      ),
      ...CanonicalFiqhTransactions.buildTopics(
        srcMajmoo: srcMajmoo,
        srcMughni: srcMughni,
      ),
    ];
  }
}
