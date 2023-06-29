// ignore_for_file: invalid_override_of_non_virtual_member

import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/instance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InstanceManager', () {
    setUp(() {
      InstanceManager.activate(
        testMode: true,
        autoDispose: true,
        mocks: [],
      );
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(InstanceManager.deactivate);

    test('create() should register a singleton instance', () {
      final instance = MockRx();
      final lazyInstance = MockController();

      InstanceManager.create<MockRx>(instance);

      expect(InstanceManager.of<MockRx>(), instance);

      InstanceManager.create<MockController>(lazyInstance, lazy: true);

      expect(InstanceManager.of<MockController>(), lazyInstance);
    });

    test('create() should throw an error if SuperApp is not found', () {
      InstanceManager.deactivate();

      expect(
        () => InstanceManager.create<String>('example'),
        throwsA(isA<FlutterError>()),
      );
    });

    test('of() should retrieve an instance from the manager', () {
      const instance = 'example';

      InstanceManager.create<String>(instance);

      expect(InstanceManager.of<String>(), instance);
    });

    test('of() should invoke start() on SuperController instances', () {
      final instance = MockController();

      InstanceManager.create<MockController>(instance);

      expect(instance.startCalled, false);

      InstanceManager.of<MockController>();

      expect(instance.startCalled, true);
    });

    test('of() should register and retrieve lazy instances', () {
      const lazyInstance = 10;

      InstanceManager.create<int>(lazyInstance, lazy: true);

      expect(InstanceManager.of<int>(), lazyInstance);
    });

    test('of() should recursively register and retrieve instances', () {
      final instance = MockController();

      InstanceManager.create<MockController>(instance);

      final mockInstance = InstanceManager.of<MockController>();

      expect(mockInstance, instance);
    });

    test('of() should throw an error if type T is not found', () {
      expect(
        () => InstanceManager.of<String>(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('init() should retrieve an instance or create a new one', () {
      const instance = 'example';

      InstanceManager.create<String>(instance);
      // String key already exists
      expect(InstanceManager.init<String>('other'), instance);
      expect(InstanceManager.init<int>(10), 10);
    });

    test('init() should create a new instance if it does not exist', () {
      const instance = 'example';

      expect(InstanceManager.init<String>(instance), instance);
      expect(InstanceManager.of<String>(), instance);
    });

    test('delete() should delete an instance from the manager', () {
      const instance = 'example';

      InstanceManager.create<String>(instance);

      expect(InstanceManager.of<String>(), instance);

      InstanceManager.delete<String>();

      expect(() => InstanceManager.of<String>(), throwsA(isA<FlutterError>()));
    });

    test('delete() should stop SuperController instances', () {
      final controller = MockController();

      InstanceManager.create<MockController>(controller);

      expect(controller.stopCalled, false);

      InstanceManager.delete<MockController>();

      expect(controller.stopCalled, true);
    });

    test('delete() should dispose Rx instances', () {
      final rxInstance = MockRx();

      InstanceManager.create<Rx>(rxInstance);

      expect(rxInstance.disposeCalled, false);

      InstanceManager.delete<Rx>();

      expect(rxInstance.disposeCalled, true);
    });

    test('deleteAll() should delete all instances from the manager', () {
      InstanceManager.create<String>('example');
      InstanceManager.create<int>(42);
      InstanceManager.create<Rx>(MockRx());

      expect(InstanceManager.of<String>(), 'example');
      expect(InstanceManager.of<int>(), 42);
      expect(InstanceManager.of<Rx>(), isA<MockRx>());

      InstanceManager.deleteAll();

      expect(
        () => InstanceManager.of<String>(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => InstanceManager.of<int>(),
        throwsA(isA<FlutterError>()),
      );
      expect(
        () => InstanceManager.of<Rx>(),
        throwsA(isA<FlutterError>()),
      );
    });

    test('deleteAll() should stop SuperController instances', () {
      final controller1 = MockController();
      final controller2 = MockController();

      InstanceManager.create<MockController>(controller1);
      InstanceManager.create<SuperController>(controller2);

      expect(controller1.stopCalled, false);
      expect(controller2.stopCalled, false);

      InstanceManager.deleteAll();

      expect(controller1.stopCalled, true);
      expect(controller2.stopCalled, true);
    });

    test('deleteAll() should dispose Rx instances', () {
      final rxInstance1 = MockRx();
      final rxInstance2 = MockRx();

      InstanceManager.create<MockRx>(rxInstance1);
      InstanceManager.create<Rx>(rxInstance2);

      expect(rxInstance1.disposeCalled, false);
      expect(rxInstance2.disposeCalled, false);

      InstanceManager.deleteAll();

      expect(rxInstance1.disposeCalled, true);
      expect(rxInstance2.disposeCalled, true);
    });

    test('activate() should set the scoped state', () {
      expect(InstanceManager.scoped, true);
    });

    test('deactivate() should reset the scoped state', () {
      InstanceManager.deactivate();

      expect(InstanceManager.scoped, false);
    });
  });
}

class MockController extends SuperController {
  bool startCalled = false;
  bool stopCalled = false;

  @override
  void start() {
    super.start();
    startCalled = true;
  }

  @override
  void stop() {
    stopCalled = true;
    super.stop();
  }
}

class MockRx extends Rx {
  bool disposeCalled = false;

  @override
  void dispose() {
    disposeCalled = true;
    super.dispose();
  }
}
