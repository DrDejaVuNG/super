import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RxSet', () {
    late RxSet<int> rxSet;

    setUp(() {
      rxSet = RxSet<int>();
    });

    test('should initialize an empty set', () {
      expect(rxSet.isEmpty, isTrue);
      expect(rxSet.length, equals(0));
    });

    test('should add values to the set', () {
      expect(rxSet.add(1), isTrue);
      expect(rxSet.add(2), isTrue);
      expect(rxSet.add(3), isTrue);

      expect(rxSet.length, equals(3));
      expect(rxSet.contains(2), isTrue);
    });

    test('should not add duplicate values to the set', () {
      expect(rxSet.add(1), isTrue);
      expect(rxSet.add(2), isTrue);
      expect(rxSet.add(3), isTrue);

      expect(rxSet.add(2), isFalse); // Duplicate value

      expect(rxSet.length, equals(3));
    });

    test('should remove values from the set', () {
      rxSet.addAll({1, 2, 3});

      expect(rxSet.remove(2), isTrue);

      expect(rxSet.length, equals(2));
      expect(rxSet.contains(2), isFalse);
    });

    test('should not remove non-existing values from the set', () {
      rxSet.addAll({1, 2, 3});

      expect(rxSet.remove(4), isFalse); // Non-existing value

      expect(rxSet.length, equals(3));
    });

    test('should provide an iterator for the set', () {
      rxSet.addAll({1, 2, 3});

      final iterator = rxSet.iterator;
      final values = <int>[];
      while (iterator.moveNext()) {
        values.add(iterator.current);
      }

      expect(values, containsAll([1, 2, 3]));
    });

    test('should lookup values in the set', () {
      rxSet.addAll({1, 2, 3});

      expect(rxSet.lookup(2), equals(2));
      expect(rxSet.lookup(4), isNull); // Non-existing value
    });

    test('should convert the set to a regular set', () {
      rxSet.addAll({1, 2, 3});

      final regularSet = rxSet.toSet();

      expect(regularSet, isA<Set<int>>());
      expect(regularSet, containsAll([1, 2, 3]));
    });

    test('should notify listeners when values are added or removed', () {
      var listenerCalls = 0;

      rxSet.addListener(() {
        listenerCalls++;
      });

      expect(rxSet.add(1), isTrue);
      expect(rxSet.add(2), isTrue);
      expect(rxSet.remove(2), isTrue);

      expect(listenerCalls, equals(3));
    });
  });
}
