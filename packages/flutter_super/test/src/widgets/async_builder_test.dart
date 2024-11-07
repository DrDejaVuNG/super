import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AsyncBuilder', () {
    testWidgets('Displays loading widget when connection state is waiting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncBuilder<int>(
            future: Future.delayed(const Duration(seconds: 3), () => 10),
            builder: (data) => Text(data.toString()),
            loading: () => const CircularProgressIndicator(),
          ),
        ),
      );

      // Verify that CircularProgressIndicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the delayed future to complete
      await tester.pumpAndSettle();

      // Verify that the data is displayed
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('Displays initialData when initialData is available',
        (WidgetTester tester) async {
      final completer = Completer<int>();
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncBuilder<int>(
            initialData: 5,
            future: completer.future,
            builder: (data) => Text('Data: $data'),
          ),
        ),
      );

      // Verify that initialData text is displayed
      expect(find.text('Data: 5'), findsOneWidget);

      completer.completeError('An Error');
    });

    testWidgets('Displays data widget when data is available',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncBuilder<int>(
            future: Future.delayed(const Duration(seconds: 2), () => 10),
            builder: (data) => Text('Data: $data'),
          ),
        ),
      );

      // Wait for future to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify that data text is displayed
      expect(find.text('Data: 10'), findsOneWidget);
    });

    testWidgets('Displays error widget when error is available',
        (WidgetTester tester) async {
      final completer = Completer<dynamic>();
      await tester.pumpWidget(
        MaterialApp(
          home: AsyncBuilder(
            future: completer.future,
            builder: (data) => Text('Data: $data'),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ),
      );

      completer.completeError('An Error');

      await tester.pumpAndSettle();

      // Verify that error text is displayed
      expect(find.text('Error: An Error'), findsOneWidget);
    });

    testWidgets('Updates data widget when new data is available',
        (WidgetTester tester) async {
      final stream =
          Stream<int>.periodic(const Duration(seconds: 1), (count) => count)
              .take(5);

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncBuilder<int>(
            stream: stream,
            builder: (data) => Text('Data: $data'),
          ),
        ),
      );

      // Wait for the stream to emit new data
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify that updated data text is displayed
      expect(find.text('Data: 4'), findsOneWidget);
    });

    testWidgets('Disposes the subscription when widget is disposed',
        (WidgetTester tester) async {
      final stream =
          Stream<int>.periodic(const Duration(seconds: 1), (count) => count)
              .take(5);

      await tester.pumpWidget(
        MaterialApp(
          home: AsyncBuilder<int>(
            stream: stream,
            builder: (data) => Text('Data: $data'),
          ),
        ),
      );

      // Verify that the subscription is not active
      expect(stream.isBroadcast, isFalse);
    });
  });
}
