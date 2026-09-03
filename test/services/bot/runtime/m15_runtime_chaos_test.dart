import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import 'package:siraj/services/bot/runtime/config/environment_config.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M15 Bot Runtime Chaos & Concurrency Suite (§70)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late BotRuntimeEngine runtime;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      runtime = BotRuntimeEngine.bootstrap(
        config: EnvironmentConfig.test(),
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    test('Chaos 1: Distributed lock prevents concurrent duplicate processing of the same session resource', () async {
      const resourceKey = 'session_lock_usr_123';

      // Worker 1 acquires lock
      final acquired1 = await runtime.distributedLock.acquireLock(resourceKey);
      expect(acquired1, isTrue);

      // Worker 2 attempts concurrent lock on same resource -> rejected
      final acquired2 = await runtime.distributedLock.acquireLock(resourceKey);
      expect(acquired2, isFalse);

      // Worker 1 releases lock
      await runtime.distributedLock.releaseLock(resourceKey);

      // Worker 2 can now acquire lock
      final acquired3 = await runtime.distributedLock.acquireLock(resourceKey);
      expect(acquired3, isTrue);
    });

    test('Chaos 2: Retention scheduler sweeps expired idempotency and linking keys', () async {
      // 1. Register test idempotency key with negative TTL (already expired)
      await runtime.idempotencyStore.checkAndRegisterKey(
        'expired_idem_key',
        ttl: const Duration(seconds: -10),
      );

      // 2. Run cleanup cycle
      await runtime.retentionScheduler.runCleanupCycle();

      // 3. Re-registering the same key succeeds because the expired record was swept
      final isNew = await runtime.idempotencyStore.checkAndRegisterKey('expired_idem_key');
      expect(isNew, isTrue);
    });
  });
}
