import 'package:dart_super/dart_super.dart';
import 'package:test/test.dart';

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

    test('should initialize with the provided state', () {
      expect(rxInt.state, equals(0));
      expect(rxDouble.state, equals(0.0));
      expect(rxString.state, equals(''));
      expect(rxBool.state, isFalse);
    });

    test('should update the state', () {
      rxInt.state = 10;
      rxDouble.state = 3.14;
      rxString.state = 'Hello';
      rxBool.state = true;

      expect(rxInt.state, equals(10));
      expect(rxDouble.state, equals(3.14));
      expect(rxString.state, equals('Hello'));
      expect(rxBool.state, isTrue);
    });

    test('should notify listeners when the state changes', () {
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

      rxInt.state = 10;
      rxDouble.state = 3.14;
      rxString.state = 'Hello';
      rxBool.state = true;

      expect(intListenerCalls, equals(1));
      expect(doubleListenerCalls, equals(1));
      expect(stringListenerCalls, equals(1));
      expect(boolListenerCalls, equals(1));
    });

    test('should not notify listeners when the state does not change', () {
      var listenerCalls = 0;

      rxInt
        ..addListener(() {
          listenerCalls++;
        })
        ..state = 0; // Same state

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
