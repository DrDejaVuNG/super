import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class User {}

void main() {
  group('RxTExt', () {
    test('RxTExt - T', () {
      final value = User();
      final rxValue = value.rx;

      expect(rxValue.value, equals(value));
    });

    test('RxTExt - String', () {
      const value = 'Hello';
      final rxValue = value.rx;

      expect(rxValue.value, equals(value));
    });

    test('RxTExt - Int', () {
      const value = 6;
      final rxValue = value.rx;

      expect(rxValue.value, equals(value));
    });

    test('RxTExt - Double', () {
      const value = 3.14;
      final rxValue = value.rx;

      expect(rxValue.value, equals(value));
    });

    test('RxTExt - Bool', () {
      const value = true;
      final rxValue = value.rx;

      expect(rxValue.value, equals(value));
    });
  });

  group('RxSetExt', () {
    test('RxSetExt', () {
      final set = {1, 2, 3};
      final rxSet = set.rx;

      expect(rxSet, equals(set));
    });
  });

  group('RxMapExt', () {
    test('RxMapExt', () {
      final map = {1: 'One', 2: 'Two', 3: 'Three'};
      final rxMap = map.rx;

      expect(rxMap, equals(map));
    });
  });

  group('RxListExt', () {
    test('RxListExt', () {
      final list = [1, 2, 3];
      final rxList = list.rx;

      expect(rxList, equals(list));
    });
  });
}
