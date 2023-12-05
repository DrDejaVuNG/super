// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/core/globals.dart';
import 'package:flutter_test/flutter_test.dart';

final controller = ValueController();

class ValueController extends SuperController {}

void main() {
  group('SuperBuilder', () {
    testWidgets('Calls builder function with initial value',
        (WidgetTester tester) async {
      final rx = 0.rx;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperBuilder(
            builder: (context) => Text('Value: ${rx.state}'),
          ),
        ),
      );

      // Verify that the builder function is called with the initial value
      expect(find.text('Value: 0'), findsOneWidget);
    });

    testWidgets('Calls builder function with updated value',
        (WidgetTester tester) async {
      final rx = 'Initial'.rx;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperBuilder(
            builder: (context) => Text('Value: ${rx.state}'),
          ),
        ),
      );

      // Update the rx value
      rx.state = 'Updated Value';

      // Rebuild the widget
      await tester.pump();

      // Verify that the builder function is called with the updated value
      expect(find.text('Value: Updated Value'), findsOneWidget);
    });

    testWidgets('Rebuilds widget when ID is given without an Rx',
        (WidgetTester tester) async {
      var value = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperBuilder(
            id: 'value',
            builder: (context) => ElevatedButton(
              onPressed: () {
                value++;
                controller.rebuild('value');
              },
              child: Text('$value'),
            ),
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsNothing);

      // Increment the state and re-render
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);

      expect(rebuildMap['value']!.isEmpty, false);
      await tester.pumpWidget(Container());
      expect(rebuildMap['value']!.isEmpty, true);
    });

    testWidgets(
        'Does not call builder function when buildWhen condition is false',
        (WidgetTester tester) async {
      final rx = 'Initial'.rx;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperBuilder(
            builder: (context) => Text('Value: ${rx.state}'),
            buildWhen: () => false, // Build condition is false
          ),
        ),
      );

      // Update the rx value
      rx.state = 'Updated Value';

      // Rebuild the widget
      await tester.pump();

      // Verify that the builder function is not called with the updated value
      expect(find.text('Value: Updated Value'), findsNothing);
    });

    testWidgets('Disposes the listener when widget is disposed',
        (WidgetTester tester) async {
      final rx = 0.rx;

      await tester.pumpWidget(
        MaterialApp(
          home: SuperBuilder(
            builder: (context) => Text('Value: ${rx.state}'),
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
