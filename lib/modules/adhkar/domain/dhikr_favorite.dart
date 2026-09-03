import 'package:equatable/equatable.dart';

/// User Favorite bookmark pointing strictly to content ID (§24).
class DhikrFavorite extends Equatable {
  final String contentId;
  final DateTime addedAt;

  const DhikrFavorite({
    required this.contentId,
    required this.addedAt,
  });

  factory DhikrFavorite.fromMap(Map<String, dynamic> map) {
    return DhikrFavorite(
      contentId: map['content_id'] as String,
      addedAt: DateTime.parse(map['added_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content_id': contentId,
      'added_at': addedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [contentId, addedAt];
}
