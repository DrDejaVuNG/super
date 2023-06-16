// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SuperListener', () {
    testWidgets('Calls listener function when rx object changes',
        (WidgetTester tester) async {
      final rx = 5.rx;
      var listenerValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperListener<int>(
            listener: (context) => listenerValue = rx.value,
            listen: () => rx.value,
            child: Text('Value: $listenerValue'),
          ),
        ),
      );

      // Verify that the listener function is called with the initial value
      expect(find.text('Value: 0'), findsOneWidget);

      // Update the rx value
      rx.value = 12;

      // Rebuild the widget
      await tester.pumpWidget(
        MaterialApp(
          home: SuperListener<int>(
            listener: (context) => listenerValue = rx.value,
            listen: () => rx.value,
            child: Text('Value: $listenerValue'),
          ),
        ),
      );

      // Verify that the listener function is called with the updated value
      expect(find.text('Value: 12'), findsOneWidget);
    });

    testWidgets(
        'Does not call listener function when listenWhen condition is false',
        (WidgetTester tester) async {
      final rx = 0.rx;
      var listenerValue = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperListener<int>(
            listener: (context) => listenerValue = rx.value,
            listen: () => rx.value,
            listenWhen: (state) => state > 10, // Listen condition is false
            child: Text('Value: $listenerValue'),
          ),
        ),
      );

      // Update the rx value to a value less than 10
      rx.value = 5;

      // Rebuild the widget
      await tester.pump();

      // Verify that the listener function is not called with the updated value
      expect(find.text('Value: 0'), findsOneWidget);
    });

    testWidgets('Disposes the listener when widget is disposed',
        (WidgetTester tester) async {
      final rx = 0.rx;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperListener<int>(
            listener: (context) {},
            listen: () => rx.value,
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
