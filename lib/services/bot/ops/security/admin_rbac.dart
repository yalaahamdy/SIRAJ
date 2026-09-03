/// Administrative Roles for Bot Platform Management (§21, §22).
enum AdminRole {
  viewer,
  operator,
  developer,
  securityReviewer,
  contentReviewer,
  productOwner;

  bool canViewMetrics() => true;

  bool canToggleChannels() => this == AdminRole.operator || this == AdminRole.productOwner;

  bool canRotateSecrets() => this == AdminRole.securityReviewer;

  bool canTriggerKillSwitch() =>
      this == AdminRole.operator || this == AdminRole.securityReviewer || this == AdminRole.productOwner;

  bool canManageAllowlist() => this == AdminRole.operator || this == AdminRole.developer;

  bool canModifyReligiousContent() => false; // Strictly forbidden for operational admin roles (§22)
}

/// Verifies administrative permissions before executing control panel operations (§21, §22).
class AdminRBAC {
  static bool hasPermission(AdminRole role, String action) {
    switch (action) {
      case 'VIEW_METRICS':
        return role.canViewMetrics();
      case 'TOGGLE_CHANNEL':
        return role.canToggleChannels();
      case 'ROTATE_SECRETS':
        return role.canRotateSecrets();
      case 'TRIGGER_KILL_SWITCH':
        return role.canTriggerKillSwitch();
      case 'MANAGE_ALLOWLIST':
        return role.canManageAllowlist();
      case 'MODIFY_RELIGIOUS_TEXTS':
        return false; // Absolute Zero Authorization for Operations
      default:
        return false;
    }
  }
}
