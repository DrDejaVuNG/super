import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class TestNotifier extends RxNotifier<int> {
  @override
  int watch() {
    return 0; // Initial state
  }

  void increment() {
    state++; // Update the state
  }
}

void main() {
  group('RxNotifier', () {
    late TestNotifier testNotifier;

    setUp(() {
      testNotifier = TestNotifier();
    });

    test('should initialize with the initial state', () {
      expect(testNotifier.state, equals(0));
    });

    test('should update the state and notify listeners', () {
      var listenerCalls = 0;

      testNotifier
        ..addListener(() {
          listenerCalls++;
        })
        ..increment();

      expect(testNotifier.state, equals(1));
      expect(listenerCalls, equals(1));
    });

    test('should not notify listeners when the state is unchanged', () {
      var listenerCalls = 0;

      testNotifier
        ..addListener(() {
          listenerCalls++;
        })
        ..state = 0; // Set the same state

      expect(listenerCalls, equals(0));
    });

    test('should have a string representation of the runtime type and state',
        () {
      expect(testNotifier.toString(), equals('TestNotifier(0)'));
    });
  });
}
