import '../../domain/unified_message.dart';
import '../../ops/bot_operations_platform.dart';
import '../metrics/pilot_metrics_collector.dart';
import '../models/pilot_persona.dart';

/// Orchestrates the execution of real-world controlled pilot scenarios across personas (§2, §4, §59).
class PilotCohortRunner {
  final BotOperationsPlatform operationsPlatform;
  final PilotMetricsCollector metricsCollector = PilotMetricsCollector();

  PilotCohortRunner({required this.operationsPlatform}) {
    // Automatically enroll standard cohort into the Staging Allowlist (§2, §47)
    for (final persona in PilotPersona.getStandardCohort()) {
      operationsPlatform.stagingAllowlist.addAllowedUser(persona.testerId);
    }
  }

  /// Executes a single persona conversation step and records metrics (§4, §31).
  Future<UnifiedBotResponse> runPersonaStep({
    required PilotPersona persona,
    required String text,
    String? callbackPayload,
  }) async {
    final stopwatch = Stopwatch()..start();
    final msg = UnifiedIncomingMessage(
      messageId: 'pilot_msg_${DateTime.now().millisecondsSinceEpoch}',
      channel: persona.channel,
      externalUserId: persona.testerId,
      text: text,
      callbackPayload: callbackPayload,
      timestamp: DateTime.now().toUtc(),
    );

    try {
      final response = await operationsPlatform.processStagingMessage(msg);
      stopwatch.stop();

      metricsCollector.recordExecution(
        isSuccess: true,
        isAbstained: response.isAbstained,
        isBlocked: false,
        latencyMs: stopwatch.elapsedMilliseconds,
      );

      return response;
    } catch (e) {
      stopwatch.stop();

      metricsCollector.recordExecution(
        isSuccess: false,
        isAbstained: false,
        isBlocked: true,
        latencyMs: stopwatch.elapsedMilliseconds,
      );

      rethrow;
    }
  }
}
