import 'dart:async';
import 'package:equatable/equatable.dart';

enum NetworkStatus {
  online,
  offline,
}

/// Abstract contract for checking network availability.
/// Strictly supports the offline-first architecture.
abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<NetworkStatus> get onStatusChanged;
}

/// Testable network info implementation.
class TestNetworkInfo implements NetworkInfo {
  bool _isConnected;
  final StreamController<NetworkStatus> _controller = StreamController<NetworkStatus>.broadcast();

  TestNetworkInfo({bool initialConnected = true}) : _isConnected = initialConnected;

  @override
  Future<bool> get isConnected async => _isConnected;

  @override
  Stream<NetworkStatus> get onStatusChanged => _controller.stream;

  void setConnected(bool connected) {
    _isConnected = connected;
    _controller.add(connected ? NetworkStatus.online : NetworkStatus.offline);
  }

  void dispose() {
    _controller.close();
  }
}

/// Retry policy parameters for optional network calls.
class RetryPolicy extends Equatable {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;

  const RetryPolicy({
    this.maxRetries = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.backoffMultiplier = 2.0,
  });

  @override
  List<Object?> get props => [maxRetries, initialDelay, backoffMultiplier];
}
