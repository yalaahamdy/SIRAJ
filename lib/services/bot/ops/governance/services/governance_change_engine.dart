import 'dart:math';
import '../models/governed_change_proposal.dart';

/// Engine managing governed change proposals, approvals, and blast radius control (§3, §4, §5, §6, §8).
class GovernanceChangeEngine {
  final Map<String, GovernedChangeProposal> _proposals = {};

  List<GovernedChangeProposal> get proposals => _proposals.values.toList();

  /// Submits a new governed change proposal (§3, §4).
  GovernedChangeProposal proposeChange({
    required String titleArabic,
    required String descriptionArabic,
    required String changeType,
    required ChangeRiskLevel riskLevel,
    required String owner,
    required List<String> affectedModules,
    required String blastRadiusDescriptionArabic,
    required String rollbackStrategyArabic,
  }) {
    final proposalId = 'chg_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';

    final proposal = GovernedChangeProposal(
      proposalId: proposalId,
      titleArabic: titleArabic,
      descriptionArabic: descriptionArabic,
      changeType: changeType,
      riskLevel: riskLevel,
      owner: owner,
      affectedModules: affectedModules,
      blastRadiusDescriptionArabic: blastRadiusDescriptionArabic,
      rollbackStrategyArabic: rollbackStrategyArabic,
      status: ChangeProposalStatus.proposed,
      createdAt: DateTime.now(),
    );

    _proposals[proposalId] = proposal;
    return proposal;
  }

  /// Reviews and approves a proposal with explicit reviewer identity (§3, §5).
  bool approveChangeProposal({
    required String proposalId,
    required String reviewerName,
  }) {
    final existing = _proposals[proposalId];
    if (existing == null) return false;

    final updatedApprovers = List<String>.from(existing.approvedBy)..add(reviewerName);

    // Critical changes require at least 2 distinct approvers
    ChangeProposalStatus newStatus = existing.status;
    if (existing.riskLevel == ChangeRiskLevel.critical) {
      if (updatedApprovers.length >= 2) {
        newStatus = ChangeProposalStatus.approved;
      } else {
        newStatus = ChangeProposalStatus.underReview;
      }
    } else {
      newStatus = ChangeProposalStatus.approved;
    }

    final updated = existing.copyWith(
      status: newStatus,
      approvedBy: updatedApprovers,
      approvedAt: newStatus == ChangeProposalStatus.approved ? DateTime.now() : null,
    );

    _proposals[proposalId] = updated;
    return true;
  }

  /// Retrieves a proposal by ID.
  GovernedChangeProposal? getProposal(String proposalId) => _proposals[proposalId];
}
