import 'package:equatable/equatable.dart';

/// Execution status of a V1 backlog feature (§44).
enum BacklogItemStatus {
  readyForBuild,
  inProgress,
  testing,
  done,
  blocked,
}

/// Structured V1 Backlog Feature Item (§44, §45).
class V1FeatureBacklogItem extends Equatable {
  final String itemId;
  final String titleArabic;
  final String userValueDescriptionArabic;
  final String associatedModule;
  final String epicId;
  final List<String> dependencies;
  final String riskLevel;
  final List<String> acceptanceCriteriaArabic;
  final BacklogItemStatus status;

  const V1FeatureBacklogItem({
    required this.itemId,
    required this.titleArabic,
    required this.userValueDescriptionArabic,
    required this.associatedModule,
    required this.epicId,
    this.dependencies = const [],
    this.riskLevel = 'LOW',
    this.acceptanceCriteriaArabic = const [],
    this.status = BacklogItemStatus.readyForBuild,
  });

  bool get isDone => status == BacklogItemStatus.done;

  V1FeatureBacklogItem copyWith({
    String? itemId,
    String? titleArabic,
    String? userValueDescriptionArabic,
    String? associatedModule,
    String? epicId,
    List<String>? dependencies,
    String? riskLevel,
    List<String>? acceptanceCriteriaArabic,
    BacklogItemStatus? status,
  }) {
    return V1FeatureBacklogItem(
      itemId: itemId ?? this.itemId,
      titleArabic: titleArabic ?? this.titleArabic,
      userValueDescriptionArabic: userValueDescriptionArabic ?? this.userValueDescriptionArabic,
      associatedModule: associatedModule ?? this.associatedModule,
      epicId: epicId ?? this.epicId,
      dependencies: dependencies ?? this.dependencies,
      riskLevel: riskLevel ?? this.riskLevel,
      acceptanceCriteriaArabic: acceptanceCriteriaArabic ?? this.acceptanceCriteriaArabic,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        titleArabic,
        userValueDescriptionArabic,
        associatedModule,
        epicId,
        dependencies,
        riskLevel,
        acceptanceCriteriaArabic,
        status,
      ];
}
