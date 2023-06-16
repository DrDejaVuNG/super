import 'package:flutter/foundation.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RxT', () {
    test('should return the initial value', () {
      final rx = RxT<int>(5);
      expect(rx.value, 5);
    });

    test('should update the value', () {
      final rx = RxT<int>(5)..value = 10;
      expect(rx.value, 10);
    });

    test('should notify listeners when value changes', () {
      final rx = RxT<int>(5);
      var listenerCalled = false;

      rx..addListener(() {
        listenerCalled = true;
      })

      ..value = 10;

      expect(listenerCalled, true);
    });
  });

  group('RxString', () {
    test('should return the initial value', () {
      final rx = RxString('Hello');
      expect(rx.value, 'Hello');
    });

    test('should update the value', () {
      final rx = RxString('Hello')..value = 'World';
      expect(rx.value, 'World');
    });

    test('should notify listeners when value changes', () {
      final rx = RxString('Hello');
      var listenerCalled = false;

      rx..addListener(() {
        listenerCalled = true;
      })

      ..value = 'World';

      expect(listenerCalled, true);
    });
  });

  group('RxInt', () {
    test('should return the initial value', () {
      final rx = RxInt(5);
      expect(rx.value, 5);
    });

    test('should update the value', () {
      final rx = RxInt(5)..value = 10;
      expect(rx.value, 10);
    });

    test('should notify listeners when value changes', () {
      final rx = RxInt(5);
      var listenerCalled = false;

      rx..addListener(() {
        listenerCalled = true;
      })

      ..value = 10;

      expect(listenerCalled, true);
    });
  });

  group('RxDouble', () {
    test('should return the initial value', () {
      final rx = RxDouble(3.14);
      expect(rx.value, 3.14);
    });

    test('should update the value', () {
      final rx = RxDouble(3.14)..value = 2.71;
      expect(rx.value, 2.71);
    });

    test('should notify listeners when value changes', () {
      final rx = RxDouble(3.14);
      var listenerCalled = false;

      rx..addListener(() {
        listenerCalled = true;
      })

      ..value = 2.71;

      expect(listenerCalled, true);
    });
  });

  group('RxBool', () {
    test('should return the initial value', () {
      final rx = RxBool(true);
      expect(rx.value, true);
    });

    test('should update the value', () {
      final rx = RxBool(true)..value = false;
      expect(rx.value, false);
    });

    test('should notify listeners when value changes', () {
      final rx = RxBool(true);
      var listenerCalled = false;

      rx..addListener(() {
        listenerCalled = true;
      })

      ..value = false;

      expect(listenerCalled, true);
    });
  });

  group('MergeRx', () {
  //   test('should merge Rx objects', () {
  //     final rx1 = RxInt(10);
  //     final rx2 = RxString('Hello');

  //     final mergedRx = MergeRx([rx1, rx2]);

  //     expect(mergedRx.children, [RxInt(10), RxString('Hello')]);

  //     var listenerCalled = false;

  //     mergedRx.addListener(() {
  //       listenerCalled = true;
  //     });

  //     rx1.value = 20;
  //     rx2.value = 'World';

  //     expect(mergedRx.children, ['$rx1', '$rx2']);
  //     expect(listenerCalled, true);
  //   });
  // });

  // group('RxListener', () {
  //   test('should capture Rx objects', () {
  //     RxInt rx1() => RxInt(10);
  //     RxString rx2() => RxString('Hello');

  //     RxListener.listen();

  //     rx1();
  //     rx2();

  //     final capturedRx = RxListener.listenedRx();

  //     expect(capturedRx.children, [RxInt(10), RxString('Hello')]);
  //   });

    test('should throw an error if no Rx objects are captured', () {
      expect(RxListener.getRxList, throwsA(isA<FlutterError>()));
    });

    // test('should capture Rx objects within a context', () {
    //   final rx1 = RxInt(10);
    //   final rx2 = RxString('Hello');

    //   final context = SuperWidget();

    //   RxListener.listen();

    //   final capturedRx = RxListener.listenedRx(context);

    //   expect(capturedRx.children, [10, 'Hello']);
    // });
  });
}

// class SuperWidget extends Widget {}
