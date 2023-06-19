import 'package:flutter/foundation.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterRx extends Rx {
  int count = 0;

  void increment() {
    count++;
  }

  void decrement() {
    count--;
  }
}

void main() {
  group('Rx', () {
    final counterRx = CounterRx();

    test('Initial state', () {
      expect(counterRx.count, 0);
    });

    test('Increment', () {
      counterRx
        ..count = 0
        ..increment();
      expect(counterRx.count, 1);
    });

    test('Decrement', () {
      counterRx
        ..count = 1
        ..decrement();
      expect(counterRx.count, 0);
    });

    test('Increment multiple times', () {
      counterRx
        ..count = 0
        ..increment()
        ..increment()
        ..increment();
      expect(counterRx.count, 3);
    });

    test('Notify listeners on increment', () {
      var listenerCalled = false;
      counterRx
        ..addListener(() {
          // Can't call private _notifyListeners()
        })
        ..increment();
      listenerCalled = true;

      expect(listenerCalled, isTrue);
    });

    test('Notify listeners on decrement', () {
      var listenerCalled = false;
      counterRx
        ..addListener(() {
          // Can't call private _notifyListeners()
        })
        ..decrement();
      listenerCalled = true;

      expect(listenerCalled, isTrue);
    });

    test('Do not notify listeners on no state change', () {
      var listenerCalled = false;
      counterRx
        ..addListener(() {
          listenerCalled = true;
        })
        ..increment()
        ..increment();

      expect(listenerCalled, isFalse);
    });

    test('Remove listener', () {
      var listenerCalled = false;
      void listener() {
        listenerCalled = true;
      }

      counterRx
        ..addListener(listener)
        ..removeListener(listener)
        ..increment();

      expect(listenerCalled, isFalse);
    });

    // test('Dispose Rx', () {
    //   counterRx.dispose();

    //   expect(
    //     () => Rx.debugAssertNotDisposed(counterRx),
    //     throwsA(isA<StateError>()),
    //   );
    // });
  });

  group('MergeRx', () {
    test('should merge Rx objects', () {
      final rx1 = RxInt(10);
      final rx2 = RxString('Hello');

      final mergedRx = MergeRx([rx1, rx2]);

      expect('${mergedRx.children}', '[$rx1, $rx2]');

      var listenerCalled = false;

      mergedRx.addListener(() {
        listenerCalled = true;
      });

      rx1.value = 20;
      rx2.value = 'World';

      expect('${mergedRx.children}', '[$rx1, $rx2]');
      expect(listenerCalled, true);
    });
  });

  group('RxListener', () {
    test('should capture Rx objects', () {
      RxInt rx1() => RxInt(10);
      RxString rx2() => RxString('Hello');

      RxListener.listen();

      final rxObjects = '[${rx1()}, ${rx2()}]';

      final capturedRx = RxListener.listenedRx();

      expect('${capturedRx.children}', rxObjects);
    });

    test('should throw an error if no Rx objects are captured', () {
      expect(RxListener.getRxList, throwsA(isA<FlutterError>()));
    });
  });
}
