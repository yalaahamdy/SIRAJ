import '../../../modules/adhkar/adhkar_module.dart';
import '../../../modules/ai/ai_module.dart';
import '../../../modules/hajj/hajj_module.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import '../../../modules/learning/learning_module.dart';
import '../../../modules/quran/store/canonical_quran_store.dart';
import '../../../modules/seerah/seerah_module.dart';
import '../gateway/bot_gateway.dart';
import '../gateway/bot_quota_service.dart';
import '../siraj_bot_platform.dart';
import 'api/bot_api_server.dart';
import 'config/environment_config.dart';
import 'harness/bot_api_client.dart';
import 'harness/telegram_integration_harness.dart';
import 'harness/whatsapp_integration_harness.dart';
import 'queue/message_processing_queue.dart';
import 'scheduler/retention_scheduler.dart';
import 'storage/distributed_lock.dart';
import 'storage/idempotency_store.dart';
import 'storage/session_repository.dart';

/// Central Runtime Coordinator orchestrating Server, Platform, Queues, Stores, and Sandboxes (§0, §5).
class BotRuntimeEngine {
  final EnvironmentConfig config;
  final SirajBotPlatform platform;
  final BotApiServer apiServer;
  final IdempotencyStoreContract idempotencyStore;
  final SessionRepositoryContract sessionRepository;
  final DistributedLockContract distributedLock;
  final MessageProcessingQueue queue;
  final RetentionScheduler retentionScheduler;

  // Integration Sandbox Harnesses
  final TelegramIntegrationHarness telegramHarness;
  final WhatsAppIntegrationHarness whatsappHarness;
  final BotApiClient apiClient;

  BotRuntimeEngine._({
    required this.config,
    required this.platform,
    required this.apiServer,
    required this.idempotencyStore,
    required this.sessionRepository,
    required this.distributedLock,
    required this.queue,
    required this.retentionScheduler,
    required this.telegramHarness,
    required this.whatsappHarness,
    required this.apiClient,
  });

  /// Factory bootstrapping the full executable bot runtime with validation (§4, §5).
  factory BotRuntimeEngine.bootstrap({
    EnvironmentConfig? config,
    IdempotencyStoreContract? idempotencyStore,
    SessionRepositoryContract? sessionRepository,
    DistributedLockContract? distributedLock,
    ReadOnlyCanonicalQuranStore? quranStore,
    AdhkarModule? adhkarModule,
    KnowledgeModule? knowledgeModule,
    LearningModule? learningModule,
    SeerahModule? seerahModule,
    HajjModule? hajjModule,
    AIModule? aiModule,
  }) {
    final effectiveConfig = config ?? EnvironmentConfig.localSandbox();

    // 1. Startup validation (Fail Fast) (§4)
    effectiveConfig.validateAndFailFast();

    final effectiveIdempotencyStore = idempotencyStore ?? MemoryIdempotencyStore();
    final effectiveSessionRepo = sessionRepository ?? MemorySessionRepository();
    final effectiveLock = distributedLock ?? MemoryDistributedLock();
    final effectiveQueue = MessageProcessingQueue();

    // 2. Gateway configured with Security settings (§23)
    final gateway = BotGateway(
      webhookSecret: effectiveConfig.securityConfig.webhookSecret,
      maxPayloadSizeBytes: effectiveConfig.securityConfig.maxPayloadSizeBytes,
      quotaService: BotQuotaService(
        maxRequestsPerMinutePerUser: effectiveConfig.securityConfig.userRateLimitRpm,
        maxRequestsPerMinutePerChannel: effectiveConfig.securityConfig.channelRateLimitRpm,
      ),
    );

    // 3. Platform facade
    final platform = SirajBotPlatform(
      gateway: gateway,
      quranStore: quranStore,
      adhkarModule: adhkarModule,
      knowledgeModule: knowledgeModule,
      learningModule: learningModule,
      seerahModule: seerahModule,
      hajjModule: hajjModule,
      aiModule: aiModule,
    );

    // 4. API Server
    final apiServer = BotApiServer(
      platform: platform,
      config: effectiveConfig,
      idempotencyStore: effectiveIdempotencyStore,
    );

    // 5. Retention Scheduler
    final retentionScheduler = RetentionScheduler(
      idempotencyStore: effectiveIdempotencyStore,
      accountLinkingService: platform.accountLinkingService,
    );

    // 6. Harnesses
    final telegramHarness = TelegramIntegrationHarness(apiServer: apiServer);
    final whatsappHarness = WhatsAppIntegrationHarness(apiServer: apiServer);
    final apiClient = BotApiClient(server: apiServer);

    return BotRuntimeEngine._(
      config: effectiveConfig,
      platform: platform,
      apiServer: apiServer,
      idempotencyStore: effectiveIdempotencyStore,
      sessionRepository: effectiveSessionRepo,
      distributedLock: effectiveLock,
      queue: effectiveQueue,
      retentionScheduler: retentionScheduler,
      telegramHarness: telegramHarness,
      whatsappHarness: whatsappHarness,
      apiClient: apiClient,
    );
  }
}
