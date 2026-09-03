import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/knowledge/domain/fiqh_school.dart';
import 'package:siraj/modules/knowledge/domain/fiqh_topic.dart';
import 'package:siraj/modules/knowledge/services/fiqh_service.dart';
import 'package:siraj/modules/knowledge/store/read_only_knowledge_store.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 Fiqh Knowledge, Multi-School Positions & Evidence Tests (§13, §14, §16)', () {
    late ReadOnlyKnowledgeStore store;
    late FiqhService fiqhService;

    setUp(() {
      store = ReadOnlyKnowledgeStore();
      fiqhService = FiqhService(store: store);
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('FiqhTopic computes and verifies SHA-256 cryptographic hash', () {
      final topic = SyntheticKnowledgeFixtures.createFiqhTopic();
      expect(topic.verifyHash(), isTrue);

      final map = topic.toMap();
      final revived = FiqhTopic.fromMap(map);
      expect(revived, equals(topic));
      expect(revived.verifyHash(), isTrue);
    });

    test('FiqhTopic supports multiple positions without declaring single universal truth', () {
      final res = fiqhService.getTopicById('topic_niyyah_fasting');
      expect(res.isSuccess, isTrue);
      final topic = res.valueOrNull!;

      expect(topic.positions.length, equals(2));
      expect(topic.positions[0].school, equals(FiqhSchool.hanafi));
      expect(topic.positions[0].rulingText.contains('إلى ما قبل نصف النهار'), isTrue);
      expect(topic.positions[1].school, equals(FiqhSchool.majority));
      expect(topic.positions[1].rulingText.contains('يشترط تبييت النية'), isTrue);
    });

    test('EvidenceReference connects Fiqh positions to canonical textual sources', () {
      final res = fiqhService.getTopicById('topic_niyyah_fasting');
      final topic = res.valueOrNull!;

      final evidences = topic.positions.first.evidences;
      expect(evidences.isNotEmpty, isTrue);
      expect(evidences.first.referenceKey, equals('hadith_001'));
      expect(evidences.first.displayCitation.contains('الأعمال بالنيات'), isTrue);
    });
  });
}
