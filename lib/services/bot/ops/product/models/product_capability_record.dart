import 'package:equatable/equatable.dart';

/// Status of a product capability (§2).
enum CapabilityStatus {
  implemented,
  partiallyImplemented,
  deferred,
  planned,
  missing,
  notRecommended,
}

/// Priority class of a product capability (§77).
enum CapabilityPriority {
  p0Critical,
  p1Core,
  p2Valuable,
  p3Optional,
  p4Reject,
}

/// Structured Product Capability Record (§2, §76, §77, §80).
class ProductCapabilityRecord extends Equatable {
  final String capabilityId;
  final String titleArabic;
  final String associatedModule;
  final CapabilityStatus status;
  final CapabilityPriority priority;
  final double userValueScore; // 1.0 to 10.0
  final double effortScore; // 1.0 to 10.0
  final bool isSafetyCompliant;
  final bool isPrivacyCompliant;
  final String descriptionArabic;

  const ProductCapabilityRecord({
    required this.capabilityId,
    required this.titleArabic,
    required this.associatedModule,
    required this.status,
    required this.priority,
    required this.userValueScore,
    required this.effortScore,
    this.isSafetyCompliant = true,
    this.isPrivacyCompliant = true,
    required this.descriptionArabic,
  });

  @override
  List<Object?> get props => [
        capabilityId,
        titleArabic,
        associatedModule,
        status,
        priority,
        userValueScore,
        effortScore,
        isSafetyCompliant,
        isPrivacyCompliant,
        descriptionArabic,
      ];
}
