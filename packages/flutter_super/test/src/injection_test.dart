// ignore_for_file: invalid_override_of_non_virtual_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Injection', () {
    setUp(() {
      Injection.activate(
        testMode: true,
        autoDispose: true,
        mocks: [],
        enableLog: true,
      );
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(Injection.deactivate);

    test('create() should register a singleton instance', () {
      final instance = MockRx();
      final lazyInstance = MockController();

      Injection.create<MockRx>(instance);

      expect(Injection.of<MockRx>(), instance);

      Injection.create<MockController>(lazyInstance, lazy: true);

      expect(Injection.of<MockController>(), lazyInstance);
    });

    test('create() should throw an error if SuperApp is not found', () {
      Injection.deactivate();

      expect(
        () => Injection.create<String>('example'),
        throwsA(isA<FlutterError>()),
      );
    });

    test('of() should retrieve an instance from the manager', () {
      const instance = 'example';

      Injection.create<String>(instance);

      expect(Injection.of<String>(), instance);
    });

    test('of() should invoke enable() on SuperController instances', () {
      final instance = MockController();

      Injection.create<MockController>(instance);

      expect(instance.enableCalled, false);

      Injection.of<MockController>();

      expect(instance.enableCalled, true);
    });

    test('of() should register and retrieve lazy instances', () {
      const lazyInstance = 10;

      Injection.create<int>(lazyInstance, lazy: true);

      expect(Injection.of<int>(), lazyInstance);
    });

    test('of() should recursively register and retrieve instances', () {
      final instance = MockController();

      Injection.create<MockController>(instance);

      final mockInstance = Injection.of<MockController>();

      expect(mockInstance, instance);
    });

    test('of() should throw an error if type T is not found', () {
      expect(
        () => Injection.of<String>(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('init() should retrieve an instance or create a new one', () {
      const instance = 'example';

      Injection.create<String>(instance);
      // String key already exists
      expect(Injection.init<String>('other'), instance);
      expect(Injection.init<int>(10), 10);
    });

    test('init() should create a new instance if it does not exist', () {
      const instance = 'example';

      expect(Injection.init<String>(instance), instance);
      expect(Injection.of<String>(), instance);
    });

    test('delete() should delete an instance from the manager', () {
      const instance = 'example';

      Injection.create<String>(instance);

      expect(Injection.of<String>(), instance);

      Injection.delete<String>();

      expect(() => Injection.of<String>(), throwsA(isA<FlutterError>()));
    });

    test('delete() should disable SuperController instances', () {
      final controller = MockController();

      Injection.create<MockController>(controller);

      expect(controller.disableCalled, false);

      Injection.delete<MockController>();

      expect(controller.disableCalled, true);
    });

    test('delete() should dispose Rx instances', () {
      final rxInstance = MockRx();

      Injection.create<Rx<dynamic>>(rxInstance);

      expect(rxInstance.disposeCalled, false);

      Injection.delete<Rx<dynamic>>();

      expect(rxInstance.disposeCalled, true);
    });

    test('deleteAll() should delete all instances from the manager', () {
      Injection.create<String>('example');
      Injection.create<int>(42);
      Injection.create<Rx<dynamic>>(MockRx());

      expect(Injection.of<String>(), 'example');
      expect(Injection.of<int>(), 42);
      expect(Injection.of<Rx<dynamic>>(), isA<MockRx>());

      Injection.deleteAll();

      expect(
        () => Injection.of<String>(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => Injection.of<int>(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => Injection.of<Rx<dynamic>>(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('deleteAll() should disable SuperController instances', () {
      final controller1 = MockController();
      final controller2 = MockController();

      Injection.create<MockController>(controller1);
      Injection.create<SuperController>(controller2);

      expect(controller1.disableCalled, false);
      expect(controller2.disableCalled, false);

      Injection.deleteAll();

      expect(controller1.disableCalled, true);
      expect(controller2.disableCalled, true);
    });

    test('deleteAll() should dispose Rx instances', () {
      final rxInstance1 = MockRx();
      final rxInstance2 = MockRx();

      Injection.create<MockRx>(rxInstance1);
      Injection.create<Rx<dynamic>>(rxInstance2);

      expect(rxInstance1.disposeCalled, false);
      expect(rxInstance2.disposeCalled, false);

      Injection.deleteAll();

      expect(rxInstance1.disposeCalled, true);
      expect(rxInstance2.disposeCalled, true);
    });

    test('activate() should set the scoped state', () {
      expect(Injection.scoped, true);
    });

    test('deactivate() should reset the scoped state', () {
      Injection.deactivate();

      expect(Injection.scoped, false);
    });
  });
}

class MockController extends SuperController {
  bool enableCalled = false;
  bool disableCalled = false;

  @override
  void enable() {
    super.enable();
    enableCalled = true;
  }

  @override
  void disable() {
    disableCalled = true;
    super.disable();
  }
}

class MockRx extends Rx<dynamic> {
  bool disposeCalled = false;

  @override
  void dispose() {
    disposeCalled = true;
    super.dispose();
  }
}
