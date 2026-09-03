import 'package:equatable/equatable.dart';

/// States of a feature lifecycle (§9, §10, §11).
enum FeatureState {
  proposed,
  experimental,
  beta,
  stable,
  deprecated,
  removed,
}

/// Structured Feature Lifecycle & Ownership Record (§9, §10, §11).
class FeatureLifecycleRecord extends Equatable {
  final String featureKey;
  final String nameArabic;
  final String owner;
  final FeatureState state;
  final String associatedModule;
  final DateTime introducedAt;
  final DateTime? deprecatedAt;
  final String? deprecationMigrationGuideArabic;

  const FeatureLifecycleRecord({
    required this.featureKey,
    required this.nameArabic,
    required this.owner,
    required this.state,
    required this.associatedModule,
    required this.introducedAt,
    this.deprecatedAt,
    this.deprecationMigrationGuideArabic,
  });

  bool get isActive =>
      state == FeatureState.experimental ||
      state == FeatureState.beta ||
      state == FeatureState.stable;

  FeatureLifecycleRecord copyWith({
    String? featureKey,
    String? nameArabic,
    String? owner,
    FeatureState? state,
    String? associatedModule,
    DateTime? introducedAt,
    DateTime? deprecatedAt,
    String? deprecationMigrationGuideArabic,
  }) {
    return FeatureLifecycleRecord(
      featureKey: featureKey ?? this.featureKey,
      nameArabic: nameArabic ?? this.nameArabic,
      owner: owner ?? this.owner,
      state: state ?? this.state,
      associatedModule: associatedModule ?? this.associatedModule,
      introducedAt: introducedAt ?? this.introducedAt,
      deprecatedAt: deprecatedAt ?? this.deprecatedAt,
      deprecationMigrationGuideArabic: deprecationMigrationGuideArabic ?? this.deprecationMigrationGuideArabic,
    );
  }

  @override
  List<Object?> get props => [
        featureKey,
        nameArabic,
        owner,
        state,
        associatedModule,
        introducedAt,
        deprecatedAt,
        deprecationMigrationGuideArabic,
      ];
}
