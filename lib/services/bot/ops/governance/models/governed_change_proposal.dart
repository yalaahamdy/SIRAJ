import 'package:equatable/equatable.dart';

/// Risk level classification of a governed change proposal (§4, §5).
enum ChangeRiskLevel {
  low,
  medium,
  high,
  critical,
}

/// Status of a governed change proposal (§3, §5).
enum ChangeProposalStatus {
  proposed,
  underReview,
  approved,
  rejected,
  implemented,
  verified,
  rolledBack,
}

/// Structured Governed Change Proposal object (§3, §4, §5, §6, §8, §72).
class GovernedChangeProposal extends Equatable {
  final String proposalId;
  final String titleArabic;
  final String descriptionArabic;
  final String changeType;
  final ChangeRiskLevel riskLevel;
  final String owner;
  final List<String> affectedModules;
  final String blastRadiusDescriptionArabic;
  final String rollbackStrategyArabic;
  final ChangeProposalStatus status;
  final List<String> approvedBy;
  final DateTime createdAt;
  final DateTime? approvedAt;
  final Map<String, dynamic> metadata;

  const GovernedChangeProposal({
    required this.proposalId,
    required this.titleArabic,
    required this.descriptionArabic,
    required this.changeType,
    required this.riskLevel,
    required this.owner,
    required this.affectedModules,
    required this.blastRadiusDescriptionArabic,
    required this.rollbackStrategyArabic,
    this.status = ChangeProposalStatus.proposed,
    this.approvedBy = const [],
    required this.createdAt,
    this.approvedAt,
    this.metadata = const {},
  });

  bool get isApproved =>
      status == ChangeProposalStatus.approved ||
      status == ChangeProposalStatus.implemented ||
      status == ChangeProposalStatus.verified;

  GovernedChangeProposal copyWith({
    String? proposalId,
    String? titleArabic,
    String? descriptionArabic,
    String? changeType,
    ChangeRiskLevel? riskLevel,
    String? owner,
    List<String>? affectedModules,
    String? blastRadiusDescriptionArabic,
    String? rollbackStrategyArabic,
    ChangeProposalStatus? status,
    List<String>? approvedBy,
    DateTime? createdAt,
    DateTime? approvedAt,
    Map<String, dynamic>? metadata,
  }) {
    return GovernedChangeProposal(
      proposalId: proposalId ?? this.proposalId,
      titleArabic: titleArabic ?? this.titleArabic,
      descriptionArabic: descriptionArabic ?? this.descriptionArabic,
      changeType: changeType ?? this.changeType,
      riskLevel: riskLevel ?? this.riskLevel,
      owner: owner ?? this.owner,
      affectedModules: affectedModules ?? this.affectedModules,
      blastRadiusDescriptionArabic: blastRadiusDescriptionArabic ?? this.blastRadiusDescriptionArabic,
      rollbackStrategyArabic: rollbackStrategyArabic ?? this.rollbackStrategyArabic,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        proposalId,
        titleArabic,
        descriptionArabic,
        changeType,
        riskLevel,
        owner,
        affectedModules,
        blastRadiusDescriptionArabic,
        rollbackStrategyArabic,
        status,
        approvedBy,
        createdAt,
        approvedAt,
        metadata,
      ];
}
