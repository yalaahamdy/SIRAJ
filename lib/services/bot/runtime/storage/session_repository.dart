import '../../domain/bot_session.dart';

/// Contract for durable session repository (§28, §31).
abstract class SessionRepositoryContract {
  Future<ConversationSession?> getSession(String sessionKey);
  Future<void> saveSession(String sessionKey, ConversationSession session);
  Future<void> deleteSession(String sessionKey);
  Future<void> deleteUserSessions(String internalUserId);
  Future<List<ConversationSession>> getAllSessions();
}

/// In-memory implementation of SessionRepository for sandbox testing (§28).
class MemorySessionRepository implements SessionRepositoryContract {
  final Map<String, ConversationSession> _sessions = {};

  @override
  Future<ConversationSession?> getSession(String sessionKey) async {
    return _sessions[sessionKey];
  }

  @override
  Future<void> saveSession(String sessionKey, ConversationSession session) async {
    _sessions[sessionKey] = session;
  }

  @override
  Future<void> deleteSession(String sessionKey) async {
    _sessions.remove(sessionKey);
  }

  @override
  Future<void> deleteUserSessions(String internalUserId) async {
    _sessions.removeWhere((_, s) => s.internalUserId == internalUserId);
  }

  @override
  Future<List<ConversationSession>> getAllSessions() async {
    return _sessions.values.toList();
  }
}
