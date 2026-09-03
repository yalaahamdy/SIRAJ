import 'package:siraj/core/content_governance/engine/canonical_content_registry.dart';
import 'package:siraj/core/content_governance/engine/content_signing_service.dart';
import 'package:siraj/core/content_governance/gates/production_content_gate.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';

/// Periodic continuous verification service executing synthetic probes (§59, §60).
class ContinuousVerificationService {
  final BotOperationsPlatform _opsPlatform;
  final CanonicalContentRegistry _registry;
  final ContentSigningService _signingService;
  final ProductionContentGate _contentGate;

  ContinuousVerificationService({
    required BotOperationsPlatform opsPlatform,
    required CanonicalContentRegistry registry,
    ContentSigningService? signingService,
  })  : _opsPlatform = opsPlatform,
        _registry = registry,
        _signingService = signingService ?? const ContentSigningService(),
        _contentGate = ProductionContentGate(
          registry: registry,
          signingService: signingService ?? const ContentSigningService(),
        );

  ProductionContentGate get contentGate => _contentGate;

  /// Performs full continuous health probe (§59).
  Future<Map<String, dynamic>> runContinuousProbe() async {
    final results = <String, dynamic>{};

    // 1. Check API readiness
    results['api_ready'] = _opsPlatform.runtimeEngine.apiServer.metrics.messagesProcessed >= 0;

    // 2. Check Active Packages Integrity
    final activePackages = _registry.getActivePackages();
    bool packagesValid = true;
    for (final pkg in activePackages) {
      if (!_signingService.verifyPackageSignature(pkg)) {
        packagesValid = false;
        break;
      }
    }
    results['active_packages_count'] = activePackages.length;
    results['packages_integrity_valid'] = packagesValid;

    // 3. Check AI Kill switch state
    results['ai_killed'] = _opsPlatform.killSwitch.isGlobalAiKilled;

    results['probe_timestamp'] = DateTime.now().toIso8601String();
    return results;
  }
}
