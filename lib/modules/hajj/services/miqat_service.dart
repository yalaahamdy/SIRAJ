import 'dart:math' as math;
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/miqat.dart';
import '../store/read_only_hajj_store.dart';

/// Result structure for nearest Miqat calculation (§14, §15).
class MiqatDistanceResult {
  final Miqat miqat;
  final double distanceKm;

  const MiqatDistanceResult({
    required this.miqat,
    required this.distanceKm,
  });
}

/// Service providing canonical Miqat queries and informational proximity advice (§14, §15).
class MiqatService {
  final ReadOnlyHajjStore _store;

  const MiqatService({required ReadOnlyHajjStore store}) : _store = store;

  static double calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusKm = 6371.0;
    final dLat = (lat2 - lat1) * (math.pi / 180.0);
    final dLon = (lon2 - lon1) * (math.pi / 180.0);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180.0)) *
            math.cos(lat2 * (math.pi / 180.0)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  Result<List<MiqatDistanceResult>, Failure> findClosestMiqats(
    double userLat,
    double userLon,
  ) {
    if (!_store.isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }

    final miqatsRes = _store.getAllMiqats();
    if (miqatsRes.isFailure) return Result.err(miqatsRes.failureOrNull!);

    final list = miqatsRes.valueOrNull!.map((m) {
      final dist = calculateDistanceKm(userLat, userLon, m.latitude, m.longitude);
      return MiqatDistanceResult(miqat: m, distanceKm: dist);
    }).toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    return Result.ok(list);
  }
}
