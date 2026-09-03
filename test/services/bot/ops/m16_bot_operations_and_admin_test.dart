import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';
import 'package:siraj/services/bot/ops/security/admin_rbac.dart';
import 'package:siraj/services/bot/runtime/api/bot_api_server.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M16 Bot Operations & Admin Platform Tests (§10-§24)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late BotOperationsPlatform opsPlatform;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      final runtime = BotRuntimeEngine.bootstrap(
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );

      opsPlatform = BotOperationsPlatform.bootstrap(
        runtimeEngine: runtime,
      );
    });

    test('Bot Registry lists multiple standard bot identities', () async {
      final res = await opsPlatform.adminApiServer.handleAdminRequest(HttpRequestContext(
        method: 'GET',
        path: '/admin/bots',
      ));

      expect(res.statusCode, equals(200));
      final json = jsonDecode(res.body);
      final bots = json['bots'] as List;
      expect(bots.length, greaterThanOrEqualTo(4));
    });

    test('Operator toggles channel status and updates lifecycle state', () async {
      final toggleRes = await opsPlatform.adminApiServer.handleAdminRequest(
        HttpRequestContext(
          method: 'POST',
          path: '/admin/channels/toggle',
          body: jsonEncode({'channel': 'whatsapp', 'enable': false}),
        ),
        callerRole: AdminRole.operator,
      );

      expect(toggleRes.statusCode, equals(200));
      final json = jsonDecode(toggleRes.body);
      expect(json['is_active'], isFalse);
    });

    test('Viewer is rejected when attempting to toggle channels (RBAC Enforcement)', () async {
      final res = await opsPlatform.adminApiServer.handleAdminRequest(
        HttpRequestContext(
          method: 'POST',
          path: '/admin/channels/toggle',
          body: jsonEncode({'channel': 'telegram', 'enable': false}),
        ),
        callerRole: AdminRole.viewer, // No toggle permission
      );

      expect(res.statusCode, equals(403));
      final json = jsonDecode(res.body);
      expect(json['error_code'], equals('FORBIDDEN'));
    });

    test('Operations Dashboard aggregates active metrics and health overview', () async {
      final res = await opsPlatform.adminApiServer.handleAdminRequest(HttpRequestContext(
        method: 'GET',
        path: '/admin/dashboard',
      ));

      expect(res.statusCode, equals(200));
      final json = jsonDecode(res.body);
      expect(json['dashboard']['active_bots'], greaterThanOrEqualTo(4));
      expect(json['dashboard']['channels'], isNotNull);
    });
  });
}
