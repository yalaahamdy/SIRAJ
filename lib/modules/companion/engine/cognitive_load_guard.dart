import '../domain/companion_preferences.dart';
import '../domain/dashboard_card.dart';

/// Guard protecting the user from cognitive overload and notification fatigue (§32).
class CognitiveLoadGuard {
  const CognitiveLoadGuard();

  /// Limits and refines the list of dashboard cards to prevent cognitive overload.
  List<DashboardCard> guardCards({
    required List<DashboardCard> rawCards,
    required CompanionPreferences preferences,
  }) {
    if (rawCards.isEmpty) return const [];

    final maxCards = preferences.maxDailyCards;

    // Filter out hidden cards
    final visible = rawCards.where((c) => !preferences.hiddenCardIds.contains(c.cardId)).toList();

    // Sort by priority order (ascending, 0 is highest priority)
    visible.sort((a, b) => a.priorityOrder.compareTo(b.priorityOrder));

    // Cap to maximum allowed cards
    if (visible.length <= maxCards) {
      return List.unmodifiable(visible);
    }

    return List.unmodifiable(visible.take(maxCards).toList());
  }
}
