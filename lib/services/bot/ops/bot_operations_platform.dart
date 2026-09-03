import '../domain/bot_error.dart';
import '../domain/unified_message.dart';
import '../runtime/bot_runtime_engine.dart';
import 'adapters/telegram_staging_adapter.dart';
import 'adapters/whatsapp_staging_adapter.dart';
import 'admin/bot_admin_api_server.dart';
import 'control/bot_feature_flag_service.dart';
import 'control/command_management_service.dart';
import 'control/global_safety_kill_switch.dart';
import 'lifecycle/channel_health_service.dart';
import 'lifecycle/channel_lifecycle_manager.dart';
import 'lifecycle/webhook_lifecycle_manager.dart';
import 'registry/bot_registry.dart';
import 'secrets/secret_provider.dart';
import 'security/moderation_manager.dart';
import 'security/security_event_logger.dart';
import 'security/staging_allowlist.dart';

/// Central Operations Platform coordinating Staging Integration, Admin Controls, and Observability (§0, §1, §62).
class BotOperationsPlatform {
  final BotRuntimeEngine runtimeEngine;
  final SecretProviderContract secretProvider;
  final ChannelLifecycleManager channelLifecycle;
  final WebhookLifecycleManager webhookLifecycle;
  final ChannelHealthService channelHealth;
  final BotRegistry botRegistry;
  final BotFeatureFlagService featureFlags;
  final GlobalSafetyKillSwitch killSwitch;
  final CommandManagementService commandManagement;
  final StagingAllowlist stagingAllowlist;
  final ModerationManager moderation;
  final SecurityEventLogger securityLogger;
  final BotAdminApiServer adminApiServer;

  // Staging Channel Adapters
  final TelegramStagingAdapter telegramStagingAdapter;
  final WhatsAppStagingAdapter whatsappStagingAdapter;

  BotOperationsPlatform._({
    required this.runtimeEngine,
    required this.secretProvider,
    required this.channelLifecycle,
    required this.webhookLifecycle,
    required this.channelHealth,
    required this.botRegistry,
    required this.featureFlags,
    required this.killSwitch,
    required this.commandManagement,
    required this.stagingAllowlist,
    required this.moderation,
    required this.securityLogger,
    required this.adminApiServer,
    required this.telegramStagingAdapter,
    required this.whatsappStagingAdapter,
  });

  factory BotOperationsPlatform.bootstrap({
    BotRuntimeEngine? runtimeEngine,
    SecretProviderContract? secretProvider,
    StagingAllowlist? stagingAllowlist,
    BotRegistry? botRegistry,
  }) {
    final effectiveRuntime = runtimeEngine ?? BotRuntimeEngine.bootstrap();
    final effectiveSecrets = secretProvider ?? StagingSecretProvider();
    final effectiveLifecycle = ChannelLifecycleManager();
    final effectiveHealth = ChannelHealthService();
    final effectiveBots = botRegistry ?? BotRegistry();
    final effectiveFlags = BotFeatureFlagService();
    final effectiveKillSwitch = GlobalSafetyKillSwitch();
    final effectiveCommands = CommandManagementService(
      commandRegistry: effectiveRuntime.platform.commandRegistry,
    );
    final effectiveAllowlist = stagingAllowlist ?? StagingAllowlist(enforceAllowlist: true);
    final effectiveModeration = ModerationManager();
    final effectiveSecurityLogger = SecurityEventLogger();

    final effectiveWebhooks = WebhookLifecycleManager(
      initialSecrets: {
        ChannelType.telegram: effectiveSecrets.getTelegramSecretToken(),
        ChannelType.whatsapp: effectiveSecrets.getWhatsAppAppSecret(),
        ChannelType.webChat: effectiveSecrets.getWebhookSecret(),
        ChannelType.api: effectiveSecrets.getWebhookSecret(),
      },
    );

    final adminApi = BotAdminApiServer(
      botRegistry: effectiveBots,
      lifecycleManager: effectiveLifecycle,
      webhookManager: effectiveWebhooks,
      healthService: effectiveHealth,
      featureFlags: effectiveFlags,
      killSwitch: effectiveKillSwitch,
      allowlist: effectiveAllowlist,
      securityLogger: effectiveSecurityLogger,
    );

    return BotOperationsPlatform._(
      runtimeEngine: effectiveRuntime,
      secretProvider: effectiveSecrets,
      channelLifecycle: effectiveLifecycle,
      webhookLifecycle: effectiveWebhooks,
      channelHealth: effectiveHealth,
      botRegistry: effectiveBots,
      featureFlags: effectiveFlags,
      killSwitch: effectiveKillSwitch,
      commandManagement: effectiveCommands,
      stagingAllowlist: effectiveAllowlist,
      moderation: effectiveModeration,
      securityLogger: effectiveSecurityLogger,
      adminApiServer: adminApi,
      telegramStagingAdapter: const TelegramStagingAdapter(),
      whatsappStagingAdapter: const WhatsAppStagingAdapter(),
    );
  }

  /// Processes an inbound staging message with full operational controls (§3, §4, §15, §46).
  Future<UnifiedBotResponse> processStagingMessage(UnifiedIncomingMessage message) async {
    final channel = message.channel;
    channelHealth.recordInboundEvent(channel);

    // 1. Channel Operational State Check (§5)
    if (!channelLifecycle.isChannelOperational(channel)) {
      securityLogger.logEvent(
        type: SecurityEventType.toolDenied,
        sourceChannel: channel.name,
        identifier: message.externalUserId,
        details: 'Message dropped: Channel is disabled or degraded',
      );
      throw const SafeBotException(BotFailureReason.channelError, 'Channel is currently disabled.');
    }

    // 2. Staging Allowlist Gate (§46, §47)
    if (!stagingAllowlist.isAllowed(channel, message.externalUserId)) {
      securityLogger.logEvent(
        type: SecurityEventType.authFailure,
        sourceChannel: channel.name,
        identifier: message.externalUserId,
        details: 'Access blocked: User not in staging allowlist',
      );
      return const UnifiedBotResponse(
        requestId: 'req_allowlist_blocked',
        textArabic: 'عذراً، هذه القناة متاحة حالياً للمستخدمين المصرح لهم في بيئة الاختبار التجريبية فقط.',
        isAbstained: true,
      );
    }

    // 3. Moderation & Flood Check (§26)
    if (moderation.isUserBlocked(message.externalUserId) ||
        !moderation.checkFloodAndRecord(message.externalUserId)) {
      securityLogger.logEvent(
        type: SecurityEventType.blockedUserAttempt,
        sourceChannel: channel.name,
        identifier: message.externalUserId,
        details: 'Message blocked by moderation policy',
      );
      throw const SafeBotException(BotFailureReason.rateLimitExceeded, 'User blocked for excessive activity.');
    }

    // 4. Global Kill Switch Check (§15, §44)
    if (killSwitch.isGlobalAiKilled && !message.isCommand) {
      return const UnifiedBotResponse(
        requestId: 'req_killswitch_active',
        textArabic: 'الخدمة التفاعلية متوقفة مؤقتاً لأعمال الصيانة. يمكنك استخدام الأوامر الحتمية مثل /prayer و /quran و /adhkar.',
        isAbstained: true,
      );
    }

    // 5. Delegate to Runtime Platform
    try {
      final response = await runtimeEngine.platform.handleUnifiedMessage(message);
      channelHealth.recordProcessedEvent(channel);
      return response;
    } catch (e) {
      channelHealth.recordError(channel);
      rethrow;
    }
  }
}
