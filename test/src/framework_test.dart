import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/instance.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeController extends SuperController {
  String get name => 'Hello';
}

class MockHomeController extends HomeController {
  @override
  String get name => 'Name';
}

void main() {
  group('SuperApp', () {
    testWidgets('initializes and disposes correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        SuperApp(
          mocks: [MockHomeController()],
          enableLog: true,
          testMode: true,
          child: Container(),
        ),
      );

      // Ensure that the Super framework is activated
      expect(Super.isScoped, true);

      // Insert actual dependencies
      final controller = Super.init(HomeController());

      // Verify mock dependencies are inserted
      expect(controller.name == 'Name', true);

      // Dispose the SuperApp widget
      await tester.pumpWidget(
        Container(),
      );

      // Ensure that the Super framework is deactivated
      expect(Super.isScoped, false);

      // Expect an error when null
      expect(
        () => Super.of<HomeController>(),
        throwsA(isA<FlutterError>()),
      );
    });

    testWidgets('mocks are not utilized if testMode is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        SuperApp(
          mocks: [MockHomeController()],
          child: Container(),
        ),
      );

      // Ensure that the Super framework is activated
      expect(Super.isScoped, true);

      // Insert actual dependencies
      final controller = Super.init(HomeController());

      // Verify mock dependencies are inserted
      expect(controller.name == 'Name', false);

      // Dispose the SuperApp widget
      await tester.pumpWidget(
        Container(),
      );

      // Expect controller to be disposed hence an error
      expect(
        () => Super.of<HomeController>(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('resources are not disposed when autoDispose is false', () {
      InstanceManager.activate(
        autoDispose: false,
        testMode: true,
        mocks: [MockHomeController()],
      );

      final controller = Super.init(HomeController());

      // Verify mock dependencies are inserted
      expect(controller.name == 'Name', true);

      InstanceManager.delete<HomeController>();

      // Expect controller to not be disposed
      expect(Super.of<HomeController>(), controller);

      // Delete controller manually
      Super.delete<HomeController>();

      // Expect controller to be disposed
      expect(
        () => Super.of<HomeController>(),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
