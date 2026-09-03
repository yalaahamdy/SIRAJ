import 'package:equatable/equatable.dart';
import '../../../modules/ai/domain/citation.dart';
import '../../../modules/ai/domain/evidence_item.dart';
import '../../../modules/ai/domain/grounding_status.dart';

/// Supported external channel types (§4).
enum ChannelType {
  telegram('تيليجرام'),
  whatsapp('واتساب'),
  webChat('دردشة الويب'),
  api('واجهة برمجية API');

  final String labelArabic;
  const ChannelType(this.labelArabic);
}

/// Action Button representation across channels (§6, §17).
class BotButton extends Equatable {
  final String id;
  final String labelArabic;
  final String? callbackData;
  final String? url;

  const BotButton({
    required this.id,
    required this.labelArabic,
    this.callbackData,
    this.url,
  });

  @override
  List<Object?> get props => [id, labelArabic, callbackData, url];
}

/// Quick reply suggestion (§6).
class QuickReply extends Equatable {
  final String id;
  final String textArabic;
  final String payload;

  const QuickReply({
    required this.id,
    required this.textArabic,
    required this.payload,
  });

  @override
  List<Object?> get props => [id, textArabic, payload];
}

/// Channel-agnostic interactive menu (§16).
class BotMenu extends Equatable {
  final String title;
  final List<List<BotButton>> rows;

  const BotMenu({
    required this.title,
    required this.rows,
  });

  @override
  List<Object?> get props => [title, rows];
}

/// Attachment reference received in inbound message (§36, §37).
class BotAttachment extends Equatable {
  final String id;
  final String mimeType;
  final String? fileName;
  final int sizeBytes;
  final String? urlOrPath;

  const BotAttachment({
    required this.id,
    required this.mimeType,
    this.fileName,
    required this.sizeBytes,
    this.urlOrPath,
  });

  @override
  List<Object?> get props => [id, mimeType, fileName, sizeBytes, urlOrPath];
}

/// Normalized Inbound Message Contract (§5).
class UnifiedIncomingMessage extends Equatable {
  final String messageId;
  final ChannelType channel;
  final String externalUserId;
  final String? conversationId;
  final String text;
  final String? callbackPayload;
  final List<BotAttachment> attachments;
  final DateTime timestamp;
  final Map<String, dynamic> channelMetadata;

  const UnifiedIncomingMessage({
    required this.messageId,
    required this.channel,
    required this.externalUserId,
    this.conversationId,
    required this.text,
    this.callbackPayload,
    this.attachments = const [],
    required this.timestamp,
    this.channelMetadata = const {},
  });

  bool get isCommand => text.trim().startsWith('/');

  String get commandName {
    if (!isCommand) return '';
    final parts = text.trim().split(RegExp(r'\s+'));
    return parts.first.toLowerCase();
  }

  String get commandArguments {
    if (!isCommand) return '';
    final parts = text.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) return '';
    return parts.sublist(1).join(' ').trim();
  }

  @override
  List<Object?> get props => [
        messageId,
        channel,
        externalUserId,
        conversationId,
        text,
        callbackPayload,
        attachments,
        timestamp,
        channelMetadata,
      ];
}

/// Normalized Outbound Message Response Contract (§6, §30).
class UnifiedBotResponse extends Equatable {
  final String requestId;
  final String textArabic;
  final List<Citation> citations;
  final List<EvidenceItem> evidenceItems;
  final GroundingStatus groundingStatus;
  final BotMenu? menu;
  final List<QuickReply> quickReplies;
  final bool requiresConfirmation;
  final String? confirmationActionId;
  final bool isAbstained;
  final String? abstentionReasonArabic;
  final Map<String, dynamic> metadata;

  const UnifiedBotResponse({
    required this.requestId,
    required this.textArabic,
    this.citations = const [],
    this.evidenceItems = const [],
    this.groundingStatus = GroundingStatus.fullyGrounded,
    this.menu,
    this.quickReplies = const [],
    this.requiresConfirmation = false,
    this.confirmationActionId,
    this.isAbstained = false,
    this.abstentionReasonArabic,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
        requestId,
        textArabic,
        citations,
        evidenceItems,
        groundingStatus,
        menu,
        quickReplies,
        requiresConfirmation,
        confirmationActionId,
        isAbstained,
        abstentionReasonArabic,
        metadata,
      ];
}
