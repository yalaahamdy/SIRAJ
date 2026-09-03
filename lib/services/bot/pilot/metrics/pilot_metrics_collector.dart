import 'dart:math';

/// Collects and aggregates real-world pilot quality, latency, and completion metrics (§31, §57).
class PilotMetricsCollector {
  int totalTasksAttempted = 0;
  int totalTasksCompleted = 0;
  int totalAbstentions = 0;
  int totalSafetyBlocks = 0;
  final List<int> _latencySamplesMs = [];

  void recordExecution({
    required bool isSuccess,
    required bool isAbstained,
    required bool isBlocked,
    required int latencyMs,
  }) {
    totalTasksAttempted++;
    if (isSuccess) totalTasksCompleted++;
    if (isAbstained) totalAbstentions++;
    if (isBlocked) totalSafetyBlocks++;
    _latencySamplesMs.add(latencyMs);
  }

  double get taskCompletionRate =>
      totalTasksAttempted > 0 ? totalTasksCompleted / totalTasksAttempted : 0.0;

  int getPercentileLatency(int percentile) {
    if (_latencySamplesMs.isEmpty) return 0;
    final sorted = List<int>.from(_latencySamplesMs)..sort();
    final index = ((percentile / 100.0) * (sorted.length - 1)).round();
    return sorted[min(index, sorted.length - 1)];
  }

  int get p50Latency => getPercentileLatency(50);
  int get p95Latency => getPercentileLatency(95);
  int get p99Latency => getPercentileLatency(99);

  Map<String, dynamic> generateReport() {
    return {
      'total_tasks_attempted': totalTasksAttempted,
      'total_tasks_completed': totalTasksCompleted,
      'task_completion_rate': taskCompletionRate,
      'total_abstentions': totalAbstentions,
      'total_safety_blocks': totalSafetyBlocks,
      'p50_latency_ms': p50Latency,
      'p95_latency_ms': p95Latency,
      'p99_latency_ms': p99Latency,
    };
  }
}
