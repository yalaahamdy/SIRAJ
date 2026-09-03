import '../domain/unified_message.dart';
import 'channel_adapter_contract.dart';

/// Adapter for Web Chat widget clients (§4, §35).
class WebChatAdapter implements ChannelAdapterContract {
  const WebChatAdapter();

  @override
  ChannelType get channelType => ChannelType.webChat;

  @override
  UnifiedIncomingMessage parseIncoming(Map<String, dynamic> rawPayload) {
    return UnifiedIncomingMessage(
      messageId: rawPayload['message_id']?.toString() ?? 'web_msg_${DateTime.now().millisecondsSinceEpoch}',
      channel: ChannelType.webChat,
      externalUserId: rawPayload['user_id']?.toString() ?? 'anonymous_web_user',
      conversationId: rawPayload['session_id']?.toString(),
      text: rawPayload['text'] as String? ?? '',
      callbackPayload: rawPayload['action_id'] as String?,
      timestamp: DateTime.now().toUtc(),
      channelMetadata: rawPayload['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  @override
  Map<String, dynamic> formatResponse(UnifiedBotResponse response) {
    return {
      'request_id': response.requestId,
      'text': response.textArabic,
      'grounding_status': response.groundingStatus.name,
      'is_abstained': response.isAbstained,
      'abstention_reason': response.abstentionReasonArabic,
      'citations': response.citations.map((c) => {
        'id': c.citationId,
        'title': c.displayTitleArabic,
        'reference': c.referenceLocation,
        'status': c.status.name,
      }).toList(),
      'evidence_items': response.evidenceItems.map((e) => {
        'id': e.contentId,
        'source': e.sourceId,
        'title': e.title,
        'excerpt': e.textExcerpt,
        'location': e.referenceLocation,
      }).toList(),
      'requires_confirmation': response.requiresConfirmation,
      'confirmation_action_id': response.confirmationActionId,
      'menu': response.menu != null ? {
        'title': response.menu!.title,
        'buttons': response.menu!.rows.expand((r) => r.map((b) => {
          'id': b.id,
          'label': b.labelArabic,
          'url': b.url,
        })).toList(),
      } : null,
    };
  }
}
