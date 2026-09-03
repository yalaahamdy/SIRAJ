import '../domain/unified_message.dart';
import 'channel_adapter_contract.dart';

/// Adapter for Public REST API clients (`POST /bot/message`) (§4, §104).
class APIAdapter implements ChannelAdapterContract {
  const APIAdapter();

  @override
  ChannelType get channelType => ChannelType.api;

  @override
  UnifiedIncomingMessage parseIncoming(Map<String, dynamic> rawPayload) {
    return UnifiedIncomingMessage(
      messageId: rawPayload['message_id']?.toString() ?? 'api_msg_${DateTime.now().millisecondsSinceEpoch}',
      channel: ChannelType.api,
      externalUserId: rawPayload['client_id']?.toString() ?? 'api_client',
      conversationId: rawPayload['conversation_id']?.toString(),
      text: rawPayload['query'] as String? ?? rawPayload['text'] as String? ?? '',
      callbackPayload: rawPayload['callback_payload'] as String?,
      timestamp: DateTime.now().toUtc(),
      channelMetadata: rawPayload['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  Map<String, dynamic> formatResponse(UnifiedBotResponse response) {
    return {
      'status': 'success',
      'request_id': response.requestId,
      'answer': response.textArabic,
      'grounding_status': response.groundingStatus.name,
      'is_abstained': response.isAbstained,
      'abstention_reason': response.abstentionReasonArabic,
      'citations_count': response.citations.length,
      'evidence_count': response.evidenceItems.length,
      'requires_confirmation': response.requiresConfirmation,
    };
  }
}
