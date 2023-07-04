// ignore_for_file: invalid_override_of_non_virtual_member,
// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

MyController get myController => Super.init(MyController());

class MyController extends SuperController {
  bool initContextCalled = false;
  bool disableCalled = false;
  BuildContext? buildContext1;
  BuildContext? buildContext2;
  final num = 0.rx;
  final notifier = CounterNotifier();

  @override
  void initContext(BuildContext? context) {
    super.initContext(context);
    initContextCalled = true;
  }

  @override
  void onEnable() {
    super.onEnable();
    try {
      buildContext1 = context;
    } catch (e) {
      return;
    }
  }

  @override
  void onAlive() {
    buildContext2 = context;
  }

  @override
  void disable() {
    disableCalled = true;
    super.disable();
  }
}

class CounterNotifier extends RxNotifier<int> {
  @override
  int watch() {
    return 5;
  }
}

class MySuperWidget extends SuperWidget<MyController> {
  const MySuperWidget({super.key});

  @override
  MyController initController() => myController;
  @override
  Widget build(BuildContext context) {
    final count = context.watch<int>(controller.num);
    return Text('Value: $count');
  }
}

class ASuperWidget extends SuperWidget<MyController> {
  const ASuperWidget({super.key});

  @override
  MyController initController() => myController;
  @override
  Widget build(BuildContext context) {
    final num = context.watch<int>(controller.notifier);
    return Text('Value: $num');
  }
}

void main() {
  group('SuperWidget', () {
    testWidgets('Initializes the controller', (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(
        const SuperApp(
          child: MaterialApp(
            home: Scaffold(body: widget),
          ),
        ),
      );

      final controller = widget.controller;
      expect(controller, isNotNull);
      expect(controller.buildContext1, isNull);
      expect(controller.buildContext2, isNotNull);
      expect(controller.initContextCalled, isTrue);
    });

    testWidgets('Builds the widget and updates in response to watch method',
        (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(
        const SuperApp(
          child: MaterialApp(
            home: Scaffold(body: widget),
          ),
        ),
      );

      expect(find.byType(Text), findsOneWidget);
      expect(find.text('Value: 0'), findsOneWidget);

      final controller = widget.controller;
      controller.num.value = 1;

      await tester.pump();

      expect(find.text('Value: 1'), findsOneWidget);

      await tester.pumpWidget(Container());

      expect(controller.num.hasListeners, isTrue);
      controller.num.value = 2; // remove watch listener
      expect(controller.num.hasListeners, isFalse);
    });

    testWidgets('Disposes the controller', (WidgetTester tester) async {
      const widget = ASuperWidget();
      await tester.pumpWidget(
        const SuperApp(
          child: MaterialApp(
            home: Scaffold(body: widget),
          ),
        ),
      );

      final controller = widget.controller;

      expect(find.byType(Text), findsOneWidget);

      expect(find.text('Value: 5'), findsOneWidget);

      await tester.pumpWidget(Container());

      expect(controller.disableCalled, isTrue);

      expect(controller.notifier.hasListeners, isTrue);
      controller.notifier.state = 2; // remove watch listener
      expect(controller.notifier.hasListeners, isFalse);
    });
  });
}
