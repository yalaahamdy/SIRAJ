import 'package:equatable/equatable.dart';
import 'unified_message.dart';

/// Anonymous, privacy-preserving audit record for bot transactions (§50, §51).
class BotAuditRecord extends Equatable {
  final String requestId;
  final String traceId;
  final String sessionId;
  final ChannelType channel;
  final String commandOrIntent;
  final List<String> toolsUsed;
  final int evidenceCount;
  final bool isAbstained;
  final bool requiresConfirmation;
  final String responseStatus;
  final DateTime timestamp;

  const BotAuditRecord({
    required this.requestId,
    required this.traceId,
    required this.sessionId,
    required this.channel,
    required this.commandOrIntent,
    required this.toolsUsed,
    required this.evidenceCount,
    required this.isAbstained,
    required this.requiresConfirmation,
    required this.responseStatus,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'trace_id': traceId,
      'session_id': sessionId,
      'channel': channel.name,
      'command_or_intent': commandOrIntent,
      'tools_used': toolsUsed,
      'evidence_count': evidenceCount,
      'is_abstained': isAbstained,
      'requires_confirmation': requiresConfirmation,
      'response_status': responseStatus,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        requestId,
        traceId,
        sessionId,
        channel,
        commandOrIntent,
        toolsUsed,
        evidenceCount,
        isAbstained,
        requiresConfirmation,
        responseStatus,
        timestamp,
      ];
}
