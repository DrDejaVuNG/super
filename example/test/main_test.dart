// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_test/super_test.dart';
// ignore: avoid_relative_lib_imports
import '../lib/main.dart';

// The Example Counter App Test
void main() {
  testWidgets('Update the UI when incrementing the state', (tester) async {
    await tester.pumpWidget(const SuperApp(child: MyApp()));

    // The initial value is `0`, as declared in our controller
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Increment the state and re-render
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // The state has properly incremented
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('The counter state is not shared between tests', (tester) async {
    await tester.pumpWidget(const SuperApp(child: MyApp()));

    // The state is `0` once again, with no tearDown/setUp needed
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });

  testController<HomeController, int>(
    'Outputs [1, 2] when the increment method is called multiple times '
    'with asynchronous act',
    build: HomeController(),
    state: (controller) => controller.count,
    act: (controller) async {
      controller.increment();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      controller.increment();
    },
    expect: const <int>[1, 2],
  );
}
