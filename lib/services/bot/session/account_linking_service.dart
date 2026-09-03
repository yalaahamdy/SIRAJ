import 'dart:math';
import '../domain/bot_error.dart';
import '../domain/bot_session.dart';
import '../domain/unified_message.dart';
import 'bot_session_store.dart';

/// Single-use cryptographically bound linking code record (§40, §41).
class LinkingCodeRecord {
  final String code;
  final String internalUserId;
  final DateTime expiresAt;
  int failedAttempts;

  LinkingCodeRecord({
    required this.code,
    required this.internalUserId,
    required this.expiresAt,
    this.failedAttempts = 0,
  });

  bool get isExpired => DateTime.now().toUtc().isAfter(expiresAt);
}

/// Service managing secure, short-lived, single-use account linking between external channels and SIRAJ internal accounts (§40, §41).
class AccountLinkingService {
  final BotSessionStoreContract _sessionStore;
  final Map<String, LinkingCodeRecord> _activeCodes = {};
  final Duration codeValidity;
  final int maxFailedAttempts;

  AccountLinkingService({
    required BotSessionStoreContract sessionStore,
    this.codeValidity = const Duration(minutes: 5),
    this.maxFailedAttempts = 3,
  }) : _sessionStore = sessionStore;

  /// Generates a secure 6-digit one-time linking code from inside the trusted SIRAJ app (§40).
  String generateLinkingCode(String internalUserId) {
    // Generate secure 6-digit random code
    final rng = Random.secure();
    final code = (100000 + rng.nextInt(900000)).toString();

    _activeCodes[code] = LinkingCodeRecord(
      code: code,
      internalUserId: internalUserId,
      expiresAt: DateTime.now().toUtc().add(codeValidity),
    );

    return code;
  }

  /// Consumes and verifies linking code submitted via bot channel (§40).
  Future<bool> linkChannelAccount({
    required String code,
    required ChannelType channel,
    required String externalUserId,
  }) async {
    final record = _activeCodes[code];

    if (record == null) {
      throw const SafeBotException(BotFailureReason.safetyBlock, 'Invalid or non-existent linking code');
    }

    if (record.isExpired) {
      _activeCodes.remove(code);
      throw const SafeBotException(BotFailureReason.safetyBlock, 'Expired linking code');
    }

    if (record.failedAttempts >= maxFailedAttempts) {
      _activeCodes.remove(code);
      throw const SafeBotException(BotFailureReason.safetyBlock, 'Linking code locked due to too many failed attempts');
    }

    // Success: Link identity and purge code immediately (Single-Use)
    _activeCodes.remove(code);

    final mapping = UserIdentityMapping(
      internalUserId: record.internalUserId,
      channel: channel,
      externalUserId: externalUserId,
      linkedAt: DateTime.now().toUtc(),
    );

    await _sessionStore.linkIdentity(mapping);
    return true;
  }

  void purgeExpiredCodes() {
    _activeCodes.removeWhere((_, r) => r.isExpired);
  }
}
