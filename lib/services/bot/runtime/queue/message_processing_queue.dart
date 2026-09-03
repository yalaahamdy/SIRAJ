import '../../domain/unified_message.dart';

/// Representation of a queued inbound message item (§43, §44).
class QueuedMessageItem {
  final String id;
  final UnifiedIncomingMessage message;
  final int retryCount;
  final DateTime enqueuedAt;
  final String? failureReason;

  QueuedMessageItem({
    required this.id,
    required this.message,
    this.retryCount = 0,
    required this.enqueuedAt,
    this.failureReason,
  });

  QueuedMessageItem copyWith({
    int? retryCount,
    String? failureReason,
  }) {
    return QueuedMessageItem(
      id: id,
      message: message,
      retryCount: retryCount ?? this.retryCount,
      enqueuedAt: enqueuedAt,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}

/// In-memory queue manager supporting message retries and Dead-Letter Queue (DLQ) (§43, §44).
class MessageProcessingQueue {
  final List<QueuedMessageItem> _queue = [];
  final List<QueuedMessageItem> _deadLetterQueue = [];
  final int maxRetries;

  MessageProcessingQueue({this.maxRetries = 3});

  int get queueLength => _queue.length;
  int get dlqLength => _deadLetterQueue.length;
  List<QueuedMessageItem> get dlqItems => List.unmodifiable(_deadLetterQueue);

  void enqueue(UnifiedIncomingMessage message) {
    _queue.add(QueuedMessageItem(
      id: message.messageId,
      message: message,
      enqueuedAt: DateTime.now().toUtc(),
    ));
  }

  QueuedMessageItem? dequeue() {
    if (_queue.isEmpty) return null;
    return _queue.removeAt(0);
  }

  void handleProcessingFailure(QueuedMessageItem item, String reason) {
    if (item.retryCount + 1 >= maxRetries) {
      // Move to Dead Letter Queue (§44)
      _deadLetterQueue.add(item.copyWith(
        retryCount: item.retryCount + 1,
        failureReason: reason,
      ));
    } else {
      // Re-enqueue with incremented retry count
      _queue.add(item.copyWith(
        retryCount: item.retryCount + 1,
        failureReason: reason,
      ));
    }
  }

  void clear() {
    _queue.clear();
    _deadLetterQueue.clear();
  }
}
