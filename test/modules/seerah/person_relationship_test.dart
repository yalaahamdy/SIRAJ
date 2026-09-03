import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/seerah/domain/person_relationship.dart';
import 'package:siraj/modules/seerah/store/read_only_seerah_store.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('L2 Person & Relationships Domain Tests (§8, §9, §10)', () {
    late ReadOnlySeerahStore store;

    setUp(() {
      store = ReadOnlySeerahStore();
      final pkg = SyntheticSeerahFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('HistoricalPerson verifies cryptographic hash and bio details', () {
      final pRes = store.getPerson('person_abu_bakr');
      expect(pRes.isSuccess, isTrue);
      final p = pRes.valueOrNull!;

      expect(p.canonicalName, contains('أبو بكر الصديق'));
      expect(p.verifyHash(), isTrue);
      expect(p.aliases, contains('عتيق'));
    });

    test('Retrieves bidirectional relationships for a historical figure', () {
      final relsRes = store.getRelationshipsForPerson('person_abu_bakr');
      expect(relsRes.isSuccess, isTrue);
      final rels = relsRes.valueOrNull!;

      expect(rels.isNotEmpty, isTrue);
      expect(rels.first.type, equals(RelationshipType.companionOf));
      expect(rels.first.sourceId, equals('src_bukhari_test'));
    });
  });
}
