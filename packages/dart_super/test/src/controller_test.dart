import 'package:dart_super/dart_super.dart';
import 'package:test/test.dart';

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
      final controller = MyController()..enable();

      expect(controller.alive, true);
      expect(controller.onDisableCalled, false);

      controller.disable();

      expect(controller.alive, false);
      expect(controller.onDisableCalled, true);
    });

    test('onEnable() should call onAlive() in the next frame', () {
      final controller = MyController()..enable();

      expect(controller.onAliveCalled, false);

      Future<void>.delayed(const Duration(milliseconds: 15), () {
        expect(controller.onAliveCalled, true);
      });
    });
  });
}
