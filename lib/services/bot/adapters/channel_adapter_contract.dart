import '../domain/unified_message.dart';

/// Contract for channel-specific protocol adapters (§4).
abstract class ChannelAdapterContract {
  ChannelType get channelType;

  /// Parses raw inbound webhook/request data into a normalized UnifiedIncomingMessage.
  UnifiedIncomingMessage parseIncoming(Map<String, dynamic> rawPayload);

  /// Formats a UnifiedBotResponse into channel-specific payload.
  Map<String, dynamic> formatResponse(UnifiedBotResponse response);
}
