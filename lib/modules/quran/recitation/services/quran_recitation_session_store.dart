import 'dart:convert';
import '../../../../core/storage/storage_contract.dart';
import '../domain/quran_recitation_session.dart';

/// Storage service for persisting Quran recitation sessions locally (§7, §13).
/// Operates under the isolated 'mod_quran_recitation' namespace in the StorageRegistry.
class QuranRecitationSessionStore {
  final StorageRegistry _storageRegistry;
  static const String _namespace = 'mod_quran_recitation';
  static const String _lastSessionKey = 'last_recitation_session';

  QuranRecitationSessionStore({required StorageRegistry storageRegistry})
      : _storageRegistry = storageRegistry;

  KeyValueStore get _storage => _storageRegistry.getStoreForModule(_namespace);

  /// Saves the most recent recitation session.
  Future<void> saveLastSession(QuranRecitationSession session) async {
    final jsonStr = jsonEncode(session.toJson());
    await _storage.setString(_lastSessionKey, jsonStr);
  }

  /// Retrieves the last recorded or recognized recitation session, if any.
  Future<QuranRecitationSession?> getLastSession() async {
    final res = await _storage.getString(_lastSessionKey);
    if (res.isFailure || res.valueOrNull == null || res.valueOrNull!.isEmpty) {
      return null;
    }

    try {
      final map = jsonDecode(res.valueOrNull!) as Map<String, dynamic>;
      return QuranRecitationSession.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Clears the last session record.
  Future<void> clearLastSession() async {
    await _storage.remove(_lastSessionKey);
  }
}
