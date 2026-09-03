import 'package:equatable/equatable.dart';

/// Explicit 5-Point Production Authorization Record (§5, §6).
class ProductionAuthorization extends Equatable {
  final String authorizationId;
  final String releaseId;
  final bool technicalApproval;
  final bool contentApproval;
  final bool securityApproval;
  final bool operationsApproval;
  final bool productApproval;
  final bool finalAuthorization;
  final DateTime? authorizedAt;
  final String? authorizedBy;
  final Map<String, dynamic> metadata;

  const ProductionAuthorization({
    required this.authorizationId,
    required this.releaseId,
    this.technicalApproval = false,
    this.contentApproval = false,
    this.securityApproval = false,
    this.operationsApproval = false,
    this.productApproval = false,
    this.finalAuthorization = false,
    this.authorizedAt,
    this.authorizedBy,
    this.metadata = const {},
  });

  bool get isFullyAuthorized =>
      technicalApproval &&
      contentApproval &&
      securityApproval &&
      operationsApproval &&
      productApproval &&
      finalAuthorization &&
      authorizedBy != null &&
      authorizedBy!.isNotEmpty;

  ProductionAuthorization copyWith({
    String? authorizationId,
    String? releaseId,
    bool? technicalApproval,
    bool? contentApproval,
    bool? securityApproval,
    bool? operationsApproval,
    bool? productApproval,
    bool? finalAuthorization,
    DateTime? authorizedAt,
    String? authorizedBy,
    Map<String, dynamic>? metadata,
  }) {
    return ProductionAuthorization(
      authorizationId: authorizationId ?? this.authorizationId,
      releaseId: releaseId ?? this.releaseId,
      technicalApproval: technicalApproval ?? this.technicalApproval,
      contentApproval: contentApproval ?? this.contentApproval,
      securityApproval: securityApproval ?? this.securityApproval,
      operationsApproval: operationsApproval ?? this.operationsApproval,
      productApproval: productApproval ?? this.productApproval,
      finalAuthorization: finalAuthorization ?? this.finalAuthorization,
      authorizedAt: authorizedAt ?? this.authorizedAt,
      authorizedBy: authorizedBy ?? this.authorizedBy,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        authorizationId,
        releaseId,
        technicalApproval,
        contentApproval,
        securityApproval,
        operationsApproval,
        productApproval,
        finalAuthorization,
        authorizedAt,
        authorizedBy,
        metadata,
      ];
}
