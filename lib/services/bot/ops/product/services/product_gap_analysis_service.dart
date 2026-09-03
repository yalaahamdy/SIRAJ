import '../models/product_capability_record.dart';

/// Service analyzing product capability coverage, gaps, and roadmap priorities (§0, §2, §75, §78).
class ProductGapAnalysisService {
  final Map<String, ProductCapabilityRecord> _capabilities = {};

  List<ProductCapabilityRecord> get allCapabilities => _capabilities.values.toList();

  /// Registers a capability record.
  void registerCapability(ProductCapabilityRecord capability) {
    _capabilities[capability.capabilityId] = capability;
  }

  /// Calculates capability implementation ratio (§75).
  double calculateCompletenessRatio() {
    if (_capabilities.isEmpty) return 0.0;
    final implemented = _capabilities.values.where((c) => c.status == CapabilityStatus.implemented).length;
    return (implemented / _capabilities.length) * 100.0;
  }

  /// Filters capabilities by status.
  List<ProductCapabilityRecord> getCapabilitiesByStatus(CapabilityStatus status) {
    return _capabilities.values.where((c) => c.status == status).toList();
  }

  /// Returns prioritized roadmap items (P0 to P3 only, excluding rejected P4) (§77, §80).
  List<ProductCapabilityRecord> getPrioritizedRoadmap() {
    final list = _capabilities.values
        .where((c) => c.priority != CapabilityPriority.p4Reject && c.status != CapabilityStatus.implemented)
        .toList();

    list.sort((a, b) => b.userValueScore.compareTo(a.userValueScore));
    return list;
  }
}
