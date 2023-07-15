import 'package:dart_super/dart_super.dart';
import 'package:test/test.dart';

void main() {
  group('SuperExt', () {
    setUp(() {
      Super.activate(
        testMode: true,
        enableLog: true,
      );
    });

    test('SuperExt - create', () {
      Super.create<String>('Hello');

      expect(Super.of<String>(), 'Hello');

      Super.log('Test Complete');
    });

    test('SuperExt - deleteAll', () {
      Super.deleteAll();

      expect(
        () => Super.of<String>(),
        throwsA(isA<StateError>()),
      );
    });

    test('SuperExt - deactivate', () {
      expect(Super.isScoped, isTrue);

      Super.deactivate();

      expect(Super.isScoped, isFalse);
    });
  });
}
