import '../../domain/unified_message.dart';

/// Access restriction manager ensuring only registered test users can interact with Staging channels (§46, §47).
class StagingAllowlist {
  final Set<String> _allowedUserIds = {};
  bool _enforceAllowlist;

  StagingAllowlist({
    bool enforceAllowlist = true,
    Set<String>? initialAllowedUsers,
  }) : _enforceAllowlist = enforceAllowlist {
    if (initialAllowedUsers != null) {
      _allowedUserIds.addAll(initialAllowedUsers);
    }
  }

  bool get isEnforced => _enforceAllowlist;

  void setEnforce(bool enforce) {
    _enforceAllowlist = enforce;
  }

  void addAllowedUser(String userId) {
    _allowedUserIds.add(userId);
  }

  void removeAllowedUser(String userId) {
    _allowedUserIds.remove(userId);
  }

  bool isAllowed(ChannelType channel, String externalUserId) {
    if (!_enforceAllowlist) return true;
    final key = '${channel.name}_$externalUserId';
    return _allowedUserIds.contains(externalUserId) || _allowedUserIds.contains(key);
  }

  List<String> getAllowedUsers() => _allowedUserIds.toList();
}
