import 'package:equatable/equatable.dart';
import 'unified_message.dart';

/// Finite state machine states for conversation workflows (§32).
enum BotWorkflowState {
  idle('خامل / جاهز'),
  waitingForInput('بانتظار مدخلات المستخدم'),
  waitingForConfirmation('بانتظار تأكيد صريح'),
  executingTool('تنفيذ أداة معرفية'),
  showingResult('عرض النتيجة'),
  abstained('امتناع وتحفظ شرعي'),
  error('خطأ آمن'),
  completed('مكتمل');

  final String labelArabic;
  const BotWorkflowState(this.labelArabic);
}

/// A single message record in session history (§9).
class ConversationMessage extends Equatable {
  final String id;
  final bool isUser;
  final String text;
  final DateTime timestamp;

  const ConversationMessage({
    required this.id,
    required this.isUser,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, isUser, text, timestamp];
}

/// Bounded conversation context window (§10).
class ConversationContext extends Equatable {
  final List<ConversationMessage> recentMessages;
  final String? activeWorkflow;
  final String? pendingConfirmationAction;
  final Map<String, dynamic> workflowData;
  final int maxWindowSize;

  const ConversationContext({
    this.recentMessages = const [],
    this.activeWorkflow,
    this.pendingConfirmationAction,
    this.workflowData = const {},
    this.maxWindowSize = 6,
  });

  ConversationContext addMessage(ConversationMessage msg) {
    final updated = List<ConversationMessage>.from(recentMessages)..add(msg);
    if (updated.length > maxWindowSize) {
      updated.removeAt(0);
    }
    return ConversationContext(
      recentMessages: List.unmodifiable(updated),
      activeWorkflow: activeWorkflow,
      pendingConfirmationAction: pendingConfirmationAction,
      workflowData: workflowData,
      maxWindowSize: maxWindowSize,
    );
  }

  ConversationContext copyWith({
    List<ConversationMessage>? recentMessages,
    String? activeWorkflow,
    String? pendingConfirmationAction,
    Map<String, dynamic>? workflowData,
    int? maxWindowSize,
  }) {
    return ConversationContext(
      recentMessages: recentMessages ?? this.recentMessages,
      activeWorkflow: activeWorkflow ?? this.activeWorkflow,
      pendingConfirmationAction: pendingConfirmationAction ?? this.pendingConfirmationAction,
      workflowData: workflowData ?? this.workflowData,
      maxWindowSize: maxWindowSize ?? this.maxWindowSize,
    );
  }

  @override
  List<Object?> get props => [
        recentMessages,
        activeWorkflow,
        pendingConfirmationAction,
        workflowData,
        maxWindowSize,
      ];
}

/// Conversation Session representation (§8).
class ConversationSession extends Equatable {
  final String sessionId;
  final String internalUserId;
  final String externalUserId;
  final ChannelType channel;
  final String locale;
  final BotWorkflowState state;
  final ConversationContext context;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ConversationSession({
    required this.sessionId,
    required this.internalUserId,
    required this.externalUserId,
    required this.channel,
    this.locale = 'ar',
    this.state = BotWorkflowState.idle,
    this.context = const ConversationContext(),
    required this.createdAt,
    required this.updatedAt,
  });

  ConversationSession copyWith({
    String? sessionId,
    String? internalUserId,
    String? externalUserId,
    ChannelType? channel,
    String? locale,
    BotWorkflowState? state,
    ConversationContext? context,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationSession(
      sessionId: sessionId ?? this.sessionId,
      internalUserId: internalUserId ?? this.internalUserId,
      externalUserId: externalUserId ?? this.externalUserId,
      channel: channel ?? this.channel,
      locale: locale ?? this.locale,
      state: state ?? this.state,
      context: context ?? this.context,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        internalUserId,
        externalUserId,
        channel,
        locale,
        state,
        context,
        createdAt,
        updatedAt,
      ];
}

/// Mapping between channel identity and internal user ID (§39, §40).
class UserIdentityMapping extends Equatable {
  final String internalUserId;
  final ChannelType channel;
  final String externalUserId;
  final DateTime linkedAt;

  const UserIdentityMapping({
    required this.internalUserId,
    required this.channel,
    required this.externalUserId,
    required this.linkedAt,
  });

  @override
  List<Object?> get props => [internalUserId, channel, externalUserId, linkedAt];
}
