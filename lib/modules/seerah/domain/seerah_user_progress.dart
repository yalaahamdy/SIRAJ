import 'package:equatable/equatable.dart';

/// User's isolated, local Seerah reading and interaction history (§33, §35).
class SeerahUserProgress extends Equatable {
  final Set<String> viewedEventIds;
  final Set<String> bookmarkedEventIds;
  final Map<String, String> userNotes; // eventId -> user personal reflection/note
  final String? lastViewedEventId;
  final DateTime updatedAt;

  const SeerahUserProgress({
    this.viewedEventIds = const {},
    this.bookmarkedEventIds = const {},
    this.userNotes = const {},
    this.lastViewedEventId,
    required this.updatedAt,
  });

  SeerahUserProgress copyWith({
    Set<String>? viewedEventIds,
    Set<String>? bookmarkedEventIds,
    Map<String, String>? userNotes,
    String? lastViewedEventId,
    DateTime? updatedAt,
  }) {
    return SeerahUserProgress(
      viewedEventIds: viewedEventIds ?? this.viewedEventIds,
      bookmarkedEventIds: bookmarkedEventIds ?? this.bookmarkedEventIds,
      userNotes: userNotes ?? this.userNotes,
      lastViewedEventId: lastViewedEventId ?? this.lastViewedEventId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'viewed_event_ids': viewedEventIds.toList(),
      'bookmarked_event_ids': bookmarkedEventIds.toList(),
      'user_notes': userNotes,
      'last_viewed_event_id': lastViewedEventId,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory SeerahUserProgress.fromMap(Map<String, dynamic> map) {
    final rawViewed = map['viewed_event_ids'] as List<dynamic>? ?? [];
    final rawBookmarks = map['bookmarked_event_ids'] as List<dynamic>? ?? [];
    final rawNotes = map['user_notes'] as Map<String, dynamic>? ?? {};

    return SeerahUserProgress(
      viewedEventIds: rawViewed.map((e) => e.toString()).toSet(),
      bookmarkedEventIds: rawBookmarks.map((e) => e.toString()).toSet(),
      userNotes: rawNotes.map((k, v) => MapEntry(k, v.toString())),
      lastViewedEventId: map['last_viewed_event_id'] as String?,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        viewedEventIds,
        bookmarkedEventIds,
        userNotes,
        lastViewedEventId,
        updatedAt,
      ];
}
