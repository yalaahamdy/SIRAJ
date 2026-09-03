import 'package:equatable/equatable.dart';

/// User's isolated personal study progress and local bookmarks (§33, §36).
class KnowledgeUserProgress extends Equatable {
  final Set<String> completedItemIds;
  final Set<String> bookmarkedItemIds;
  final Map<String, String> userNotes; // itemId -> note
  final String? lastReadItemId;
  final DateTime updatedAt;

  const KnowledgeUserProgress({
    this.completedItemIds = const {},
    this.bookmarkedItemIds = const {},
    this.userNotes = const {},
    this.lastReadItemId,
    required this.updatedAt,
  });

  KnowledgeUserProgress copyWith({
    Set<String>? completedItemIds,
    Set<String>? bookmarkedItemIds,
    Map<String, String>? userNotes,
    String? lastReadItemId,
    DateTime? updatedAt,
  }) {
    return KnowledgeUserProgress(
      completedItemIds: completedItemIds ?? this.completedItemIds,
      bookmarkedItemIds: bookmarkedItemIds ?? this.bookmarkedItemIds,
      userNotes: userNotes ?? this.userNotes,
      lastReadItemId: lastReadItemId ?? this.lastReadItemId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completed_item_ids': completedItemIds.toList(),
      'bookmarked_item_ids': bookmarkedItemIds.toList(),
      'user_notes': userNotes,
      'last_read_item_id': lastReadItemId,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory KnowledgeUserProgress.fromMap(Map<String, dynamic> map) {
    final rawCompleted = map['completed_item_ids'] as List<dynamic>? ?? [];
    final rawBookmarks = map['bookmarked_item_ids'] as List<dynamic>? ?? [];
    final rawNotes = map['user_notes'] as Map<String, dynamic>? ?? {};

    return KnowledgeUserProgress(
      completedItemIds: rawCompleted.map((e) => e.toString()).toSet(),
      bookmarkedItemIds: rawBookmarks.map((e) => e.toString()).toSet(),
      userNotes: rawNotes.map((k, v) => MapEntry(k, v.toString())),
      lastReadItemId: map['last_read_item_id'] as String?,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        completedItemIds,
        bookmarkedItemIds,
        userNotes,
        lastReadItemId,
        updatedAt,
      ];
}
