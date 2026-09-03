import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/historical_period.dart';
import '../domain/seerah_event.dart';
import '../store/read_only_seerah_store.dart';

/// Structured timeline slice grouped by Period (§20, §21).
class PeriodTimelineSlice {
  final HistoricalPeriod period;
  final List<SeerahEvent> events;

  const PeriodTimelineSlice({
    required this.period,
    required this.events,
  });
}

/// Engine managing chronological event sequencing and timeline presentation (§20, §21).
class SeerahTimelineEngine {
  final ReadOnlySeerahStore _store;

  const SeerahTimelineEngine({required ReadOnlySeerahStore store}) : _store = store;

  /// Retrieves the complete sequenced timeline grouped by historical periods.
  Result<List<PeriodTimelineSlice>, Failure> getSequencedTimeline() {
    final periodsRes = _store.getAllPeriods();
    if (periodsRes.isFailure) return Result.err(periodsRes.failureOrNull!);

    final periods = periodsRes.valueOrNull!;
    final slices = <PeriodTimelineSlice>[];

    for (final period in periods) {
      final eventsRes = _store.getEventsByPeriod(period.periodId);
      final events = eventsRes.isSuccess ? List<SeerahEvent>.from(eventsRes.valueOrNull!) : <SeerahEvent>[];

      // Sort events within period: Before Hijrah (descending distance to Hijrah) -> After Hijrah (ascending)
      events.sort((a, b) {
        final ay = a.historicalDate.isBeforeHijrah ? -1 * (a.historicalDate.hijriYear ?? 0) : (a.historicalDate.hijriYear ?? 0);
        final by = b.historicalDate.isBeforeHijrah ? -1 * (b.historicalDate.hijriYear ?? 0) : (b.historicalDate.hijriYear ?? 0);
        if (ay != by) return ay.compareTo(by);

        final am = a.historicalDate.hijriMonth ?? 0;
        final bm = b.historicalDate.hijriMonth ?? 0;
        if (am != bm) return am.compareTo(bm);

        final ad = a.historicalDate.hijriDay ?? 0;
        final bd = b.historicalDate.hijriDay ?? 0;
        return ad.compareTo(bd);
      });

      slices.add(PeriodTimelineSlice(period: period, events: events));
    }

    return Result.ok(slices);
  }
}
