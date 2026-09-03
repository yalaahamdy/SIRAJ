import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/hajj/services/miqat_service.dart';
import 'package:siraj/modules/hajj/store/read_only_hajj_store.dart';
import '../../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('L2 Miqat Service & Proximity Tests (§14, §15)', () {
    late ReadOnlyHajjStore store;
    late MiqatService service;

    setUp(() {
      store = ReadOnlyHajjStore();
      store.mountPackage(SyntheticHajjFixtures.createPackage());
      service = MiqatService(store: store);
    });

    test('Finds Dhul Hulayfah as closest Miqat when coordinates are in Madinah', () {
      // User in Madinah near Prophet's Mosque
      const madinahLat = 24.467;
      const madinahLon = 39.611;

      final res = service.findClosestMiqats(madinahLat, madinahLon);
      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;

      expect(list.isNotEmpty, isTrue);
      expect(list.first.miqat.miqatId, equals('miqat_dhul_hulayfah'));
      expect(list.first.distanceKm, lessThan(15.0));
    });

    test('Finds Qarn al-Manazil as closest Miqat when approaching from Taif / Riyadh', () {
      const taifLat = 21.437;
      const taifLon = 40.512;

      final res = service.findClosestMiqats(taifLat, taifLon);
      expect(res.isSuccess, isTrue);
      final list = res.valueOrNull!;

      expect(list.first.miqat.miqatId, equals('miqat_qarn_al_manazil'));
      expect(list.first.distanceKm, lessThan(35.0));
    });
  });
}
