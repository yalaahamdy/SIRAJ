/// Contract for durable idempotency storage (§27, §57).
abstract class IdempotencyStoreContract {
  Future<bool> checkAndRegisterKey(String key, {Duration ttl = const Duration(hours: 24)});
  Future<void> removeKey(String key);
  Future<void> purgeExpired();
}

class IdempotencyRecord {
  final String key;
  final DateTime expiresAt;

  IdempotencyRecord({required this.key, required this.expiresAt});

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);
}

/// In-memory implementation of idempotency store for local sandbox (§27).
class MemoryIdempotencyStore implements IdempotencyStoreContract {
  final Map<String, IdempotencyRecord> _store = {};

  @override
  Future<bool> checkAndRegisterKey(String key, {Duration ttl = const Duration(hours: 24)}) async {
    purgeExpiredInternal();
    if (_store.containsKey(key)) {
      final record = _store[key]!;
      if (!record.isExpired) {
        return false; // Key exists and is valid -> duplicate
      }
    }

    _store[key] = IdempotencyRecord(
      key: key,
      expiresAt: DateTime.now().toUtc().add(ttl),
    );
    return true; // Successfully registered
  }

  @override
  Future<void> removeKey(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> purgeExpired() async {
    purgeExpiredInternal();
  }

  void purgeExpiredInternal() {
    _store.removeWhere((_, r) => r.isExpired);
  }
}
