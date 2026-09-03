import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/canonical_hajj_package.dart';
import '../domain/journey_type.dart';
import '../domain/miqat.dart';
import '../domain/preparation_item.dart';
import '../domain/ritual_phase.dart';
import '../domain/ritual_step.dart';
import '../domain/sacred_location.dart';

/// Read-only repository for verified Hajj & Umrah canonical package (§40, §41).
class ReadOnlyHajjStore {
  CanonicalHajjPackage? _activePackage;
  final Map<String, RitualStep> _stepsById = {};
  final Map<String, Miqat> _miqatsById = {};
  final Map<String, SacredLocation> _locationsById = {};
  final List<PreparationItem> _preparationItems = [];

  bool get isMounted => _activePackage != null;
  CanonicalHajjPackage? get activePackage => _activePackage;

  Result<void, Failure> mountPackage(CanonicalHajjPackage package) {
    if (!package.verifyIntegrity()) {
      return Result.err(
        const ContentIntegrityFailure(message: 'Canonical Hajj package failed cryptographic integrity check.'),
      );
    }

    _activePackage = package;
    _stepsById.clear();
    _miqatsById.clear();
    _locationsById.clear();
    _preparationItems.clear();

    for (final s in package.steps) {
      _stepsById[s.stepId] = s;
    }
    for (final m in package.miqats) {
      _miqatsById[m.miqatId] = m;
    }
    for (final l in package.locations) {
      _locationsById[l.locationId] = l;
    }
    _preparationItems.addAll(package.preparationItems);

    return Result.ok(null);
  }

  void unmount() {
    _activePackage = null;
    _stepsById.clear();
    _miqatsById.clear();
    _locationsById.clear();
    _preparationItems.clear();
  }

  Result<List<RitualStep>, Failure> getStepsForJourney(JourneyType type) {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    final steps = _stepsById.values.where((s) => s.journeyType == type).toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    return Result.ok(List.unmodifiable(steps));
  }

  Result<List<RitualStep>, Failure> getStepsForPhase(JourneyType type, RitualPhase phase) {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    final steps = _stepsById.values.where((s) => s.journeyType == type && s.phase == phase).toList()
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    return Result.ok(List.unmodifiable(steps));
  }

  Result<RitualStep, Failure> getStep(String stepId) {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    final s = _stepsById[stepId];
    if (s == null) {
      return Result.err(ContentNotFoundFailure(message: 'Ritual step not found: $stepId'));
    }
    return Result.ok(s);
  }

  Result<List<Miqat>, Failure> getAllMiqats() {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    return Result.ok(List.unmodifiable(_miqatsById.values.toList()));
  }

  Result<Miqat, Failure> getMiqat(String miqatId) {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    final m = _miqatsById[miqatId];
    if (m == null) {
      return Result.err(ContentNotFoundFailure(message: 'Miqat not found: $miqatId'));
    }
    return Result.ok(m);
  }

  Result<List<SacredLocation>, Failure> getAllLocations() {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    return Result.ok(List.unmodifiable(_locationsById.values.toList()));
  }

  Result<SacredLocation, Failure> getLocation(String locationId) {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    final l = _locationsById[locationId];
    if (l == null) {
      return Result.err(ContentNotFoundFailure(message: 'Location not found: $locationId'));
    }
    return Result.ok(l);
  }

  Result<List<PreparationItem>, Failure> getPreparationItems() {
    if (!isMounted) {
      return Result.err(const ContentNotFoundFailure(message: 'Hajj store is not mounted.'));
    }
    return Result.ok(List.unmodifiable(_preparationItems));
  }
}
