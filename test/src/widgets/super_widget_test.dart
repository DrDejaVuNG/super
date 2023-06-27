// ignore_for_file: invalid_override_of_non_virtual_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class MyController extends SuperController {
  bool initContextCalled = false;
  bool stopCalled = false;
  BuildContext? buildContext1;
  BuildContext? buildContext2;

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
  void stop() {
    stopCalled = true;
    super.stop();
  }
}

class MySuperWidget extends SuperWidget<MyController> {
  const MySuperWidget({super.key});

  @override
  MyController initController() => MyController();
  @override
  Widget build(BuildContext context) => Container();
}

void main() {
  group('SuperWidget', () {
    testWidgets('Initializes the controller', (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(const SuperApp(child: widget));

      final controller = widget.controller;
      expect(controller, isNotNull);
      expect(controller.buildContext1, isNull);
      expect(controller.buildContext2, isNotNull);
      expect(controller.initContextCalled, isTrue);
    });

    testWidgets('Builds the widget', (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(const SuperApp(child: widget));

      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('Disposes the controller', (WidgetTester tester) async {
      const widget = MySuperWidget();
      await tester.pumpWidget(const SuperApp(child: widget));

      final controller = widget.controller;

      await tester.pumpWidget(Container());

      expect(controller.stopCalled, isTrue);
    });
  });
}
