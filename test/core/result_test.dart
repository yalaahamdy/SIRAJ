import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/errors/app_failure.dart';
import 'package:siraj/core/errors/result.dart';

void main() {
  group('L0 Result<T, E> Monadic Tests', () {
    test('Success value inspection and fold', () {
      final Result<int, SystemFailure> res = Result.ok(42);

      expect(res.isSuccess, isTrue);
      expect(res.isFailure, isFalse);
      expect(res.valueOrNull, equals(42));
      expect(res.failureOrNull, isNull);

      final folded = res.fold(
        onSuccess: (v) => 'Value: $v',
        onFailure: (f) => 'Failed',
      );
      expect(folded, equals('Value: 42'));
    });

    test('Err value inspection and fold', () {
      final failure = const SystemFailure(message: 'Fatal error');
      final Result<int, SystemFailure> res = Result.err(failure);

      expect(res.isSuccess, isFalse);
      expect(res.isFailure, isTrue);
      expect(res.valueOrNull, isNull);
      expect(res.failureOrNull, equals(failure));

      final folded = res.fold(
        onSuccess: (v) => 'Value: $v',
        onFailure: (f) => 'Failed: ${f.message}',
      );
      expect(folded, equals('Failed: Fatal error'));
    });

    test('Map and FlatMap preserve success/failure semantics', () {
      final Result<int, SystemFailure> res = Result.ok(10);

      final mapped = res.map((v) => v * 2);
      expect(mapped.valueOrNull, equals(20));

      final flatMapped = res.flatMap((v) => Result.ok('Num: $v'));
      expect(flatMapped.valueOrNull, equals('Num: 10'));

      final Result<int, SystemFailure> errRes = Result.err(const SystemFailure(message: 'fail'));
      final mappedErr = errRes.map((v) => v * 2);
      expect(mappedErr.isFailure, isTrue);
    });

    test('getOrThrow throws on failure and returns value on success', () {
      final ok = Result.ok('data');
      expect(ok.getOrThrow(), equals('data'));

      final err = Result.err(const ConfigFailure(message: 'invalid'));
      expect(() => err.getOrThrow(), throwsA(isA<ConfigFailure>()));
    });
  });
}
