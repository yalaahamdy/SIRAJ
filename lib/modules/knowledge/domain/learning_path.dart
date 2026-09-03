import 'package:equatable/equatable.dart';

/// Progressive difficulty and depth levels for learning paths (§32).
enum LearningLevel {
  beginner('مبتدئ / تأسيسي'),
  intermediate('متوسط / تأصيلي'),
  advanced('متقدم / استدلالي');

  final String labelArabic;
  const LearningLevel(this.labelArabic);
}

/// Structured foundational learning path model (§32).
class LearningPath extends Equatable {
  final String pathId;
  final String title;
  final String description;
  final LearningLevel level;
  final List<String> itemIds;

  const LearningPath({
    required this.pathId,
    required this.title,
    required this.description,
    required this.level,
    required this.itemIds,
  });

  Map<String, dynamic> toMap() {
    return {
      'path_id': pathId,
      'title': title,
      'description': description,
      'level': level.name,
      'item_ids': itemIds,
    };
  }

  factory LearningPath.fromMap(Map<String, dynamic> map) {
    final rawItemIds = map['item_ids'] as List<dynamic>? ?? [];
    return LearningPath(
      pathId: map['path_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      level: LearningLevel.values.byName(map['level'] as String),
      itemIds: rawItemIds.map((e) => e.toString()).toList(),
    );
  }

  @override
  List<Object?> get props => [pathId, title, description, level, itemIds];
}
