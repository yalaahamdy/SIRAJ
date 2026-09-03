import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'fiqh_option.dart';
import 'journey_type.dart';
import 'ritual_phase.dart';

/// Sourced Ritual Step within Umrah or Hajj journey (§7, §8).
class RitualStep {
  final String stepId;
  final JourneyType journeyType;
  final RitualPhase phase;
  final int sequence;
  final String title;
  final String description;
  final bool isRequired; // True = Pillar/Obligatory, False = Sunnah/Recommended
  final String? locationId;
  final String timeContext;
  final List<FiqhOption> fiqhOptions;
  final List<String> duaAdhkarKeys;
  final List<String> sourceIds;
  final String integrityHash;

  const RitualStep({
    required this.stepId,
    required this.journeyType,
    required this.phase,
    required this.sequence,
    required this.title,
    required this.description,
    required this.isRequired,
    this.locationId,
    required this.timeContext,
    this.fiqhOptions = const [],
    this.duaAdhkarKeys = const [],
    required this.sourceIds,
    required this.integrityHash,
  });

  static String computeHash({
    required String stepId,
    required JourneyType journeyType,
    required RitualPhase phase,
    required int sequence,
    required String title,
    required String description,
    required bool isRequired,
    String? locationId,
    required String timeContext,
    required List<String> sourceIds,
  }) {
    final payload = '$stepId|${journeyType.name}|${phase.name}|$sequence|$title|$description|$isRequired|${locationId ?? ""}|$timeContext|${sourceIds.join(",")}';
    return 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
  }

  factory RitualStep.create({
    required String stepId,
    required JourneyType journeyType,
    required RitualPhase phase,
    required int sequence,
    required String title,
    required String description,
    required bool isRequired,
    String? locationId,
    required String timeContext,
    List<FiqhOption> fiqhOptions = const [],
    List<String> duaAdhkarKeys = const [],
    required List<String> sourceIds,
  }) {
    final hash = computeHash(
      stepId: stepId,
      journeyType: journeyType,
      phase: phase,
      sequence: sequence,
      title: title,
      description: description,
      isRequired: isRequired,
      locationId: locationId,
      timeContext: timeContext,
      sourceIds: sourceIds,
    );
    return RitualStep(
      stepId: stepId,
      journeyType: journeyType,
      phase: phase,
      sequence: sequence,
      title: title,
      description: description,
      isRequired: isRequired,
      locationId: locationId,
      timeContext: timeContext,
      fiqhOptions: List.unmodifiable(fiqhOptions),
      duaAdhkarKeys: List.unmodifiable(duaAdhkarKeys),
      sourceIds: List.unmodifiable(sourceIds),
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    return integrityHash ==
        computeHash(
          stepId: stepId,
          journeyType: journeyType,
          phase: phase,
          sequence: sequence,
          title: title,
          description: description,
          isRequired: isRequired,
          locationId: locationId,
          timeContext: timeContext,
          sourceIds: sourceIds,
        );
  }

  Map<String, dynamic> toJson() => {
        'stepId': stepId,
        'journeyType': journeyType.name,
        'phase': phase.name,
        'sequence': sequence,
        'title': title,
        'description': description,
        'isRequired': isRequired,
        if (locationId != null) 'locationId': locationId,
        'timeContext': timeContext,
        'fiqhOptions': fiqhOptions.map((e) => e.toJson()).toList(),
        'duaAdhkarKeys': duaAdhkarKeys,
        'sourceIds': sourceIds,
        'integrityHash': integrityHash,
      };

  factory RitualStep.fromJson(Map<String, dynamic> json) => RitualStep(
        stepId: json['stepId'] as String,
        journeyType: JourneyType.values.firstWhere((e) => e.name == json['journeyType']),
        phase: RitualPhase.values.firstWhere((e) => e.name == json['phase']),
        sequence: json['sequence'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        isRequired: json['isRequired'] as bool,
        locationId: json['locationId'] as String?,
        timeContext: json['timeContext'] as String,
        fiqhOptions: (json['fiqhOptions'] as List<dynamic>?)?.map((e) => FiqhOption.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
        duaAdhkarKeys: (json['duaAdhkarKeys'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        sourceIds: (json['sourceIds'] as List<dynamic>).map((e) => e as String).toList(),
        integrityHash: json['integrityHash'] as String,
      );
}
