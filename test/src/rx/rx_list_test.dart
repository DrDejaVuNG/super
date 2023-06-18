import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RxList', () {
    late RxList<int> rxList;

    setUp(() {
      rxList = RxList<int>();
    });

    test('should initialize with an empty list', () {
      expect(rxList.isEmpty, isTrue);
      expect(rxList.length, equals(0));
    });

    test('should add elements to the list', () {
      rxList
        ..add(1)
        ..add(2);

      expect(rxList.length, equals(2));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(2));
    });

    test('should replace range of elements in the list', () {
      rxList
        ..addAll([1, 2, 3, 4])
        ..replaceRange(1, 3, [5, 6]);

      expect(rxList.length, equals(4));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(5));
      expect(rxList[2], equals(6));
      expect(rxList[3], equals(4));
    });

    test('should set range of elements in the list', () {
      rxList
        ..addAll([1, 2, 3, 4])
        ..setRange(1, 3, [5, 6]);

      expect(rxList.length, equals(4));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(5));
      expect(rxList[2], equals(6));
      expect(rxList[3], equals(4));
    });

    test('should fill range of elements in the list', () {
      rxList
        ..addAll([1, 2, 3, 4])
        ..fillRange(1, 3, 5);

      expect(rxList.length, equals(4));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(5));
      expect(rxList[2], equals(5));
      expect(rxList[3], equals(4));
    });

    test('should remove element from the list', () {
      rxList.addAll([1, 2, 3]);

      final removed = rxList.remove(2);

      expect(removed, isTrue);
      expect(rxList.length, equals(2));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(3));
    });

    test('should remove element at index from the list', () {
      rxList.addAll([1, 2, 3]);

      final removedElement = rxList.removeAt(1);

      expect(removedElement, equals(2));
      expect(rxList.length, equals(2));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(3));
    });

    test('should remove last element from the list', () {
      rxList.addAll([1, 2, 3]);

      final removedElement = rxList.removeLast();

      expect(removedElement, equals(3));
      expect(rxList.length, equals(2));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(2));
    });

    test('should remove elements within a range from the list', () {
      rxList
        ..addAll([1, 2, 3, 4, 5])
        ..removeRange(1, 4);

      expect(rxList.length, equals(2));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(5));
    });

    test('should remove elements that match a condition from the list', () {
      rxList
        ..addAll([1, 2, 3, 4, 5])
        ..removeWhere((element) => element.isEven);

      expect(rxList.length, equals(3));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(3));
      expect(rxList[2], equals(5));
    });

    test('should insert element at a specific index in the list', () {
      rxList
        ..addAll([1, 2, 3])
        ..insert(1, 4);

      expect(rxList.length, equals(4));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(4));
      expect(rxList[2], equals(2));
      expect(rxList[3], equals(3));
    });

    test('should insert multiple elements at a specific index in the list', () {
      rxList
        ..addAll([1, 2, 3])
        ..insertAll(1, [4, 5]);

      expect(rxList.length, equals(5));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(4));
      expect(rxList[2], equals(5));
      expect(rxList[3], equals(2));
      expect(rxList[4], equals(3));
    });

    test(
        'should set multiple elements starting from a specific index in the '
        'list', () {
      rxList
        ..addAll([1, 2, 3])
        ..setAll(1, [4, 5]);

      expect(rxList.length, equals(3));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(4));
      expect(rxList[2], equals(5));
    });

    test('should shuffle the elements in the list', () {
      rxList
        ..addAll([1, 2, 3, 4, 5])
        ..shuffle();

      expect(rxList.length, equals(5));
      expect(rxList.contains(1), isTrue);
      expect(rxList.contains(2), isTrue);
      expect(rxList.contains(3), isTrue);
      expect(rxList.contains(4), isTrue);
      expect(rxList.contains(5), isTrue);
    });

    test('should sort the elements in the list', () {
      rxList
        ..addAll([3, 2, 1, 4, 5])
        ..sort();

      expect(rxList.length, equals(5));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(2));
      expect(rxList[2], equals(3));
      expect(rxList[3], equals(4));
      expect(rxList[4], equals(5));
    });

    test('should get a sublist of elements from the list', () {
      rxList.addAll([1, 2, 3, 4, 5]);

      final sublist = rxList.sublist(1, 4);

      expect(sublist.length, equals(3));
      expect(sublist[0], equals(2));
      expect(sublist[1], equals(3));
      expect(sublist[2], equals(4));
    });

    test('should get the single element that matches a condition from the list',
        () {
      rxList.addAll([1, 2, 3, 4, 5]);

      final singleElement = rxList.singleWhere((element) => element == 3);

      expect(singleElement, equals(3));
    });

    test('should skip a specified number of elements from the list', () {
      rxList.addAll([1, 2, 3, 4, 5]);

      final skippedElements = rxList.skip(2).toList();

      expect(skippedElements.length, equals(3));
      expect(skippedElements[0], equals(3));
      expect(skippedElements[1], equals(4));
      expect(skippedElements[2], equals(5));
    });

    test('should skip elements from the list until a condition is met', () {
      rxList.addAll([1, 2, 3, 4, 5]);

      final skippedElements =
          rxList.skipWhile((element) => element < 3).toList();

      expect(skippedElements.length, equals(3));
      expect(skippedElements[0], equals(3));
      expect(skippedElements[1], equals(4));
      expect(skippedElements[2], equals(5));
    });

    test('should invoke a callback for each element in the list', () {
      rxList.addAll([1, 2, 3, 4, 5]);

      final resultList = <int>[];

      for (final element in rxList) {
        resultList.add(element * 2);
      }

      expect(resultList.length, equals(5));
      expect(resultList[0], equals(2));
      expect(resultList[1], equals(4));
      expect(resultList[2], equals(6));
      expect(resultList[3], equals(8));
      expect(resultList[4], equals(10));
    });

    test('should clear all elements from the list', () {
      rxList
        ..addAll([1, 2, 3])
        ..clear();

      expect(rxList.isEmpty, isTrue);
      expect(rxList.length, equals(0));
    });

    test('should concatenate two lists', () {
      final list1 = RxList<int>([1, 2]);
      final list2 = RxList<int>([3, 4]);

      final concatenatedList = list1 + list2;

      expect(concatenatedList.length, equals(4));
      expect(concatenatedList[0], equals(1));
      expect(concatenatedList[1], equals(2));
      expect(concatenatedList[2], equals(3));
      expect(concatenatedList[3], equals(4));
    });

    test('should access an element by index', () {
      rxList.addAll([1, 2, 3]);

      expect(rxList[1], equals(2));
    });

    test('should update an element by index', () {
      rxList.addAll([1, 2, 3]);

      rxList[1] = 4;

      expect(rxList[1], equals(4));
    });

    test('should set the length of the list', () {
      rxList
        ..addAll([1, 2, 3])
        ..length = 2;

      expect(rxList.length, equals(2));
      expect(rxList[0], equals(1));
      expect(rxList[1], equals(2));
    });
  });
}
