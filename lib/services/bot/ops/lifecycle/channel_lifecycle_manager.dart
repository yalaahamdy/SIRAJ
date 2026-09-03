import '../../domain/unified_message.dart';

/// Operational states for connected bot channels (§5).
enum ChannelLifecycleState {
  registered,
  verifying,
  active,
  degraded,
  disabled,
  error;

  bool get isOperational => this == ChannelLifecycleState.active || this == ChannelLifecycleState.degraded;
}

class ChannelRegistrationInfo {
  final ChannelType channel;
  ChannelLifecycleState state;
  final DateTime registeredAt;
  DateTime lastStateChange;
  String? lastError;

  ChannelRegistrationInfo({
    required this.channel,
    this.state = ChannelLifecycleState.registered,
    required this.registeredAt,
    required this.lastStateChange,
    this.lastError,
  });
}

/// Manages channel connectivity, operational status, and health states (§5).
class ChannelLifecycleManager {
  final Map<ChannelType, ChannelRegistrationInfo> _channels = {};

  ChannelLifecycleManager() {
    // Default initial registration
    for (final channel in ChannelType.values) {
      _channels[channel] = ChannelRegistrationInfo(
        channel: channel,
        state: ChannelLifecycleState.active,
        registeredAt: DateTime.now().toUtc(),
        lastStateChange: DateTime.now().toUtc(),
      );
    }
  }

  ChannelLifecycleState getChannelState(ChannelType channel) {
    return _channels[channel]?.state ?? ChannelLifecycleState.disabled;
  }

  void setChannelState(ChannelType channel, ChannelLifecycleState newState, {String? error}) {
    final info = _channels[channel];
    if (info != null) {
      info.state = newState;
      info.lastStateChange = DateTime.now().toUtc();
      info.lastError = error;
    }
  }

  bool isChannelOperational(ChannelType channel) {
    final state = getChannelState(channel);
    return state.isOperational;
  }

  Map<String, dynamic> getSummary() {
    final Map<String, dynamic> summary = {};
    for (final entry in _channels.entries) {
      summary[entry.key.name] = {
        'state': entry.value.state.name,
        'last_change': entry.value.lastStateChange.toIso8601String(),
        'error': entry.value.lastError,
      };
    }
    return summary;
  }
}
