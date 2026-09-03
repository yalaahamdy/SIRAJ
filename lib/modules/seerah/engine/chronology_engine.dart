import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/historical_date.dart';
import '../domain/seerah_event.dart';
import '../store/read_only_seerah_store.dart';

/// Engine responsible for chronology verification, temporal sanity checks, and contradiction detection (§6, §22).
class ChronologyEngine {
  final ReadOnlySeerahStore _store;

  const ChronologyEngine({required ReadOnlySeerahStore store}) : _store = store;

  /// Checks if a given event has any temporal contradictions with its participants.
  Result<bool, Failure> validateEventChronology(SeerahEvent event) {
    final eventYear = event.historicalDate.hijriYear;
    if (eventYear == null) return Result.ok(true);

    for (final personId in event.participantIds) {
      final personRes = _store.getPerson(personId);
      if (personRes.isFailure) continue;

      final person = personRes.valueOrNull!;

      // 1. Check Birth Date: Event cannot happen before participant's birth
      if (person.birthDate?.hijriYear != null) {
        if (_isYearBefore(event.historicalDate, person.birthDate!)) {
          return Result.err(
            ConfigFailure(
              message: 'Chronological contradiction: Event "${event.title}" occurred before birth of participant "${person.canonicalName}".',
            ),
          );
        }
      }

      // 2. Check Death Date: Event cannot happen after participant's death
      if (person.deathDate?.hijriYear != null) {
        if (_isYearAfter(event.historicalDate, person.deathDate!)) {
          return Result.err(
            ConfigFailure(
              message: 'Chronological contradiction: Event "${event.title}" occurred after death of participant "${person.canonicalName}".',
            ),
          );
        }
      }
    }

    return Result.ok(true);
  }

  /// Verifies all events in the store for chronological contradictions.
  Result<bool, Failure> validateAllChronology() {
    final eventsRes = _store.getAllEvents();
    if (eventsRes.isFailure) return Result.ok(true);

    for (final event in eventsRes.valueOrNull!) {
      final res = validateEventChronology(event);
      if (res.isFailure) return res;
    }
    return Result.ok(true);
  }

  bool _isYearBefore(HistoricalDate eventDate, HistoricalDate birthDate) {
    final ey = eventDate.isBeforeHijrah ? -1 * (eventDate.hijriYear ?? 0) : (eventDate.hijriYear ?? 0);
    final by = birthDate.isBeforeHijrah ? -1 * (birthDate.hijriYear ?? 0) : (birthDate.hijriYear ?? 0);
    return ey < by;
  }

  bool _isYearAfter(HistoricalDate eventDate, HistoricalDate deathDate) {
    final ey = eventDate.isBeforeHijrah ? -1 * (eventDate.hijriYear ?? 0) : (eventDate.hijriYear ?? 0);
    final dy = deathDate.isBeforeHijrah ? -1 * (deathDate.hijriYear ?? 0) : (deathDate.hijriYear ?? 0);
    return ey > dy;
  }
}
