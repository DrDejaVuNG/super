// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/core/logger.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterNotifier extends RxNotifier<int> {
  @override
  int watch() {
    return 0; // Initial state
  }
}

void main() {
  group('SuperConsumer', () {
    testWidgets('Calls builder function with initial value',
        (WidgetTester tester) async {
      final rx = RxT<int>(7);

      await tester.pumpWidget(
        MaterialApp(
          home: SuperConsumer<int>(
            rx: rx,
            builder: (context, state) => Text('Value: $state'),
          ),
        ),
      );

      // Verify that the builder function is called with the initial value
      expect(find.text('Value: 7'), findsOneWidget);
    });

    testWidgets('Calls builder function with initial RxNotidier value',
        (WidgetTester tester) async {
      final rx = CounterNotifier();

      await tester.pumpWidget(
        MaterialApp(
          home: SuperConsumer<int>(
            rx: rx,
            builder: (context, state) => Text('Value: $state'),
          ),
        ),
      );
      Super.log('Value: 0', logType: LogType.success);
      // Verify that the builder function is called with the initial value
      expect(find.text('Value: 0'), findsOneWidget);
    });

    testWidgets('Calls builder function with updated value',
        (WidgetTester tester) async {
      final rx = RxT<int>(7);

      await tester.pumpWidget(
        MaterialApp(
          home: SuperConsumer<int>(
            rx: rx,
            builder: (context, state) => Text('Value: $state'),
          ),
        ),
      );

      // Update the rx value
      rx.value = 84;

      // Rebuild the widget
      await tester.pump();

      // Verify that the builder function is called with the updated value
      expect(find.text('Value: 84'), findsOneWidget);
    });

    testWidgets('Calls builder function when rx changes',
        (WidgetTester tester) async {
      final rx1 = RxT<int>(7);
      final rx2 = RxT<int>(84);

      await tester.pumpWidget(
        MaterialApp(
          home: SuperConsumer<int>(
            rx: rx1,
            builder: (context, state) => Text('Value: $state'),
          ),
        ),
      );

      // Verify that the builder function is called with rx1 initial value
      expect(find.text('Value: 7'), findsOneWidget);

      // Update the rx to use rx2
      await tester.pumpWidget(
        MaterialApp(
          home: SuperConsumer<int>(
            rx: rx2,
            builder: (context, state) => Text('Value: $state'),
          ),
        ),
      );

      // Verify that the builder function is called with rx2 initial value
      expect(find.text('Value: 84'), findsOneWidget);
    });

    testWidgets('Disposes the listener when widget is disposed',
        (WidgetTester tester) async {
      final rx = RxT<int>(7);

      await tester.pumpWidget(
        MaterialApp(
          home: SuperConsumer<int>(
            rx: rx,
            builder: (context, state) => Text('Value: $state'),
          ),
        ),
      );

      // Verify that the listener is active initially
      expect(rx.hasListeners, isTrue);

      // Dispose the widget
      await tester.pumpWidget(Container());

      // Verify that the listener is disposed
      expect(rx.hasListeners, isFalse);
    });
  });
}
