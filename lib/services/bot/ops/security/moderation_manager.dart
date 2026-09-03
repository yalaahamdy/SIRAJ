/// Abuse detection and user blocking without religious profiling (§26, §27).
class ModerationManager {
  final Set<String> _blockedUserIds = {};
  final Map<String, int> _messageFrequencies = {};

  bool isUserBlocked(String userId) => _blockedUserIds.contains(userId);

  void blockUser(String userId) {
    _blockedUserIds.add(userId);
  }

  void unblockUser(String userId) {
    _blockedUserIds.remove(userId);
  }

  /// Records request and triggers temporary blocking if rapid flood threshold is breached (§26).
  bool checkFloodAndRecord(String userId, {int threshold = 20}) {
    if (isUserBlocked(userId)) return false;

    final count = (_messageFrequencies[userId] ?? 0) + 1;
    _messageFrequencies[userId] = count;

    if (count > threshold) {
      blockUser(userId);
      return false;
    }

    return true;
  }

  void resetFrequencies() {
    _messageFrequencies.clear();
  }
}
