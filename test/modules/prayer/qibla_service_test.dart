import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/modules/prayer/domain/qibla_result.dart';
import 'package:siraj/modules/prayer/services/qibla_service.dart';

void main() {
  group('L2 Qibla Service Trigonometric Tests (§16)', () {
    const service = QiblaService();

    test('At the Holy Kaaba itself, distance is near zero and isAtKaaba is true', () {
      final res = service.calculateQibla(QiblaResult.kaabaCoordinates);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;

      expect(qibla.distanceKilometers, lessThan(0.1));
      expect(qibla.isAtKaaba, isTrue);
    });

    test('Medina (North of Makkah) bearing is towards the South (~176°)', () {
      const medina = GeoCoordinates(latitude: 24.4672, longitude: 39.6111);
      final res = service.calculateQibla(medina);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;

      expect(qibla.directionDegrees, inInclusiveRange(174.0, 178.0));
      expect(qibla.distanceKilometers, inInclusiveRange(300.0, 400.0));
    });

    test('Riyadh (East of Makkah) bearing is towards West-South-West (~244°)', () {
      const riyadh = GeoCoordinates(latitude: 24.7136, longitude: 46.6753);
      final res = service.calculateQibla(riyadh);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;

      expect(qibla.directionDegrees, inInclusiveRange(240.0, 248.0));
      expect(qibla.distanceKilometers, inInclusiveRange(780.0, 900.0));
    });

    test('Cairo (North-West of Makkah) bearing is towards South-East (~136°)', () {
      const cairo = GeoCoordinates(latitude: 30.0444, longitude: 31.2357);
      final res = service.calculateQibla(cairo);

      expect(res.isSuccess, isTrue);
      final qibla = res.valueOrNull!;

      expect(qibla.directionDegrees, inInclusiveRange(134.0, 138.0));
    });

    test('GeoCoordinates rejects invalid coordinates via assertion', () {
      expect(
        () => GeoCoordinates(latitude: 91.0, longitude: 10.0),
        throwsAssertionError,
      );
    });
  });
}
