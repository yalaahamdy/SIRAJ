import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/seerah/search/seerah_search_service.dart';
import 'package:siraj/modules/seerah/store/read_only_seerah_store.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('L2 Seerah Search Service Tests (§30)', () {
    late ReadOnlySeerahStore store;
    late SeerahSearchService searchService;

    setUp(() {
      store = ReadOnlySeerahStore();
      final pkg = SyntheticSeerahFixtures.createPackage();
      store.mountPackage(pkg);
      searchService = SeerahSearchService(store: store);
    });

    test('Searches across events with Arabic normalization and returns evidence label', () {
      final res = searchService.search('غزوه بدر');
      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;

      expect(list.isNotEmpty, isTrue);
      final item = list.firstWhere((r) => r.type == 'event');
      expect(item.title, contains('غزوة بدر'));
      expect(item.tagLabel, contains('مصدر أصيل'));
    });

    test('Searches across persons and places', () {
      final pRes = searchService.search('ابو بكر');
      expect(pRes.isSuccess, isTrue);
      expect(pRes.valueOrNull!.any((r) => r.type == 'person'), isTrue);

      final plRes = searchService.search('الحجاز');
      expect(plRes.isSuccess, isTrue);
      expect(plRes.valueOrNull!.any((r) => r.type == 'place'), isTrue);
    });

    test('Empty query returns empty results', () {
      final res = searchService.search('   ');
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull!.isEmpty, isTrue);
    });
  });
}
