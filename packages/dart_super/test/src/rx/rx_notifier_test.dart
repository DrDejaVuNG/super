import 'package:dart_super/dart_super.dart';
import 'package:test/test.dart';

class TestNotifier extends RxNotifier<int> {
  @override
  int initial() {
    return 0; // Initial state
  }

  void increment() {
    state++; // Update the state
  }

  Future<void> getData() async {
    toggleLoading();
    state = await Future.delayed(const Duration(seconds: 2), () => 5);
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

    test('loading state is updated when toggleLoading() method is called', () {
      expect(testNotifier.loading, isFalse);

      testNotifier.toggleLoading();

      expect(testNotifier.loading, isTrue);

      testNotifier.toggleLoading();
    });

    test('should notify listeners when the state is changed asynchronously',
        () async {
      var listenerCalls = 0;

      testNotifier.addListener(() {
        listenerCalls++;
      });

      await testNotifier.getData();

      expect(testNotifier.state, equals(5));
      expect(listenerCalls, equals(1));
    });

    test('should have a string representation of the runtime type and state',
        () {
      expect(testNotifier.toString(), equals('TestNotifier(0)'));
    });
  });
}
