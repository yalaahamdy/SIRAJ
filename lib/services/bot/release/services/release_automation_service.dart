import '../models/production_release_record.dart';
import 'canary_rollout_manager.dart';

/// Release automation engine managing state machine transitions and safe rollout (§4, §5, §20).
class ReleaseAutomationService {
  final Map<String, ProductionReleaseRecord> _releases = {};
  final CanaryRolloutManager _canaryManager;
  String? _activeProductionReleaseId;

  ReleaseAutomationService({
    CanaryRolloutManager? canaryManager,
  }) : _canaryManager = canaryManager ?? CanaryRolloutManager();

  CanaryRolloutManager get canaryManager => _canaryManager;
  String? get activeProductionReleaseId => _activeProductionReleaseId;

  /// Registers a release candidate.
  void registerRelease(ProductionReleaseRecord release) {
    _releases[release.releaseId] = release;
  }

  /// Retrieves a release by ID.
  ProductionReleaseRecord? getRelease(String releaseId) => _releases[releaseId];

  /// Transitions release state safely according to the state machine (§4).
  bool transitionReleaseState({
    required String releaseId,
    required ReleaseLifecycleState targetState,
    String? reasonArabic,
  }) {
    final current = _releases[releaseId];
    if (current == null) return false;

    // Enforce valid transitions
    if (targetState == ReleaseLifecycleState.production) {
      if (current.releaseState != ReleaseLifecycleState.approvedForRelease) {
        return false; // Cannot jump to production without explicit external approval
      }
    }

    final updated = current.copyWith(
      releaseState: targetState,
      metadata: {
        ...current.metadata,
        'last_transition': targetState.name,
        'transition_reason': reasonArabic ?? '',
        'transition_timestamp': DateTime.now().toIso8601String(),
      },
    );

    _releases[releaseId] = updated;

    if (targetState == ReleaseLifecycleState.production) {
      _activeProductionReleaseId = releaseId;
    }

    return true;
  }

  /// Executes automated rollback to defined rollback target (§22, §54).
  bool executeAutomatedRollback({
    required String releaseId,
    required String reasonArabic,
  }) {
    final current = _releases[releaseId];
    if (current == null) return false;

    final targetId = current.rollbackTarget;
    if (targetId == null || !_releases.containsKey(targetId)) {
      return false;
    }

    // Reset canary traffic
    _canaryManager.reset();

    // Rollback active release
    _activeProductionReleaseId = targetId;

    final rolledBack = current.copyWith(
      releaseState: ReleaseLifecycleState.releaseCandidate,
      metadata: {
        ...current.metadata,
        'rolled_back_to': targetId,
        'rollback_reason': reasonArabic,
        'rollback_timestamp': DateTime.now().toIso8601String(),
      },
    );

    _releases[releaseId] = rolledBack;
    return true;
  }
}
