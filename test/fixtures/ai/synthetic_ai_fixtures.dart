import 'package:siraj/modules/ai/domain/evidence_item.dart';

/// Synthetic test fixtures for AI Retrieval testing without real religious generation (§73).
class SyntheticAIFixtures {
  static EvidenceItem createValidHadithEvidence({
    String contentId = 'hadith_001',
    String text = 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
    String referenceLocation = 'صحيح البخاري - كتاب بدء الوحي - رقم 1',
  }) {
    return EvidenceItem(
      sourceId: 'src_bukhari',
      contentId: contentId,
      contentType: 'hadith',
      title: 'حديث إنما الأعمال بالنيات',
      textExcerpt: text,
      referenceLocation: referenceLocation,
      version: '1.0.0',
      verificationState: VerificationState.approved,
      relevanceScore: 0.98,
    );
  }

  static EvidenceItem createValidQuranEvidence({
    String contentId = 'ayah_1_1',
    String text = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    String referenceLocation = 'سورة الفاتحة - آية 1',
  }) {
    return EvidenceItem(
      sourceId: 'src_quran_hafs',
      contentId: contentId,
      contentType: 'ayah',
      title: 'البسملة',
      textExcerpt: text,
      referenceLocation: referenceLocation,
      version: '1.0.0',
      verificationState: VerificationState.canonical,
      relevanceScore: 1.0,
    );
  }

  static EvidenceItem createValidDhikrEvidence({
    String contentId = 'dhikr_morning_1',
    String text = 'أصبحنا وأصبح الملك لله والحمد لله',
    String referenceLocation = 'أذكار الصباح - صحيح مسلم',
  }) {
    return EvidenceItem(
      sourceId: 'src_muslim',
      contentId: contentId,
      contentType: 'dhikr',
      title: 'أذكار الصباح والمساء',
      textExcerpt: text,
      referenceLocation: referenceLocation,
      version: '1.0.0',
      verificationState: VerificationState.approved,
      relevanceScore: 0.92,
    );
  }
}
