import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/modules/prayer/services/qibla_service.dart';

void main() {
  group('M50: SIRAJ v1.0 — Qibla Engine & Great-Circle Spherical Bearing Suite (§15, §16, §31, §34)', () {
    const qiblaService = QiblaService();

    test('Bearing & Distance: Cairo (Egypt) points South-East (~136°)', () {
      const cairo = GeoCoordinates(latitude: 30.0444, longitude: 31.2357);
      final res = qiblaService.calculateQibla(cairo);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;
      expect(qibla.directionDegrees, inInclusiveRange(135.0, 137.5));
      expect(qibla.distanceKilometers, inInclusiveRange(1250.0, 1350.0));
    });

    test('Bearing & Distance: Istanbul (Turkey) points South-South-East (~152°)', () {
      const istanbul = GeoCoordinates(latitude: 41.0082, longitude: 28.9784);
      final res = qiblaService.calculateQibla(istanbul);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;
      expect(qibla.directionDegrees, inInclusiveRange(151.0, 153.5));
      expect(qibla.distanceKilometers, inInclusiveRange(2350.0, 2450.0));
    });

    test('Bearing & Distance: London (UK) points East-South-East (~119°)', () {
      const london = GeoCoordinates(latitude: 51.5074, longitude: -0.1278);
      final res = qiblaService.calculateQibla(london);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;
      expect(qibla.directionDegrees, inInclusiveRange(118.0, 120.5));
      expect(qibla.distanceKilometers, inInclusiveRange(4750.0, 4850.0));
    });

    test('Bearing & Distance: New York (USA) points North-East Great Circle (~58°)', () {
      const ny = GeoCoordinates(latitude: 40.7128, longitude: -74.0060);
      final res = qiblaService.calculateQibla(ny);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;
      expect(qibla.directionDegrees, inInclusiveRange(57.0, 59.5));
      expect(qibla.distanceKilometers, inInclusiveRange(10200.0, 10400.0));
    });

    test('Bearing & Distance: Jakarta (Indonesia - Southern Hemisphere) points North-West (~295°)', () {
      const jakarta = GeoCoordinates(latitude: -6.2088, longitude: 106.8456);
      final res = qiblaService.calculateQibla(jakarta);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;
      expect(qibla.directionDegrees, inInclusiveRange(294.0, 296.5));
      expect(qibla.distanceKilometers, inInclusiveRange(7850.0, 8000.0));
    });

    test('Near-Kaaba & Boundary Behavior: Points extremely close to Makkah calculate without division by zero', () {
      const nearKaaba = GeoCoordinates(latitude: 21.4230, longitude: 39.8270);
      final res = qiblaService.calculateQibla(nearKaaba);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;
      expect(qibla.distanceKilometers, lessThan(2.0));
      expect(qibla.directionDegrees, inInclusiveRange(0.0, 360.0));
    });

    test('Longitude Wrap-Around: Antimeridian coordinates calculate properly', () {
      const fiji = GeoCoordinates(latitude: -17.7134, longitude: 178.0650);
      final res = qiblaService.calculateQibla(fiji);

      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull!.directionDegrees, inInclusiveRange(0.0, 360.0));
    });

    test('Invalid Coordinates: Rejects out of bound coordinates at entity boundary', () {
      expect(() => GeoCoordinates(latitude: 95.0, longitude: 39.8262), throwsAssertionError);
      expect(() => GeoCoordinates(latitude: 21.4225, longitude: 190.0), throwsAssertionError);
    });
  });
}
