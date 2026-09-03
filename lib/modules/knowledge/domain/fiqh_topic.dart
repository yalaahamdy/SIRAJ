import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'fiqh_position.dart';

/// Structured Fiqh topic encompassing multiple school positions and evidences (§13, §14).
class FiqhTopic extends Equatable {
  final String topicId;
  final String title;
  final String summary;
  final String category;
  final List<FiqhPosition> positions;
  final String reviewState;
  final String integrityHash;

  const FiqhTopic({
    required this.topicId,
    required this.title,
    required this.summary,
    required this.category,
    required this.positions,
    this.reviewState = 'APPROVED',
    required this.integrityHash,
  });

  factory FiqhTopic.create({
    required String topicId,
    required String title,
    required String summary,
    required String category,
    required List<FiqhPosition> positions,
    String reviewState = 'APPROVED',
  }) {
    final positionsPayload = positions.map((p) => p.integrityHash).join(';');
    final payload = '$topicId|$title|$summary|$category|$positionsPayload|$reviewState';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return FiqhTopic(
      topicId: topicId,
      title: title,
      summary: summary,
      category: category,
      positions: positions,
      reviewState: reviewState,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final positionsPayload = positions.map((p) => p.integrityHash).join(';');
    final payload = '$topicId|$title|$summary|$category|$positionsPayload|$reviewState';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'topic_id': topicId,
      'title': title,
      'summary': summary,
      'category': category,
      'positions': positions.map((p) => p.toMap()).toList(),
      'review_state': reviewState,
      'integrity_hash': integrityHash,
    };
  }

  factory FiqhTopic.fromMap(Map<String, dynamic> map) {
    final rawPositions = map['positions'] as List<dynamic>? ?? [];
    final positions = rawPositions.map((p) => FiqhPosition.fromMap(p as Map<String, dynamic>)).toList();

    return FiqhTopic(
      topicId: map['topic_id'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String,
      category: map['category'] as String,
      positions: positions,
      reviewState: map['review_state'] as String? ?? 'APPROVED',
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        topicId,
        title,
        summary,
        category,
        positions,
        reviewState,
        integrityHash,
      ];
}
