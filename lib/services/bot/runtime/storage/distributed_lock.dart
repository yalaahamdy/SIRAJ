/// Contract for distributed locking to prevent duplicate concurrent processing (§29, §30).
abstract class DistributedLockContract {
  Future<bool> acquireLock(String resourceKey, {Duration ttl = const Duration(seconds: 10)});
  Future<void> releaseLock(String resourceKey);
}

class LockRecord {
  final String key;
  final DateTime expiresAt;

  LockRecord({required this.key, required this.expiresAt});

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);
}

/// In-memory implementation of DistributedLock for local sandbox runtime (§30).
class MemoryDistributedLock implements DistributedLockContract {
  final Map<String, LockRecord> _locks = {};

  @override
  Future<bool> acquireLock(String resourceKey, {Duration ttl = const Duration(seconds: 10)}) async {
    final now = DateTime.now().toUtc();
    final existing = _locks[resourceKey];

    if (existing != null && !existing.isExpired) {
      return false; // Already locked
    }

    _locks[resourceKey] = LockRecord(
      key: resourceKey,
      expiresAt: now.add(ttl),
    );
    return true;
  }

  @override
  Future<void> releaseLock(String resourceKey) async {
    _locks.remove(resourceKey);
  }
}
