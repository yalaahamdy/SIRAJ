/// Canonical governance status ladder according to CONTENT_GOVERNANCE.md.
enum ContentStatus {
  /// Initial draft, may be incomplete or unreviewed. Never shown to end-users.
  draft,

  /// Candidate sources researched and documented.
  researched,

  /// Text matches source exactly with complete metadata (automated rule check).
  verified,

  /// Mandatory intermediate stage waiting for named human reviewer.
  humanReviewRequired,

  /// Signed off by designated human reviewer after source matching.
  approved,

  /// Approved and cryptographically frozen in a signed package.
  locked,

  /// Removed from active circulation with documented rationale.
  deprecated,

  /// Suspected error or unverified claim. Immediately halted across all paths.
  quarantined,
}

/// Helper extension providing governance transition validations.
extension ContentStatusX on ContentStatus {
  /// True if the content is safe to display in public end-user interfaces.
  bool get isPubliclyDisplayable =>
      this == ContentStatus.approved || this == ContentStatus.locked;

  /// True if the record is cryptographically frozen and immutable.
  bool get isLocked => this == ContentStatus.locked;

  /// True if the record is under active quarantine.
  bool get isQuarantined => this == ContentStatus.quarantined;

  /// Checks if a transition from `this` status to `next` status is legally valid.
  bool canTransitionTo(ContentStatus next, {bool isHumanReviewer = false}) {
    // Quarantined can be triggered from ANY state by anyone
    if (next == ContentStatus.quarantined) return true;

    // Locked records cannot transition directly; must be cloned to a new DRAFT version
    if (this == ContentStatus.locked) {
      return next == ContentStatus.deprecated;
    }

    switch (this) {
      case ContentStatus.draft:
        return next == ContentStatus.researched;

      case ContentStatus.researched:
        return next == ContentStatus.verified;

      case ContentStatus.verified:
        // System must transition to humanReviewRequired before approval
        return next == ContentStatus.humanReviewRequired;

      case ContentStatus.humanReviewRequired:
        // Only human reviewer can transition to approved
        return isHumanReviewer && (next == ContentStatus.approved || next == ContentStatus.draft);

      case ContentStatus.approved:
        return next == ContentStatus.locked || next == ContentStatus.deprecated;

      case ContentStatus.deprecated:
        return false;

      case ContentStatus.quarantined:
        // Exiting quarantine requires explicit human review back to draft or deprecated
        return isHumanReviewer && (next == ContentStatus.draft || next == ContentStatus.deprecated);

      case ContentStatus.locked:
        return next == ContentStatus.deprecated;
    }
  }
}
