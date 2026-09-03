import 'dart:async';
import 'app_events.dart';

/// Central In-Memory Event Bus for cross-module decoupling.
/// All events are local, deterministic, and typed.
class EventBus {
  final StreamController<AppEvent> _controller;

  EventBus({bool sync = false})
      : _controller = StreamController<AppEvent>.broadcast(sync: sync);

  /// Publishes an event to all subscribers.
  void publish(AppEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Listens to all events.
  Stream<AppEvent> get stream => _controller.stream;

  /// Listens exclusively to events of type [T].
  Stream<T> on<T extends AppEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  /// Disposes the event bus.
  Future<void> dispose() async {
    await _controller.close();
  }
}
