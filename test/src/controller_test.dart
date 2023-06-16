// ignore_for_file: cascade_invocations

import 'package:flutter/widgets.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class MyController extends SuperController {
  bool onEnableCalled = false;
  bool onAliveCalled = false;
  bool onDisableCalled = false;
  @override
  void onAlive() {
    onAliveCalled = true;
  }

  @override
  void onEnable() {
    super.onEnable();
    onEnableCalled = true;
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
    test('start() should initialize the controller', () {
      final controller = MyController();

      expect(controller.alive, false);

      controller.start();

      expect(controller.alive, true);
    });

    test('start() should call onEnable()', () {
      final controller = MyController();

      expect(controller.onEnableCalled, false);

      controller.start();

      expect(controller.onEnableCalled, true);
    });

    test('stop() should disable the controller', () {
      final controller = MyController();

      controller.start();

      expect(controller.alive, true);
      expect(controller.onDisableCalled, false);

      controller.stop();

      expect(controller.alive, false);
      expect(controller.onDisableCalled, true);
    });

    test('onEnable() should call onAlive() in the next frame', () {
      final controller = MyController();

      controller.start();

      expect(controller.onAliveCalled, false);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        expect(controller.onAliveCalled, true);
      });
    });

    test('onDisable() should delete the controller instance', () {
      final controller = MyController();

      expect(
        () => Super.of<MyController>(),
        throwsA(isA<FlutterError>()),
      );

      controller
        ..start()
        ..stop();

      expect(
        () => Super.of<MyController>(),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
