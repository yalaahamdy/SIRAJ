/// Health status evaluated during canary rollout stages (§20, §21).
enum CanaryHealthStatus {
  healthy,
  degraded,
  unhealthy,
}

/// Action recommendation based on canary health evaluation (§21, §22).
enum CanaryAction {
  advance,
  pause,
  rollback,
}

/// Manager tracking canary rollout stages and automated health evaluation (§20, §21, §22).
class CanaryRolloutManager {
  int _currentTrafficPercentage = 0;
  bool _isPaused = false;
  final double maxErrorRateThreshold;
  final double maxP95LatencyMsThreshold;

  CanaryRolloutManager({
    this.maxErrorRateThreshold = 0.005, // 0.5% max error rate
    this.maxP95LatencyMsThreshold = 100.0, // 100ms max latency
  });

  int get currentTrafficPercentage => _currentTrafficPercentage;
  bool get isPaused => _isPaused;

  /// Evaluates health metrics and determines canary action (§21, §22).
  CanaryAction evaluateCanaryStage({
    required double errorRate,
    required double p95LatencyMs,
    required bool hasSecurityEvents,
  }) {
    if (hasSecurityEvents || errorRate > maxErrorRateThreshold * 2) {
      _isPaused = true;
      return CanaryAction.rollback;
    }

    if (errorRate > maxErrorRateThreshold || p95LatencyMs > maxP95LatencyMsThreshold) {
      _isPaused = true;
      return CanaryAction.pause;
    }

    _isPaused = false;
    return CanaryAction.advance;
  }

  /// Advances traffic percentage to next defined stage (0% -> 5% -> 25% -> 50% -> 100%) (§20).
  bool advanceStage() {
    if (_isPaused) return false;

    if (_currentTrafficPercentage == 0) {
      _currentTrafficPercentage = 5;
    } else if (_currentTrafficPercentage == 5) {
      _currentTrafficPercentage = 25;
    } else if (_currentTrafficPercentage == 25) {
      _currentTrafficPercentage = 50;
    } else if (_currentTrafficPercentage == 50) {
      _currentTrafficPercentage = 100;
    } else {
      return false;
    }
    return true;
  }

  /// Resets or pauses canary rollout.
  void pause() {
    _isPaused = true;
  }

  /// Resets traffic to 0% upon rollback.
  void reset() {
    _currentTrafficPercentage = 0;
    _isPaused = false;
  }
}
