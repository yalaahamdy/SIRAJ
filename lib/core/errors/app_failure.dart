import 'package:equatable/equatable.dart';

/// Base class for all domain and platform failures in SIRAJ.
/// Strictly typed to support deterministic error handling and Fail-Closed semantics.
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic cause;

  const Failure({
    required this.message,
    this.code,
    this.cause,
  });

  @override
  List<Object?> get props => [message, code, cause];

  @override
  String toString() => '$runtimeType(message: $message, code: $code)';
}

/// Generic system or unexpected failure.
class SystemFailure extends Failure {
  const SystemFailure({
    required super.message,
    super.code = 'SYSTEM_ERROR',
    super.cause,
  });
}

/// Configuration related failures.
class ConfigFailure extends Failure {
  const ConfigFailure({
    required super.message,
    super.code = 'CONFIG_ERROR',
    super.cause,
  });
}

/// Time abstraction failures (e.g. invalid date conversion or out of bounds).
class TimeFailure extends Failure {
  const TimeFailure({
    required super.message,
    super.code = 'TIME_ERROR',
    super.cause,
  });
}

/// Storage & persistence failures.
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.cause,
  });
}

/// Network failures.
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.cause,
  });
}

/// Content verification, integrity, or governance failures (Sacred Content Firewall).
class ContentIntegrityFailure extends Failure {
  const ContentIntegrityFailure({
    required super.message,
    super.code = 'CONTENT_INTEGRITY_VIOLATION',
    super.cause,
  });
}

/// Content governance transition failures (e.g. unverified content access attempt).
class GovernanceViolationFailure extends Failure {
  const GovernanceViolationFailure({
    required super.message,
    super.code = 'GOVERNANCE_VIOLATION',
    super.cause,
  });
}

/// Content not found failure.
class ContentNotFoundFailure extends Failure {
  const ContentNotFoundFailure({
    required super.message,
    super.code = 'CONTENT_NOT_FOUND',
    super.cause,
  });
}

/// Package signature or checksum mismatch failure.
class PackageVerificationFailure extends Failure {
  const PackageVerificationFailure({
    required super.message,
    super.code = 'PACKAGE_VERIFICATION_FAILED',
    super.cause,
  });
}
