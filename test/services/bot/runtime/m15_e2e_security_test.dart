import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/runtime/api/bot_api_server.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import 'package:siraj/services/bot/runtime/config/environment_config.dart';
import 'package:siraj/services/bot/runtime/logging/sensitive_data_redactor.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M15 Bot Runtime E2E Security Suite (§23, §24, §39, §48)', () {
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

    test('Security 1: SensitiveDataRedactor masks phone numbers, emails, tokens, and financial terms', () {
      const rawText = 'اتصل بي على +966501234567 أو راسل user@example.com ومعه Bearer eyJhbGciOiJIUzI1Ni... والمبلغ 5000 SAR';
      final redacted = SensitiveDataRedactor.redact(rawText);

      expect(redacted.contains('+966501234567'), isFalse);
      expect(redacted.contains('[REDACTED_PHONE]'), isTrue);
      expect(redacted.contains('user@example.com'), isFalse);
      expect(redacted.contains('Bearer [REDACTED_TOKEN]'), isTrue);
      expect(redacted.contains('[REDACTED_FINANCIAL]'), isTrue);
    });

    test('Security 2: API Idempotency Key rejects duplicate message requests with HTTP 409', () async {
      const key = 'idem_key_sec_100';

      // First call succeeds
      final res1 = await runtime.apiClient.postMessage(
        userId: 'u1',
        text: '/prayer',
        idempotencyKey: key,
      );
      expect(res1.statusCode, equals(200));

      // Second duplicate call returns HTTP 409 Conflict
      final res2 = await runtime.apiClient.postMessage(
        userId: 'u1',
        text: '/prayer',
        idempotencyKey: key,
      );
      expect(res2.statusCode, equals(409));
      final json2 = jsonDecode(res2.body);
      expect(json2['error_code'], equals('DUPLICATE_REQUEST'));
    });

    test('Security 3: Startup validation fails fast in production if insecure default secret is configured', () {
      const prodConfig = EnvironmentConfig(
        environment: EnvironmentType.production,
        securityConfig: SecurityConfig(
          webhookSecret: 'siraj_test_sandbox_webhook_secret_key', // Insecure default
        ),
      );

      expect(
        () => BotRuntimeEngine.bootstrap(config: prodConfig),
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('Production startup blocked'),
        )),
      );
    });

    test('Security 4: Unhandled endpoints return safe HTTP 404 response without leaking internals', () async {
      final res = await runtime.apiServer.handleRequest(HttpRequestContext(
        method: 'GET',
        path: '/admin/unauthorized/secret',
      ));

      expect(res.statusCode, equals(404));
      final json = jsonDecode(res.body);
      expect(json['error_code'], equals('NOT_FOUND'));
    });
  });
}
