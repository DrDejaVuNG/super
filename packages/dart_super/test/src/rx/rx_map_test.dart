import 'package:dart_super/dart_super.dart';
import 'package:test/test.dart';

void main() {
  group('RxMap', () {
    late RxMap<String, int> rxMap;

    setUp(() {
      rxMap = RxMap<String, int>();
    });

    test('should add all key-value pairs from another map', () {
      final map = {'a': 1, 'b': 2, 'c': 3};

      rxMap.addAll(map);

      expect(rxMap.length, equals(3));
      expect(rxMap['a'], equals(1));
      expect(rxMap['b'], equals(2));
      expect(rxMap['c'], equals(3));
    });

    test('should access a value by key', () {
      rxMap['a'] = 1;

      expect(rxMap['a'], equals(1));
    });

    test('should update a value by key', () {
      rxMap['a'] = 1;
      rxMap['a'] = 2;

      expect(rxMap['a'], equals(2));
    });

    test('should clear all key-value pairs', () {
      rxMap
        ..addAll({'a': 1, 'b': 2, 'c': 3})
        ..clear();

      expect(rxMap.isEmpty, isTrue);
      expect(rxMap.length, equals(0));
    });

    test('should get an iterable of keys', () {
      rxMap.addAll({'a': 1, 'b': 2, 'c': 3});

      final keys = rxMap.keys.toList();

      expect(keys.length, equals(3));
      expect(keys.contains('a'), isTrue);
      expect(keys.contains('b'), isTrue);
      expect(keys.contains('c'), isTrue);
    });

    test('should remove a key-value pair by key', () {
      rxMap.addAll({'a': 1, 'b': 2, 'c': 3});

      final removedValue = rxMap.remove('b');

      expect(removedValue, equals(2));
      expect(rxMap.length, equals(2));
      expect(rxMap.containsKey('b'), isFalse);
    });

    test('should create an `RxMap` with the given `map`', () {
      final map = {'name': 'John Doe', 'age': '30'};
      final myMap = RxMap.of(map);
      expect(myMap == map, false);
    });
  });
}
