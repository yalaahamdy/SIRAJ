import '../../domain/unified_message.dart';

class ChannelHealthStats {
  final ChannelType channel;
  int inboundEvents = 0;
  int processedEvents = 0;
  int errorEvents = 0;
  DateTime? lastInboundAt;
  DateTime? lastProcessedAt;
  DateTime? lastErrorAt;

  ChannelHealthStats({required this.channel});

  double get errorRate => inboundEvents > 0 ? errorEvents / inboundEvents : 0.0;
}

/// Gathers and exposes operational health and latency telemetry per channel (§9).
class ChannelHealthService {
  final Map<ChannelType, ChannelHealthStats> _stats = {};

  ChannelHealthService() {
    for (final channel in ChannelType.values) {
      _stats[channel] = ChannelHealthStats(channel: channel);
    }
  }

  void recordInboundEvent(ChannelType channel) {
    final s = _stats[channel];
    if (s != null) {
      s.inboundEvents++;
      s.lastInboundAt = DateTime.now().toUtc();
    }
  }

  void recordProcessedEvent(ChannelType channel) {
    final s = _stats[channel];
    if (s != null) {
      s.processedEvents++;
      s.lastProcessedAt = DateTime.now().toUtc();
    }
  }

  void recordError(ChannelType channel) {
    final s = _stats[channel];
    if (s != null) {
      s.errorEvents++;
      s.lastErrorAt = DateTime.now().toUtc();
    }
  }

  Map<String, dynamic> getHealthSummary() {
    final Map<String, dynamic> summary = {};
    for (final entry in _stats.entries) {
      summary[entry.key.name] = {
        'inbound_events': entry.value.inboundEvents,
        'processed_events': entry.value.processedEvents,
        'error_events': entry.value.errorEvents,
        'error_rate': entry.value.errorRate,
        'last_inbound_at': entry.value.lastInboundAt?.toIso8601String(),
        'last_processed_at': entry.value.lastProcessedAt?.toIso8601String(),
      };
    }
    return summary;
  }
}
