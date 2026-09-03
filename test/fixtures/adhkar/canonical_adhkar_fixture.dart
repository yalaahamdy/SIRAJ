import 'package:siraj/modules/adhkar/domain/authenticity_grade.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_type.dart';
import 'package:siraj/modules/adhkar/domain/repetition_provenance.dart';
import 'package:siraj/modules/adhkar/store/canonical_adhkar_package.dart';

/// Test fixture providing valid and authenticated Adhkar package fixtures (§41).
class CanonicalAdhkarFixture {
  const CanonicalAdhkarFixture._();

  static CanonicalAdhkarPackage createValidTestPackage() {
    final item1 = createItem(
      id: 'dhikr_morning_001',
      textArabic: 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ',
      sourceTitle: 'صحيح مسلم',
      sourceAuthor: 'الإمام مسلم بن الحجاج',
      reference: 'كتاب الذكر والدعاء والتوبة والاستغفار، رقم 2723',
      authenticityGrade: AuthenticityGrade.authenticated,
      attribution: 'عن عبد الله بن مسعود رضي الله عنه عن النبي ﷺ',
      occasion: DhikrOccasion.morning,
      repetition: const RepetitionProvenance(count: 1, isSourced: true, note: 'يُقال مرة واحدة'),
      benefit: 'من أذكار الصباح الجامعة للتوحيد والحمد',
    );

    final item2 = createItem(
      id: 'dhikr_evening_001',
      textArabic: 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ',
      sourceTitle: 'صحيح مسلم',
      sourceAuthor: 'الإمام مسلم بن الحجاج',
      reference: 'كتاب الذكر والدعاء، رقم 2723',
      authenticityGrade: AuthenticityGrade.authenticated,
      attribution: 'عن عبد الله بن مسعود رضي الله عنه عن النبي ﷺ',
      occasion: DhikrOccasion.evening,
      repetition: const RepetitionProvenance(count: 1, isSourced: true, note: 'يُقال مرة واحدة في المساء'),
      benefit: 'من أذكار المساء المأثورة',
    );

    final item3 = createItem(
      id: 'dhikr_after_prayer_001',
      textArabic: 'أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ',
      sourceTitle: 'صحيح مسلم',
      sourceAuthor: 'الإمام مسلم بن الحجاج',
      reference: 'كتاب المساجد ومواضع الصلاة، رقم 591',
      authenticityGrade: AuthenticityGrade.authenticated,
      attribution: 'عن ثوبان رضي الله عنه',
      occasion: DhikrOccasion.afterPrayer,
      repetition: const RepetitionProvenance(count: 3, isSourced: true, note: 'ثلاث مرات دبر كل صلاة'),
      benefit: 'الاستغفار عقب انقضاء الصلاة المكتوبة',
    );

    final item4 = createItem(
      id: 'dhikr_sleep_001',
      textArabic: 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي وَبِكَ أَرْفَعُهُ',
      sourceTitle: 'صحيح البخاري',
      sourceAuthor: 'الإمام محمد بن إسماعيل البخاري',
      reference: 'كتاب الدعوات، رقم 6320',
      authenticityGrade: AuthenticityGrade.authenticated,
      attribution: 'عن أبي هريرة رضي الله عنه عن النبي ﷺ',
      occasion: DhikrOccasion.sleep,
      repetition: const RepetitionProvenance(count: 1, isSourced: true, note: 'عند النوم'),
      benefit: 'حفظ العبد عند نومه واستيقاظه',
    );

    final items = [item1, item2, item3, item4];
    final aggregateHash = CanonicalAdhkarPackage.computeAggregateHash(items);

    return CanonicalAdhkarPackage(
      packageId: 'pkg_adhkar_test_synthetic_v1',
      version: '1.0.0',
      schemaVersion: 1,
      title: 'حزمة الأذكار النموذجية الموثقة للاختبار',
      items: items,
      contentHash: aggregateHash,
      signerIdentity: 'SIRAJ_SACRED_CONTENT_TEST_AUTHORITY',
      signature: 'TEST_SIG_VALID_HEX_9876543210ABCDEF',
      publishedAt: DateTime.utc(2026, 8, 31, 12, 0),
    );
  }

  static DhikrItem createItem({
    required String id,
    required String textArabic,
    required String sourceTitle,
    required String sourceAuthor,
    required String reference,
    required AuthenticityGrade authenticityGrade,
    required String attribution,
    required DhikrOccasion occasion,
    required RepetitionProvenance repetition,
    String? benefit,
    DhikrType type = DhikrType.transmittedDhikr,
  }) {
    final hash = DhikrItem.computeHash(
      id: id,
      type: type,
      textArabic: textArabic,
      sourceTitle: sourceTitle,
      sourceAuthor: sourceAuthor,
      reference: reference,
      authenticityGrade: authenticityGrade,
      attribution: attribution,
      repetitionCount: repetition.count,
      isSourced: repetition.isSourced,
      occasion: occasion,
    );

    return DhikrItem(
      id: id,
      type: type,
      textArabic: textArabic,
      sourceTitle: sourceTitle,
      sourceAuthor: sourceAuthor,
      reference: reference,
      authenticityGrade: authenticityGrade,
      attribution: attribution,
      occasion: occasion,
      repetition: repetition,
      benefit: benefit,
      integrityHash: hash,
    );
  }
}
