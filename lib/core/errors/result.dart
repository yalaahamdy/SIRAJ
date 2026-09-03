import 'package:equatable/equatable.dart';
import 'app_failure.dart';

/// A monadic Result type representing either a successful value [T] or a [Failure] [E].
/// Designed to enforce explicit error checking and eliminate uncontrolled null/exception bubbling.
abstract class Result<T, E extends Failure> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Err<T, E>;

  T? get valueOrNull => isSuccess ? (this as Success<T, E>).value : null;
  E? get failureOrNull => isFailure ? (this as Err<T, E>).failure : null;

  /// Fold executes [onSuccess] if this is Success, or [onFailure] if this is Err.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E failure) onFailure,
  }) {
    if (isSuccess) {
      return onSuccess((this as Success<T, E>).value);
    } else {
      return onFailure((this as Err<T, E>).failure);
    }
  }

  /// Transforms the success value using [transform].
  Result<R, E> map<R>(R Function(T value) transform) {
    if (isSuccess) {
      return Success(transform((this as Success<T, E>).value));
    } else {
      return Err((this as Err<T, E>).failure);
    }
  }

  /// Flat-maps another Result-producing function.
  Result<R, E> flatMap<R>(Result<R, E> Function(T value) transform) {
    if (isSuccess) {
      return transform((this as Success<T, E>).value);
    } else {
      return Err((this as Err<T, E>).failure);
    }
  }

  /// Returns the success value or throws if it's a failure (use with care).
  T getOrThrow() {
    if (isSuccess) {
      return (this as Success<T, E>).value;
    } else {
      throw (this as Err<T, E>).failure;
    }
  }

  /// Factory constructors
  static Result<T, E> ok<T, E extends Failure>(T value) => Success<T, E>(value);
  static Result<T, E> err<T, E extends Failure>(E failure) => Err<T, E>(failure);
}

/// Represents a successful computation.
class Success<T, E extends Failure> extends Result<T, E> {
  final T value;

  const Success(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Success($value)';
}

/// Represents a failed computation.
class Err<T, E extends Failure> extends Result<T, E> {
  final E failure;

  const Err(this.failure);

  @override
  List<Object?> get props => [failure];

  @override
  String toString() => 'Err($failure)';
}
