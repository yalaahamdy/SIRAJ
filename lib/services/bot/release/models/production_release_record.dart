import 'package:equatable/equatable.dart';

/// The 8 states of the release lifecycle state machine (§4).
enum ReleaseLifecycleState {
  development,
  tested,
  staging,
  pilot,
  releaseCandidate,
  technicallyReady,
  externalApprovalPending,
  approvedForRelease,
  production,
}

/// Structured production release record (§5).
class ProductionReleaseRecord extends Equatable {
  final String releaseId;
  final String codeVersion;
  final String contentManifestVersion;
  final String policyVersion;
  final String modelVersion;
  final String configVersion;
  final String artifactHashSha256;
  final String technicalStatus;
  final String humanApprovalStatus;
  final ReleaseLifecycleState releaseState;
  final DateTime createdAt;
  final DateTime? activatedAt;
  final String? rollbackTarget;
  final Map<String, dynamic> metadata;

  const ProductionReleaseRecord({
    required this.releaseId,
    required this.codeVersion,
    required this.contentManifestVersion,
    required this.policyVersion,
    required this.modelVersion,
    required this.configVersion,
    required this.artifactHashSha256,
    required this.technicalStatus,
    required this.humanApprovalStatus,
    required this.releaseState,
    required this.createdAt,
    this.activatedAt,
    this.rollbackTarget,
    this.metadata = const {},
  });

  bool get isTechnicallyReady =>
      releaseState == ReleaseLifecycleState.technicallyReady ||
      releaseState == ReleaseLifecycleState.externalApprovalPending ||
      releaseState == ReleaseLifecycleState.approvedForRelease ||
      releaseState == ReleaseLifecycleState.production;

  bool get isApprovedForRelease =>
      releaseState == ReleaseLifecycleState.approvedForRelease ||
      releaseState == ReleaseLifecycleState.production;

  bool get isProductionActive => releaseState == ReleaseLifecycleState.production;

  ProductionReleaseRecord copyWith({
    String? releaseId,
    String? codeVersion,
    String? contentManifestVersion,
    String? policyVersion,
    String? modelVersion,
    String? configVersion,
    String? artifactHashSha256,
    String? technicalStatus,
    String? humanApprovalStatus,
    ReleaseLifecycleState? releaseState,
    DateTime? createdAt,
    DateTime? activatedAt,
    String? rollbackTarget,
    Map<String, dynamic>? metadata,
  }) {
    return ProductionReleaseRecord(
      releaseId: releaseId ?? this.releaseId,
      codeVersion: codeVersion ?? this.codeVersion,
      contentManifestVersion: contentManifestVersion ?? this.contentManifestVersion,
      policyVersion: policyVersion ?? this.policyVersion,
      modelVersion: modelVersion ?? this.modelVersion,
      configVersion: configVersion ?? this.configVersion,
      artifactHashSha256: artifactHashSha256 ?? this.artifactHashSha256,
      technicalStatus: technicalStatus ?? this.technicalStatus,
      humanApprovalStatus: humanApprovalStatus ?? this.humanApprovalStatus,
      releaseState: releaseState ?? this.releaseState,
      createdAt: createdAt ?? this.createdAt,
      activatedAt: activatedAt ?? this.activatedAt,
      rollbackTarget: rollbackTarget ?? this.rollbackTarget,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        releaseId,
        codeVersion,
        contentManifestVersion,
        policyVersion,
        modelVersion,
        configVersion,
        artifactHashSha256,
        technicalStatus,
        humanApprovalStatus,
        releaseState,
        createdAt,
        activatedAt,
        rollbackTarget,
        metadata,
      ];
}
