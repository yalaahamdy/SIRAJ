import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/events/app_events.dart';
import 'package:siraj/core/events/event_bus.dart';

void main() {
  group('L0 EventBus Tests', () {
    late EventBus bus;

    setUp(() {
      bus = EventBus(sync: true);
    });

    tearDown(() async {
      await bus.dispose();
    });

    test('Publishes and receives events of specific subtype', () async {
      final received = <DayChangedEvent>[];
      bus.on<DayChangedEvent>().listen(received.add);

      final event = DayChangedEvent(DateTime.utc(2026, 8, 31));
      bus.publish(event);

      expect(received.length, equals(1));
      expect(received.first.eventName, equals('core.time.dayChanged'));
      expect(received.first.newDay, equals(DateTime.utc(2026, 8, 31)));
    });

    test('Does not deliver mismatched event types to filtered listener', () async {
      final received = <DayChangedEvent>[];
      bus.on<DayChangedEvent>().listen(received.add);

      bus.publish(TimezoneChangedEvent('Asia/Riyadh'));
      bus.publish(PackageInstalledEvent(packageId: 'PKG-1', version: '1.0'));

      expect(received, isEmpty);
    });

    test('Global stream receives all published events', () async {
      final all = <AppEvent>[];
      bus.stream.listen(all.add);

      bus.publish(DayChangedEvent(DateTime.utc(2026, 8, 31)));
      bus.publish(PackageRejectedEvent(packageId: 'PKG-X', reason: 'Corrupt'));

      expect(all.length, equals(2));
      expect(all.last.eventName, equals('content.package.rejected'));
    });
  });
}
