/// Security Event Types (§37).
enum SecurityEventType {
  invalidSignature,
  replayDetected,
  authFailure,
  toolDenied,
  confirmationFailure,
  accountLinkFailure,
  rateLimit,
  suspiciousCallback,
  blockedUserAttempt,
  killSwitchTriggered,
}

class SecurityEventRecord {
  final String eventId;
  final SecurityEventType type;
  final String sourceChannel;
  final String maskedIdentifier;
  final String details;
  final DateTime timestamp;

  SecurityEventRecord({
    required this.eventId,
    required this.type,
    required this.sourceChannel,
    required this.maskedIdentifier,
    required this.details,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'type': type.name,
      'source_channel': sourceChannel,
      'masked_identifier': maskedIdentifier,
      'details': details,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// In-memory security audit log recorder for operational security review (§37, §38).
class SecurityEventLogger {
  final List<SecurityEventRecord> _events = [];

  List<SecurityEventRecord> get events => List.unmodifiable(_events);

  void logEvent({
    required SecurityEventType type,
    required String sourceChannel,
    required String identifier,
    required String details,
  }) {
    // Mask identifier before recording (§38)
    final masked = identifier.length > 4
        ? '${identifier.substring(0, 2)}***${identifier.substring(identifier.length - 2)}'
        : '***';

    _events.add(SecurityEventRecord(
      eventId: 'sec_ev_${DateTime.now().millisecondsSinceEpoch}_${_events.length}',
      type: type,
      sourceChannel: sourceChannel,
      maskedIdentifier: masked,
      details: details,
      timestamp: DateTime.now().toUtc(),
    ));
  }

  void clear() {
    _events.clear();
  }
}
