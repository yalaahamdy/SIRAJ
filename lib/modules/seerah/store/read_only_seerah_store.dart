import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../domain/canonical_seerah_package.dart';
import '../domain/historical_period.dart';
import '../domain/historical_person.dart';
import '../domain/historical_place.dart';
import '../domain/person_relationship.dart';
import '../domain/seerah_event.dart';

/// Read-only canonical repository for Seerah and Islamic history with Fail-Closed security (§28, §29).
class ReadOnlySeerahStore {
  CanonicalSeerahPackage? _activePackage;

  final Map<String, HistoricalPeriod> _periodsById = {};
  final Map<String, SeerahEvent> _eventsById = {};
  final Map<String, List<SeerahEvent>> _eventsByPeriod = {};
  final Map<String, HistoricalPerson> _personsById = {};
  final Map<String, List<PersonRelationship>> _relationshipsByPerson = {};
  final Map<String, HistoricalPlace> _placesById = {};

  final EventBus? _eventBus;

  ReadOnlySeerahStore({EventBus? eventBus}) : _eventBus = eventBus;

  CanonicalSeerahPackage? get activePackage => _activePackage;
  bool get isMounted => _activePackage != null;

  /// Mounts a new [CanonicalSeerahPackage] with strict cryptographic validation.
  Result<void, Failure> mountPackage(CanonicalSeerahPackage package) {
    if (!package.verifyPackageIntegrity()) {
      _eventBus?.publish(
        PackageRejectedEvent(
          packageId: package.packageId,
          reason: 'Cryptographic integrity verification failed for Seerah Package',
        ),
      );
      return Result.err(
        const ContentIntegrityFailure(message: 'Seerah package verification failed: Hash mismatch or untrusted signature'),
      );
    }

    _periodsById.clear();
    _eventsById.clear();
    _eventsByPeriod.clear();
    _personsById.clear();
    _relationshipsByPerson.clear();
    _placesById.clear();

    for (final p in package.periods) {
      _periodsById[p.periodId] = p;
    }

    for (final e in package.events) {
      _eventsById[e.eventId] = e;
      _eventsByPeriod.putIfAbsent(e.periodId, () => []).add(e);
    }

    for (final pr in package.persons) {
      _personsById[pr.personId] = pr;
    }

    for (final r in package.relationships) {
      _relationshipsByPerson.putIfAbsent(r.fromPersonId, () => []).add(r);
      _relationshipsByPerson.putIfAbsent(r.toPersonId, () => []).add(r);
    }

    for (final pl in package.places) {
      _placesById[pl.placeId] = pl;
    }

    _activePackage = package;
    return Result.ok(null);
  }

  Result<HistoricalPeriod, Failure> getPeriod(String periodId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _periodsById[periodId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Period not found: $periodId'));
    return Result.ok(item);
  }

  Result<List<HistoricalPeriod>, Failure> getAllPeriods() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final list = _periodsById.values.toList()..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return Result.ok(list);
  }

  Result<SeerahEvent, Failure> getEvent(String eventId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _eventsById[eventId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Event not found: $eventId'));
    return Result.ok(item);
  }

  Result<List<SeerahEvent>, Failure> getAllEvents() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_eventsById.values.toList());
  }

  Result<List<SeerahEvent>, Failure> getEventsByPeriod(String periodId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_eventsByPeriod[periodId] ?? const []);
  }

  Result<HistoricalPerson, Failure> getPerson(String personId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _personsById[personId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Person not found: $personId'));
    return Result.ok(item);
  }

  Result<List<HistoricalPerson>, Failure> getAllPersons() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_personsById.values.toList());
  }

  Result<List<PersonRelationship>, Failure> getRelationshipsForPerson(String personId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_relationshipsByPerson[personId] ?? const []);
  }

  Result<HistoricalPlace, Failure> getPlace(String placeId) {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    final item = _placesById[placeId];
    if (item == null) return Result.err(ContentNotFoundFailure(message: 'Place not found: $placeId'));
    return Result.ok(item);
  }

  Result<List<HistoricalPlace>, Failure> getAllPlaces() {
    if (!isMounted) return Result.err(const ContentNotFoundFailure(message: 'Store not mounted'));
    return Result.ok(_placesById.values.toList());
  }

  bool verifyIntegrity() {
    if (_activePackage == null) return false;
    return _activePackage!.verifyPackageIntegrity();
  }
}
