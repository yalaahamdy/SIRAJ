import 'package:siraj/modules/knowledge/domain/canonical_knowledge_package.dart';
import 'package:siraj/modules/knowledge/domain/evidence_reference.dart';
import 'package:siraj/modules/knowledge/domain/fiqh_position.dart';
import 'package:siraj/modules/knowledge/domain/fiqh_school.dart';
import 'package:siraj/modules/knowledge/domain/fiqh_topic.dart';
import 'package:siraj/modules/knowledge/domain/hadith_entity.dart';
import 'package:siraj/modules/knowledge/domain/hadith_grading.dart';
import 'package:siraj/modules/knowledge/domain/knowledge_item.dart';
import 'package:siraj/modules/knowledge/domain/knowledge_relation.dart';
import 'package:siraj/modules/knowledge/domain/learning_path.dart';
import 'package:siraj/modules/knowledge/domain/scholarly_attribution.dart';
import 'package:siraj/modules/knowledge/domain/source_record.dart';
import 'package:siraj/modules/knowledge/domain/source_type.dart';

/// Synthetic Knowledge fixtures for testing (§40).
/// Strictly uses synthetic test data without fabricating real religious claims.
class SyntheticKnowledgeFixtures {
  static SourceRecord createSourceRecord({
    String id = 'src_bukhari_test',
    String title = 'صحيح البخاري — طبعة التأصيل التجريبية',
    String author = 'الإمام محمد بن إسماعيل البخاري (ت 256 هـ)',
    SourceType type = SourceType.hadithCollection,
  }) {
    return SourceRecord.create(
      sourceId: id,
      title: title,
      author: author,
      editor: 'مركز التوثيق التجريبي',
      publisher: 'دار التأصيل',
      edition: 'الطبعة الأولى 1445 هـ',
      year: 1445,
      sourceType: type,
      referenceScheme: 'ترقيم العالمية المعياري',
      reviewState: 'APPROVED',
    );
  }

  static HadithEntity createHadith({
    String id = 'hadith_001',
    String collectionId = 'src_bukhari_test',
    int bookNumber = 1,
    String bookName = 'كتاب بدء الوحي',
    int primaryNumber = 1,
    String matn = 'إنما الأعمال بالنيات وإنما لكل امرئ ما نوى',
    String isnad = 'حدثنا الحميدي قال حدثنا سفيان عن يحيى بن سعيد الأنصاري',
    HadithGrade grade = HadithGrade.sahih,
    String scholarName = 'الإمام البخاري',
  }) {
    final grading = HadithGrading.create(
      gradingId: 'grd_${id}_1',
      grade: grade,
      scholarName: scholarName,
      sourceBook: 'صحيح البخاري',
      context: 'أورده في صدر صحيحه محتجاً به',
    );

    final commentary = ScholarlyAttribution.create(
      attributionId: 'com_${id}_1',
      scholarId: 'scholar_ibn_hajar',
      scholarName: 'الحافظ ابن حجر العسقلاني',
      quote: 'هذا الحديث أصل عظيم من أصول الإسلام وقاعدة من قواعد الأحكام',
      sourceId: 'src_fath_bari_test',
      pageReference: 'فتح الباري ج 1 ص 15',
    );

    return HadithEntity.create(
      hadithId: id,
      collectionId: collectionId,
      bookNumber: bookNumber,
      bookName: bookName,
      chapterNumber: 1,
      chapterName: 'كيف كان بدء الوحي إلى رسول الله ﷺ',
      primaryNumber: primaryNumber,
      internationalNumber: 1,
      arabicMatn: matn,
      isnad: isnad,
      sourceId: collectionId,
      gradings: [grading],
      translations: const {'en': 'Actions are according to intentions...'},
      commentaries: [commentary],
    );
  }

  static FiqhTopic createFiqhTopic({
    String id = 'topic_niyyah_fasting',
    String title = 'حكم تبييت النية في صوم الفرض',
    String summary = 'اتفق الفقهاء على اشتراط النية لصحة الصوم واختلفوا في لزوم تبييتها من الليل في صيام الفرض.',
  }) {
    final ev1 = EvidenceReference.create(
      evidenceId: 'ev_001',
      evidenceType: EvidenceType.hadith,
      referenceKey: 'hadith_001',
      displayCitation: 'حديث إنما الأعمال بالنيات',
    );

    final posHanafi = FiqhPosition.create(
      positionId: 'pos_001',
      school: FiqhSchool.hanafi,
      rulingText: 'تصح النية في صوم رمضان إلى ما قبل نصف النهار الشرعي.',
      scholarName: 'الإمام السرخسي',
      sourceId: 'src_mabsut_test',
      pageReference: 'المبسوط ج 3 ص 54',
      evidences: [ev1],
    );

    final posJumhoor = FiqhPosition.create(
      positionId: 'pos_002',
      school: FiqhSchool.majority,
      rulingText: 'يشترط تبييت النية من الليل لكل يوم من أيام صيام الفرض.',
      scholarName: 'جمهور الفقهاء (المالكية والشافعية والحنابلة)',
      sourceId: 'src_majmoo_test',
      pageReference: 'المجموع للنووي ج 6 ص 290',
      evidences: [ev1],
    );

    return FiqhTopic.create(
      topicId: id,
      title: title,
      summary: summary,
      category: 'فقه الصيام',
      positions: [posHanafi, posJumhoor],
    );
  }

  static KnowledgeItem createKnowledgeItem({
    String id = 'know_001',
    String title = 'مراتب الدين الثلاث: الإسلام والإيمان والإحسان',
    String text = 'الدين مراتب ثلاث أعلاها الإحسان وأوسطها الإيمان وأساسها الإسلام.',
  }) {
    return KnowledgeItem.create(
      itemId: id,
      title: title,
      category: 'أصول العقيدة',
      contentType: KnowledgeContentType.generalExplanation,
      primaryText: text,
      sourceId: 'src_usul_test',
      tags: const ['عقيدة', 'مراتب الدين'],
    );
  }

  static CanonicalKnowledgePackage createPackage() {
    final src = createSourceRecord();
    final hadith = createHadith(collectionId: src.sourceId);
    final fiqh = createFiqhTopic();
    final know = createKnowledgeItem();

    final rel = KnowledgeRelation(
      relationId: 'rel_001',
      sourceKey: hadith.hadithId,
      targetKey: fiqh.topicId,
      relationType: RelationType.evidenceFor,
      description: 'دليل اشتراط النية في العبادات',
    );

    final path = LearningPath(
      pathId: 'path_basics',
      title: 'المدخل إلى علوم الشريعة',
      description: 'مسار تأسيسي في مبادئ الحديث والفقه',
      level: LearningLevel.beginner,
      itemIds: [hadith.hadithId, fiqh.topicId, know.itemId],
    );

    return CanonicalKnowledgePackage.create(
      packageId: 'pkg_knowledge_test_v1',
      sources: [src],
      hadiths: [hadith],
      fiqhTopics: [fiqh],
      knowledgeItems: [know],
      relations: [rel],
      learningPaths: [path],
      signerIdentity: 'siraj.knowledge.board',
      signature: 'sig_canonical_valid_123',
      publishedAt: DateTime.utc(2026, 8, 31),
    );
  }
}
