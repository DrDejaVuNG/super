// ignore_for_file: cascade_invocations

import 'package:flutter/widgets.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

class MyViewModel extends SuperViewModel {
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
  group('SuperViewModel', () {
    setUp(TestWidgetsFlutterBinding.ensureInitialized);
    test('enable() should initialize the view model', () {
      final ref = MyViewModel();

      expect(ref.alive, false);

      ref.enable();

      expect(ref.alive, true);
    });

    test('enable() should call onEnable()', () {
      final ref = MyViewModel();

      expect(ref.onEnableCalled, false);

      ref.enable();

      expect(ref.onEnableCalled, true);
    });

    test('disable() should disable the view model', () {
      final ref = MyViewModel();

      ref.enable();

      expect(ref.alive, true);
      expect(ref.onDisableCalled, false);

      ref.disable();

      expect(ref.alive, false);
      expect(ref.onDisableCalled, true);
    });

    test('onEnable() should call onAlive() in the next frame', () {
      final ref = MyViewModel();

      ref.enable();

      expect(ref.onAliveCalled, false);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        expect(ref.onAliveCalled, true);
      });
    });

    test('onDisable() should delete the view model instance', () {
      final ref = MyViewModel();

      expect(
        () => Super.of<MyViewModel>(),
        throwsA(isA<StateError>()),
      );

      ref
        ..enable()
        ..disable();

      expect(
        () => Super.of<MyViewModel>(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
