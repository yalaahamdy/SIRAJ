import 'journey_type.dart';

/// User Journey State Machine (§20).
enum JourneyState {
  notStarted('لم تبدأ بعد'),
  preparing('مرحلة الاستعداد'),
  inIhram('مُحْرِم'),
  inProgress('أثناء أداء النسك'),
  paused('متوقفة مؤقتاً'),
  completed('مكتملة');

  final String labelArabic;
  const JourneyState(this.labelArabic);
}

/// Local-First User Hajj/Umrah Progress and Checkpoints (§21, §24, §37).
class HajjUserProgress {
  final JourneyType activeJourneyType;
  final JourneyState journeyState;
  final Set<String> completedStepIds;
  final Set<String> checkedPreparationItemIds;
  final Map<String, String> userNotes; // stepId -> personal user note
  final String? selectedMiqatId;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const HajjUserProgress({
    this.activeJourneyType = JourneyType.umrah,
    this.journeyState = JourneyState.notStarted,
    this.completedStepIds = const {},
    this.checkedPreparationItemIds = const {},
    this.userNotes = const {},
    this.selectedMiqatId,
    this.startedAt,
    this.completedAt,
  });

  HajjUserProgress copyWith({
    JourneyType? activeJourneyType,
    JourneyState? journeyState,
    Set<String>? completedStepIds,
    Set<String>? checkedPreparationItemIds,
    Map<String, String>? userNotes,
    String? selectedMiqatId,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return HajjUserProgress(
      activeJourneyType: activeJourneyType ?? this.activeJourneyType,
      journeyState: journeyState ?? this.journeyState,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      checkedPreparationItemIds: checkedPreparationItemIds ?? this.checkedPreparationItemIds,
      userNotes: userNotes ?? this.userNotes,
      selectedMiqatId: selectedMiqatId ?? this.selectedMiqatId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'activeJourneyType': activeJourneyType.name,
        'journeyState': journeyState.name,
        'completedStepIds': completedStepIds.toList(),
        'checkedPreparationItemIds': checkedPreparationItemIds.toList(),
        'userNotes': userNotes,
        if (selectedMiqatId != null) 'selectedMiqatId': selectedMiqatId,
        if (startedAt != null) 'startedAt': startedAt!.toIso8601String(),
        if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
      };

  factory HajjUserProgress.fromJson(Map<String, dynamic> json) => HajjUserProgress(
        activeJourneyType: JourneyType.values.firstWhere(
          (e) => e.name == json['activeJourneyType'],
          orElse: () => JourneyType.umrah,
        ),
        journeyState: JourneyState.values.firstWhere(
          (e) => e.name == json['journeyState'],
          orElse: () => JourneyState.notStarted,
        ),
        completedStepIds: (json['completedStepIds'] as List<dynamic>?)?.map((e) => e as String).toSet() ?? const {},
        checkedPreparationItemIds: (json['checkedPreparationItemIds'] as List<dynamic>?)?.map((e) => e as String).toSet() ?? const {},
        userNotes: (json['userNotes'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as String)) ?? const {},
        selectedMiqatId: json['selectedMiqatId'] as String?,
        startedAt: json['startedAt'] != null ? DateTime.tryParse(json['startedAt'] as String) : null,
        completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt'] as String) : null,
      );
}
