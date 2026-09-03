import '../storage/idempotency_store.dart';
import '../../session/account_linking_service.dart';

/// Periodic retention and cleanup scheduler (§45, §46).
class RetentionScheduler {
  final IdempotencyStoreContract _idempotencyStore;
  final AccountLinkingService _accountLinkingService;

  RetentionScheduler({
    required IdempotencyStoreContract idempotencyStore,
    required AccountLinkingService accountLinkingService,
  })  : _idempotencyStore = idempotencyStore,
        _accountLinkingService = accountLinkingService;

  /// Executes all retention & cleanup sweeps.
  Future<void> runCleanupCycle() async {
    // 1. Purge expired idempotency keys
    await _idempotencyStore.purgeExpired();

    // 2. Purge expired account linking codes
    _accountLinkingService.purgeExpiredCodes();
  }
}
