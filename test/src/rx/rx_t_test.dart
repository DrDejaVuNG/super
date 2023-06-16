import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RxT', () {
    late RxT<int> rxInt;
    late RxT<double> rxDouble;
    late RxT<String> rxString;
    late RxT<bool> rxBool;

    setUp(() {
      rxInt = RxInt(0);
      rxDouble = RxDouble(0);
      rxString = RxString('');
      rxBool = RxBool(false);
    });

    test('should initialize with the provided value', () {
      expect(rxInt.value, equals(0));
      expect(rxDouble.value, equals(0.0));
      expect(rxString.value, equals(''));
      expect(rxBool.value, isFalse);
    });

    test('should update the value', () {
      rxInt.value = 10;
      rxDouble.value = 3.14;
      rxString.value = 'Hello';
      rxBool.value = true;

      expect(rxInt.value, equals(10));
      expect(rxDouble.value, equals(3.14));
      expect(rxString.value, equals('Hello'));
      expect(rxBool.value, isTrue);
    });

    test('should notify listeners when the value changes', () {
      var intListenerCalls = 0;
      var doubleListenerCalls = 0;
      var stringListenerCalls = 0;
      var boolListenerCalls = 0;

      rxInt.addListener(() {
        intListenerCalls++;
      });

      rxDouble.addListener(() {
        doubleListenerCalls++;
      });

      rxString.addListener(() {
        stringListenerCalls++;
      });

      rxBool.addListener(() {
        boolListenerCalls++;
      });

      rxInt.value = 10;
      rxDouble.value = 3.14;
      rxString.value = 'Hello';
      rxBool.value = true;

      expect(intListenerCalls, equals(1));
      expect(doubleListenerCalls, equals(1));
      expect(stringListenerCalls, equals(1));
      expect(boolListenerCalls, equals(1));
    });

    test('should not notify listeners when the value does not change', () {
      var listenerCalls = 0;

      rxInt
        ..addListener(() {
          listenerCalls++;
        })
        ..value = 0; // Same value

      expect(listenerCalls, equals(0));
    });

    test('should have correct string representation', () {
      expect(rxInt.toString(), equals('RxInt(0)'));
      expect(rxDouble.toString(), equals('RxDouble(0.0)'));
      expect(rxString.toString(), equals('RxString()'));
      expect(rxBool.toString(), equals('RxBool(false)'));
    });
  });
}
