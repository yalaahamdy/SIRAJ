import '../models/canonical_content_package.dart';
import '../models/human_review_record.dart';

/// Central immutable registry tracking canonical packages and review audit history (§4, §39, §40).
class CanonicalContentRegistry {
  final Map<String, CanonicalContentPackage> _packages = {};
  final List<HumanReviewRecord> _reviewAuditTrail = [];

  CanonicalContentRegistry();

  /// Registers or updates a package in the registry.
  void registerPackage(CanonicalContentPackage package) {
    _packages[package.packageId] = package;
  }

  /// Appends a human review record immutably to the audit trail (§39, §40).
  void recordHumanReview(HumanReviewRecord record) {
    _reviewAuditTrail.add(record);
  }

  /// Retrieves a package by ID.
  CanonicalContentPackage? getPackage(String packageId) => _packages[packageId];

  /// Returns all registered packages.
  List<CanonicalContentPackage> getAllPackages() => List.unmodifiable(_packages.values);

  /// Returns all active packages.
  List<CanonicalContentPackage> getActivePackages() =>
      _packages.values.where((p) => p.isActive).toList();

  /// Returns immutable audit records for a package.
  List<HumanReviewRecord> getAuditTrailForPackage(String packageId) =>
      _reviewAuditTrail.where((r) => r.packageId == packageId).toList();
}
