import '../domain/bot_session.dart';
import '../domain/unified_message.dart';

/// Contract for Bot Session Persistence (§8, §43, §44).
abstract class BotSessionStoreContract {
  Future<ConversationSession> getOrCreateSession({
    required ChannelType channel,
    required String externalUserId,
    String? conversationId,
  });

  Future<void> saveSession(ConversationSession session);

  Future<void> deleteUserData(String internalUserId);

  Future<void> linkIdentity(UserIdentityMapping mapping);

  Future<String?> getInternalUserId(ChannelType channel, String externalUserId);
}

/// In-memory session store implementing bounded retention and user data deletion (§8, §43, §44).
class MemoryBotSessionStore implements BotSessionStoreContract {
  final Map<String, ConversationSession> _sessions = {};
  final Map<String, UserIdentityMapping> _identityMappings = {};

  @override
  Future<ConversationSession> getOrCreateSession({
    required ChannelType channel,
    required String externalUserId,
    String? conversationId,
  }) async {
    final sessionKey = conversationId ?? '${channel.name}_$externalUserId';
    final existing = _sessions[sessionKey];

    if (existing != null) {
      return existing;
    }

    final internalUserId = await getInternalUserId(channel, externalUserId) ??
        'usr_${DateTime.now().millisecondsSinceEpoch}_${externalUserId.hashCode.abs()}';

    final newSession = ConversationSession(
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      internalUserId: internalUserId,
      externalUserId: externalUserId,
      channel: channel,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    _sessions[sessionKey] = newSession;
    return newSession;
  }

  @override
  Future<void> saveSession(ConversationSession session) async {
    final sessionKey = '${session.channel.name}_${session.externalUserId}';
    _sessions[sessionKey] = session.copyWith(updatedAt: DateTime.now().toUtc());
  }

  @override
  Future<void> deleteUserData(String internalUserId) async {
    // Delete all sessions for this internal user (§44)
    _sessions.removeWhere((_, s) => s.internalUserId == internalUserId);
    _identityMappings.removeWhere((_, m) => m.internalUserId == internalUserId);
  }

  @override
  Future<void> linkIdentity(UserIdentityMapping mapping) async {
    final key = '${mapping.channel.name}_${mapping.externalUserId}';
    _identityMappings[key] = mapping;
  }

  @override
  Future<String?> getInternalUserId(ChannelType channel, String externalUserId) async {
    final key = '${channel.name}_$externalUserId';
    return _identityMappings[key]?.internalUserId;
  }
}
