import '../../../modules/ai/ai_module.dart';
import '../../../modules/ai/domain/ai_intent.dart';
import '../../../modules/ai/domain/ai_response.dart';
import '../../../modules/ai/domain/grounding_status.dart';
import '../commands/command_registry.dart';
import '../domain/bot_audit_log.dart';
import '../domain/bot_session.dart';
import '../domain/unified_message.dart';
import '../session/bot_session_store.dart';
import '../session/confirmation_engine.dart';
import '../tools/tool_registry.dart';

/// Central Orchestrator coordinating Bot Messages, Sessions, Workflows, Tools, and M12 AI Core (§26, §56, §57, §67, §68).
class BotAIOrchestrator {
  final BotSessionStoreContract _sessionStore;
  final BotCommandRegistry _commandRegistry;
  final BotToolRegistry _toolRegistry;
  final AIModule _aiModule;
  final ConfirmationEngine _confirmationEngine;

  final List<BotAuditRecord> _auditLogs = [];

  BotAIOrchestrator({
    required BotSessionStoreContract sessionStore,
    required BotCommandRegistry commandRegistry,
    required BotToolRegistry toolRegistry,
    required AIModule aiModule,
    ConfirmationEngine? confirmationEngine,
  })  : _sessionStore = sessionStore,
        _commandRegistry = commandRegistry,
        _toolRegistry = toolRegistry,
        _aiModule = aiModule,
        _confirmationEngine = confirmationEngine ?? ConfirmationEngine();

  BotToolRegistry get toolRegistry => _toolRegistry;
  ConfirmationEngine get confirmationEngine => _confirmationEngine;
  List<BotAuditRecord> get auditLogs => List.unmodifiable(_auditLogs);

  /// Processes an incoming normalized message through the complete safe bot pipeline (§26, §67).
  Future<UnifiedBotResponse> handleMessage(UnifiedIncomingMessage message) async {
    final requestId = 'req_bot_${DateTime.now().millisecondsSinceEpoch}';
    final traceId = 'tr_${DateTime.now().microsecondsSinceEpoch}';

    // 1. Get or Create Session (§8)
    var session = await _sessionStore.getOrCreateSession(
      channel: message.channel,
      externalUserId: message.externalUserId,
      conversationId: message.conversationId,
    );

    // 2. Add User Message to Bounded Context (§10)
    final userMsg = ConversationMessage(
      id: message.messageId,
      isUser: true,
      text: message.text,
      timestamp: message.timestamp,
    );
    session = session.copyWith(
      context: session.context.addMessage(userMsg),
    );

    // 3. Handle Pending Confirmation Workflow (§14, §15, §16, §22, §33)
    if (session.state == BotWorkflowState.waitingForConfirmation) {
      final pendingAction = session.context.pendingConfirmationAction;

      if (pendingAction != null) {
        if (_confirmationEngine.isAffirmativeConfirmation(message.text) ||
            message.callbackPayload?.startsWith('CONFIRM_') == true) {
          
          // Verify token validity (single-use & unexpired) (§15, §16)
          final isValid = _confirmationEngine.validateAndConsumeToken(pendingAction);

          if (!isValid) {
            final response = const UnifiedBotResponse(
              requestId: 'req_action_expired',
              textArabic: '⚠️ انتهت صلاحية رمز التأكيد أو تم استخدامه مسبقاً. يُرجى إعادة الطلب.',
            );
            session = session.copyWith(
              state: BotWorkflowState.idle,
              context: session.context.copyWith(pendingConfirmationAction: null),
            );
            await _sessionStore.saveSession(session);
            _recordAudit(requestId, traceId, session.sessionId, message.channel, 'EXPIRED_CONFIRM', [], 0, false, false, 'EXPIRED');
            return response;
          }

          // Execute Confirmed Action
          if (pendingAction == 'ACTION_DELETE_USER_DATA') {
            await _sessionStore.deleteUserData(session.internalUserId);
            final response = const UnifiedBotResponse(
              requestId: 'req_delete_success',
              textArabic: '✅ تم حذف كافة بياناتك وسجلات جلساتك نهائياً من سِراج بنجاح.',
            );
            _recordAudit(requestId, traceId, session.sessionId, message.channel, 'CONFIRM_DELETE', [], 0, false, false, 'DELETED');
            return response;
          }

          final response = const UnifiedBotResponse(
            requestId: 'req_action_success',
            textArabic: '✅ تم تأكيد الإجراء وتنفيذه بنجاح.',
          );
          session = session.copyWith(
            state: BotWorkflowState.completed,
            context: session.context.copyWith(pendingConfirmationAction: null),
          );
          await _sessionStore.saveSession(session);
          _recordAudit(requestId, traceId, session.sessionId, message.channel, 'CONFIRMED', [], 0, false, false, 'SUCCESS');
          return response;
        } else if (_confirmationEngine.isNegativeConfirmation(message.text) ||
            message.callbackPayload?.startsWith('CANCEL_') == true) {
          _confirmationEngine.invalidateToken(pendingAction);
          final response = const UnifiedBotResponse(
            requestId: 'req_action_cancelled',
            textArabic: 'تم إلغاء الإجراء بطلبك.',
          );
          session = session.copyWith(
            state: BotWorkflowState.idle,
            context: session.context.copyWith(pendingConfirmationAction: null),
          );
          await _sessionStore.saveSession(session);
          _recordAudit(requestId, traceId, session.sessionId, message.channel, 'CANCELLED', [], 0, false, false, 'CANCELLED');
          return response;
        }
      }
    }

    // 4. Handle Direct Slash Commands (§14, §15)
    if (message.isCommand) {
      final cmd = _commandRegistry.getCommand(message.commandName);
      if (cmd != null) {
        final res = await cmd.handler(
          message: message,
          session: session,
          arguments: message.commandArguments,
        );

        if (res.requiresConfirmation) {
          session = session.copyWith(
            state: BotWorkflowState.waitingForConfirmation,
            context: session.context.copyWith(
              pendingConfirmationAction: res.confirmationActionId,
            ),
          );
        } else {
          session = session.copyWith(state: BotWorkflowState.idle);
        }
        await _sessionStore.saveSession(session);

        _recordAudit(requestId, traceId, session.sessionId, message.channel, message.commandName, [], 0, false, res.requiresConfirmation, 'COMMAND_EXECUTED');
        return res;
      }
    }

    // 5. Handle Intent & Evidence-Grounded AI Core with Safe Deterministic Fallback (§26, §29, §30, §56, §57)
    AIResponse aiResponse;
    try {
      aiResponse = await _aiModule.processQuery(message.text);
    } catch (e) {
      // Safe Deterministic Degradation / Fallback Mode (§56, §57)
      aiResponse = AIResponse(
        requestId: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
        mode: AIResponseMode.abstention,
        answerArabic: 'تعذر الاتصال بمزود الذكاء الاصطناعي حالياً. يمكنك استخدام الأوامر الحتمية مثل /prayer و /quran و /adhkar للحصول على المعلومات الموثقة.',
        groundingStatus: GroundingStatus.abstained,
        riskLevel: RiskLevel.low,
        isAbstained: true,
        abstentionReasonArabic: 'انقطاع مؤقت في خدمة الذكاء الاصطناعي — التحول إلى الوضع الحتمي الآمن.',
      );
    }

    final botResponse = UnifiedBotResponse(
      requestId: requestId,
      textArabic: aiResponse.answerArabic,
      citations: aiResponse.citations,
      evidenceItems: aiResponse.evidenceItems,
      groundingStatus: aiResponse.groundingStatus,
      isAbstained: aiResponse.isAbstained,
      abstentionReasonArabic: aiResponse.abstentionReasonArabic,
    );

    session = session.copyWith(
      state: aiResponse.isAbstained ? BotWorkflowState.abstained : BotWorkflowState.showingResult,
      context: session.context.addMessage(ConversationMessage(
        id: 'bot_msg_${DateTime.now().millisecondsSinceEpoch}',
        isUser: false,
        text: aiResponse.answerArabic,
        timestamp: DateTime.now().toUtc(),
      )),
    );
    await _sessionStore.saveSession(session);

    _recordAudit(
      requestId,
      traceId,
      session.sessionId,
      message.channel,
      'AI_RETRIEVAL',
      aiResponse.citations.map((c) => c.sourceId).toList(),
      aiResponse.evidenceItems.length,
      aiResponse.isAbstained,
      false,
      aiResponse.groundingStatus.name,
    );

    return botResponse;
  }

  void _recordAudit(
    String requestId,
    String traceId,
    String sessionId,
    ChannelType channel,
    String commandOrIntent,
    List<String> tools,
    int evidenceCount,
    bool isAbstained,
    bool requiresConfirmation,
    String status,
  ) {
    _auditLogs.add(BotAuditRecord(
      requestId: requestId,
      traceId: traceId,
      sessionId: sessionId,
      channel: channel,
      commandOrIntent: commandOrIntent,
      toolsUsed: tools,
      evidenceCount: evidenceCount,
      isAbstained: isAbstained,
      requiresConfirmation: requiresConfirmation,
      responseStatus: status,
      timestamp: DateTime.now().toUtc(),
    ));
  }
}
