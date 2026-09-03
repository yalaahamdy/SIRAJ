/// Service managing multi-dimensional rate limits and token budgets (§45, §47, §106).
class BotQuotaService {
  final int maxRequestsPerMinutePerUser;
  final int maxRequestsPerMinutePerChannel;
  final Map<String, List<DateTime>> _userTimestamps = {};
  final Map<String, List<DateTime>> _channelTimestamps = {};

  BotQuotaService({
    this.maxRequestsPerMinutePerUser = 20,
    this.maxRequestsPerMinutePerChannel = 200,
  });

  bool checkAndConsumeUserQuota(String userId) {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

    final history = _userTimestamps.putIfAbsent(userId, () => []);
    history.removeWhere((t) => t.isBefore(oneMinuteAgo));

    if (history.length >= maxRequestsPerMinutePerUser) {
      return false;
    }

    history.add(now);
    return true;
  }

  bool checkAndConsumeChannelQuota(String channelName) {
    final now = DateTime.now();
    final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

    final history = _channelTimestamps.putIfAbsent(channelName, () => []);
    history.removeWhere((t) => t.isBefore(oneMinuteAgo));

    if (history.length >= maxRequestsPerMinutePerChannel) {
      return false;
    }

    history.add(now);
    return true;
  }

  void reset() {
    _userTimestamps.clear();
    _channelTimestamps.clear();
  }
}
