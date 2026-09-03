import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/knowledge/domain/hadith_entity.dart';
import 'package:siraj/modules/knowledge/domain/hadith_grading.dart';
import 'package:siraj/modules/knowledge/services/hadith_service.dart';
import 'package:siraj/modules/knowledge/store/read_only_knowledge_store.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 Hadith Domain, Multi-Grading & Textual Separation Tests (§7, §8, §9, §10, §11)', () {
    late ReadOnlyKnowledgeStore store;
    late HadithService hadithService;

    setUp(() {
      store = ReadOnlyKnowledgeStore();
      hadithService = HadithService(store: store);
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('HadithEntity computes and verifies SHA-256 cryptographic hash', () {
      final hadith = SyntheticKnowledgeFixtures.createHadith();
      expect(hadith.verifyHash(), isTrue);

      final map = hadith.toMap();
      final revived = HadithEntity.fromMap(map);
      expect(revived, equals(hadith));
      expect(revived.verifyHash(), isTrue);
    });

    test('Multiple gradings are preserved with scholar and source references without conflation', () {
      final g1 = HadithGrading.create(
        gradingId: 'grd_1',
        grade: HadithGrade.sahih,
        scholarName: 'الإمام البخاري',
        sourceBook: 'صحيح البخاري',
      );

      final g2 = HadithGrading.create(
        gradingId: 'grd_2',
        grade: HadithGrade.hasan,
        scholarName: 'الإمام الترمذي',
        sourceBook: 'سنن الترمذي',
        context: 'حديث حسن صحيح',
      );

      final hadith = HadithEntity.create(
        hadithId: 'hadith_multi_grade',
        collectionId: 'src_test',
        bookNumber: 1,
        bookName: 'كتاب الإيمان',
        primaryNumber: 2,
        arabicMatn: 'الإيمان بضع وسبعون شعبة',
        sourceId: 'src_test',
        gradings: [g1, g2],
      );

      expect(hadith.gradings.length, equals(2));
      expect(hadith.gradings[0].grade, equals(HadithGrade.sahih));
      expect(hadith.gradings[0].scholarName, equals('الإمام البخاري'));
      expect(hadith.gradings[1].grade, equals(HadithGrade.hasan));
      expect(hadith.gradings[1].scholarName, equals('الإمام الترمذي'));
    });

    test('Strict textual separation: Matn, Translation, and Commentary are isolated', () {
      final res = hadithService.getHadithById('hadith_001');
      expect(res.isSuccess, isTrue);
      final hadith = res.valueOrNull!;

      expect(hadith.arabicMatn, equals('إنما الأعمال بالنيات وإنما لكل امرئ ما نوى'));
      expect(hadith.translations['en']!.contains('Actions are according to intentions'), isTrue);
      expect(hadith.commentaries.length, equals(1));
      expect(hadith.commentaries.first.scholarName, equals('الحافظ ابن حجر العسقلاني'));
      expect(hadith.commentaries.first.quote.contains('هذا الحديث أصل عظيم'), isTrue);
    });
  });
}
