import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import 'package:siraj/services/bot/runtime/config/environment_config.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M15 Bot Runtime E2E Integration Suite (§18, §19, §22)', () {
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

    test('E2E Flow 1: Health, Readiness, and Liveness endpoints return positive status', () async {
      final healthRes = await runtime.apiClient.checkHealth();
      expect(healthRes.statusCode, equals(200));
      final healthJson = jsonDecode(healthRes.body);
      expect(healthJson['status'], equals('ok'));
      expect(healthJson['alive'], isTrue);

      final readyRes = await runtime.apiClient.checkReadiness();
      expect(readyRes.statusCode, equals(200));
      final readyJson = jsonDecode(readyRes.body);
      expect(readyJson['ready'], isTrue);
    });

    test('E2E Flow 2: Telegram Sandbox Harness processes /start, /prayer, and callback query', () async {
      // 1. Send /start
      final startRes = await runtime.telegramHarness.sendTextMessage(
        updateId: 1001,
        messageId: 501,
        userId: 98765,
        text: '/start',
      );
      expect(startRes.statusCode, equals(200));
      final startJson = jsonDecode(startRes.body);
      expect(startJson['text'], contains('مرحباً بك في سِراج'));
      expect(startJson['reply_markup'], isNotNull);

      // 2. Send /prayer command
      final prayerRes = await runtime.telegramHarness.sendTextMessage(
        updateId: 1002,
        messageId: 502,
        userId: 98765,
        text: '/prayer',
      );
      expect(prayerRes.statusCode, equals(200));
      final prayerJson = jsonDecode(prayerRes.body);
      expect(prayerJson['text'], contains('مواقيت الصلاة'));

      // 3. Send callback query /adhkar
      final callbackRes = await runtime.telegramHarness.sendCallbackQuery(
        updateId: 1003,
        callbackId: 'cb_123',
        userId: 98765,
        callbackData: '/adhkar',
      );
      expect(callbackRes.statusCode, equals(200));
      final cbJson = jsonDecode(callbackRes.body);
      expect(cbJson['text'], contains('الأذكار المأثورة'));
    });

    test('E2E Flow 3: WhatsApp Sandbox Harness processes plain text religious search', () async {
      final res = await runtime.whatsappHarness.sendTextMessage(
        messageId: 'wamid_e2e_1',
        senderPhone: '966555123456',
        text: 'ما نص حديث النية؟',
      );

      expect(res.statusCode, equals(200));
      final resJson = jsonDecode(res.body);
      expect(resJson['type'], equals('text'));
      expect(resJson['text']['body'], contains('النية'));
    });

    test('E2E Flow 4: API Client executes grounded informational query through M12 AI Core', () async {
      final res = await runtime.apiClient.postMessage(
        userId: 'client_usr_1',
        text: 'ما نص حديث النية؟',
        idempotencyKey: 'api_idem_1',
      );

      expect(res.statusCode, equals(200));
      final resJson = jsonDecode(res.body);
      expect(resJson['status'], equals('success'));
      expect(resJson['answer'], contains('النية'));
      expect(resJson['is_abstained'], isFalse);
      expect((resJson['citations'] as List).isNotEmpty, isTrue);
    });

    test('E2E Flow 5: Metrics endpoint accurately aggregates non-sensitive counters', () async {
      await runtime.apiClient.postMessage(
        userId: 'metrics_user',
        text: '/help',
      );

      final metricsRes = await runtime.apiClient.getMetrics();
      expect(metricsRes.statusCode, equals(200));
      final metricsJson = jsonDecode(metricsRes.body);
      expect(metricsJson['siraj_bot_messages_total'], greaterThanOrEqualTo(1));
    });
  });
}
