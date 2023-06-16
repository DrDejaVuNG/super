import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Result - Success', () async {
    final future = Future<int>.value(10);

    await expectLater(
      future.result<Object, int>(
        (error) {
          fail('Should not execute the onError callback.');
        },
        (result) {
          expect(result, equals(10));
        },
      ),
      completes,
    );
  });

  test('Result - Error', () async {
    final future = Future<int>.error('Error');

    await expectLater(
      future.result<Object, int>(
        (error) {
          expect(error, equals('Error'));
        },
        (result) {
          fail('Should not execute the onSuccess callback.');
        },
      ),
      completes,
    );
  });
}
