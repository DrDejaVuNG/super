import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class MyController extends SuperController {
  bool initContextCalled = false;
  bool stopCalled = false;

  @override
  void initContext(BuildContext? context) {
    initContextCalled = true;
  }

  @override
  // ignore: invalid_override_of_non_virtual_member
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
