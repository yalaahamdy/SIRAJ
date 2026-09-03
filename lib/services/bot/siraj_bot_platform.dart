import '../../modules/adhkar/adhkar_module.dart';
import '../../modules/ai/ai_module.dart';
import '../../modules/hajj/hajj_module.dart';
import '../../modules/knowledge/knowledge_module.dart';
import '../../modules/learning/learning_module.dart';
import '../../modules/quran/store/canonical_quran_store.dart';
import '../../modules/seerah/seerah_module.dart';
import 'commands/command_registry.dart';
import 'commands/standard_commands.dart';
import 'domain/bot_audit_log.dart';
import 'domain/bot_profile.dart';
import 'domain/unified_message.dart';
import 'gateway/bot_gateway.dart';
import 'orchestrator/bot_ai_orchestrator.dart';
import 'session/account_linking_service.dart';
import 'session/bot_session_store.dart';
import 'session/confirmation_engine.dart';
import 'tools/siraj_tools.dart';
import 'tools/tool_registry.dart';

/// Unified Facade for the SIRAJ Intelligent Bot Platform (§0, §1, §3, §40).
class SirajBotPlatform {
  final BotGateway _gateway;
  final BotSessionStoreContract _sessionStore;
  final BotCommandRegistry _commandRegistry;
  final BotToolRegistry _toolRegistry;
  final ConfirmationEngine _confirmationEngine;
  final AccountLinkingService _accountLinkingService;
  final BotAIOrchestrator _orchestrator;
  final BotProfile _profile;

  SirajBotPlatform._({
    required BotGateway gateway,
    required BotSessionStoreContract sessionStore,
    required BotCommandRegistry commandRegistry,
    required BotToolRegistry toolRegistry,
    required ConfirmationEngine confirmationEngine,
    required AccountLinkingService accountLinkingService,
    required BotAIOrchestrator orchestrator,
    required BotProfile profile,
  })  : _gateway = gateway,
        _sessionStore = sessionStore,
        _commandRegistry = commandRegistry,
        _toolRegistry = toolRegistry,
        _confirmationEngine = confirmationEngine,
        _accountLinkingService = accountLinkingService,
        _orchestrator = orchestrator,
        _profile = profile;

  factory SirajBotPlatform({
    BotGateway? gateway,
    BotSessionStoreContract? sessionStore,
    BotCommandRegistry? commandRegistry,
    BotToolRegistry? toolRegistry,
    ConfirmationEngine? confirmationEngine,
    AccountLinkingService? accountLinkingService,
    BotAIOrchestrator? orchestrator,
    AIModule? aiModule,
    BotProfile? profile,
    ReadOnlyCanonicalQuranStore? quranStore,
    AdhkarModule? adhkarModule,
    KnowledgeModule? knowledgeModule,
    LearningModule? learningModule,
    SeerahModule? seerahModule,
    HajjModule? hajjModule,
  }) {
    final effectiveGateway = gateway ?? BotGateway();
    final effectiveSessionStore = sessionStore ?? MemoryBotSessionStore();
    final effectiveConfirmationEngine = confirmationEngine ?? ConfirmationEngine();
    final effectiveAccountLinkingService = accountLinkingService ??
        AccountLinkingService(sessionStore: effectiveSessionStore);

    final effectiveCommandRegistry = commandRegistry ??
        BotCommandRegistry(
          commands: StandardBotCommands.createStandardSuite(
            confirmationEngine: effectiveConfirmationEngine,
          ),
        );

    final effectiveToolRegistry = toolRegistry ??
        BotToolRegistry(tools: [
          PrayerTool(),
          QuranTool(quranStore),
          MemorizationTool(),
          AdhkarTool(adhkarModule),
          ZakatTool(),
          FastingTool(),
          KnowledgeTool(knowledgeModule),
          LearningTool(learningModule),
          SeerahTool(seerahModule),
          HajjTool(hajjModule),
        ]);

    final effectiveProfile = profile ??
        const BotProfile(
          botId: 'siraj_general_assistant',
          displayNameArabic: 'سِراج — الرفيق الإسلامي',
          descriptionArabic: 'منصة البوت الموحدة متعددة القنوات للاسترجاع المعرفي الإسلامي المسند',
        );

    final effectiveAIModule = aiModule ??
        AIModule(
          quranStore: quranStore,
          adhkarModule: adhkarModule,
          knowledgeModule: knowledgeModule,
          learningModule: learningModule,
          seerahModule: seerahModule,
          hajjModule: hajjModule,
        );

    final effectiveOrchestrator = orchestrator ??
        BotAIOrchestrator(
          sessionStore: effectiveSessionStore,
          commandRegistry: effectiveCommandRegistry,
          toolRegistry: effectiveToolRegistry,
          aiModule: effectiveAIModule,
          confirmationEngine: effectiveConfirmationEngine,
        );

    return SirajBotPlatform._(
      gateway: effectiveGateway,
      sessionStore: effectiveSessionStore,
      commandRegistry: effectiveCommandRegistry,
      toolRegistry: effectiveToolRegistry,
      confirmationEngine: effectiveConfirmationEngine,
      accountLinkingService: effectiveAccountLinkingService,
      orchestrator: effectiveOrchestrator,
      profile: effectiveProfile,
    );
  }

  BotGateway get gateway => _gateway;
  BotSessionStoreContract get sessionStore => _sessionStore;
  BotCommandRegistry get commandRegistry => _commandRegistry;
  BotToolRegistry get toolRegistry => _toolRegistry;
  ConfirmationEngine get confirmationEngine => _confirmationEngine;
  AccountLinkingService get accountLinkingService => _accountLinkingService;
  BotAIOrchestrator get orchestrator => _orchestrator;
  BotProfile get profile => _profile;
  List<BotAuditRecord> get auditLogs => _orchestrator.auditLogs;

  /// Full End-to-End Processing from raw webhook/request payload to channel-formatted response (§4, §7, §26).
  Future<Map<String, dynamic>> handleRawInbound({
    required ChannelType channel,
    required Map<String, dynamic> rawPayload,
    String? rawBodyForSignature,
    String? signatureHeader,
  }) async {
    // 1. Gateway Inbound (Signature, Idempotency, Rate Limit, Parsing)
    final incomingMessage = _gateway.processInbound(
      channel: channel,
      rawPayload: rawPayload,
      rawBodyForSignature: rawBodyForSignature,
      signatureHeader: signatureHeader,
    );

    // 2. Orchestration (Session, Workflow, Command, Tool, M12 AI Core)
    final botResponse = await _orchestrator.handleMessage(incomingMessage);

    // 3. Gateway Outbound Formatting
    return _gateway.formatOutbound(channel, botResponse);
  }

  /// Direct processing of a typed UnifiedIncomingMessage (§5, §6).
  Future<UnifiedBotResponse> handleUnifiedMessage(UnifiedIncomingMessage message) async {
    return _orchestrator.handleMessage(message);
  }
}
