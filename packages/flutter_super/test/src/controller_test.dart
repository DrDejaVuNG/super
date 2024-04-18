// ignore_for_file: cascade_invocations

import 'package:flutter/widgets.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class MyController extends SuperController {
  bool onEnableCalled = false;
  bool onBuildCalled = false;
  bool onAliveCalled = false;
  bool onDisableCalled = false;
  @override
  void onEnable() {
    super.onEnable();
    onEnableCalled = true;
  }

  @override
  void onBuild() {
    onBuildCalled = !onBuildCalled;
  }

  @override
  void onAlive() {
    onAliveCalled = true;
  }

  @override
  void onDisable() {
    super.onDisable();
    onDisableCalled = true;
  }
}

void main() {
  group('SuperController', () {
    setUp(TestWidgetsFlutterBinding.ensureInitialized);
    test('enable() should initialize the controller', () {
      final controller = MyController();

      expect(controller.alive, false);

      controller.enable();

      expect(controller.alive, true);
    });

    test('enable() should call onEnable()', () {
      final controller = MyController();

      expect(controller.onEnableCalled, false);

      controller.enable();

      expect(controller.onEnableCalled, true);
    });

    test('disable() should disable the controller', () {
      final controller = MyController();

      controller.enable();

      expect(controller.alive, true);
      expect(controller.onDisableCalled, false);

      controller.disable();

      expect(controller.alive, false);
      expect(controller.onDisableCalled, true);
    });

    test('onEnable() should call onAlive() in the next frame', () {
      final controller = MyController();

      controller.enable();

      expect(controller.onAliveCalled, false);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        expect(controller.onAliveCalled, true);
      });
    });

    test('onDisable() should delete the controller instance', () {
      final controller = MyController();

      expect(
        () => Super.of<MyController>(),
        throwsA(isA<StateError>()),
      );

      controller
        ..enable()
        ..disable();

      expect(
        () => Super.of<MyController>(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
