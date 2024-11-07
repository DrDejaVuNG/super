// ignore_for_file: invalid_override_of_non_virtual_member

import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Super', () {
    setUp(() {
      Super.activate(
        testMode: true,
        mocks: [],
        enableLog: true,
      );
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    tearDown(Super.deactivate);

    test('create() should register a singleton instance', () {
      final instance = MockRx();

      Super.create<MockRx>(instance);

      expect(Super.of<MockRx>(), instance);
    });

    test('create() should throw an error if SuperApp is not found', () {
      Super.deactivate();

      expect(
        () => Super.create<String>('example'),
        throwsA(isA<StateError>()),
      );
    });

    test('of() should retrieve an instance from the manager', () {
      const instance = 'example';

      Super.create<String>(instance);

      expect(Super.of<String>(), instance);
    });

    test('of() should invoke enable() on SuperController instances', () {
      final instance = MockController();

      Super.create<MockController>(instance);

      expect(instance.enableCalled, false);

      Super.of<MockController>();

      expect(instance.enableCalled, true);
    });

    test('of() should recursively register and retrieve instances', () {
      final instance = MockController();

      Super.create<MockController>(instance);

      final mockInstance = Super.of<MockController>();

      expect(mockInstance, instance);
    });

    test('of() should throw an error if type T is not found', () {
      expect(
        () => Super.of<String>(),
        throwsA(isA<StateError>()),
      );
    });

    test('init() should retrieve an instance or create a new one', () {
      const instance = 'example';

      Super.create<String>(instance);
      // String key already exists
      expect(Super.init<String>('other'), instance);
      expect(Super.init<int>(10), 10);
    });

    test('init() should create a new instance if it does not exist', () {
      const instance = 'example';

      expect(Super.init<String>(instance), instance);
      expect(Super.of<String>(), instance);
    });

    test('delete() should delete an instance from the manager', () {
      const instance = 'example';

      Super.create<String>(instance);

      expect(Super.of<String>(), instance);

      Super.delete<String>(force: false);

      expect(() => Super.of<String>(), throwsA(isA<StateError>()));
    });

    test('delete() should disable SuperController instances', () {
      final controller = MockController();

      Super.create<MockController>(controller);

      expect(controller.disableCalled, false);

      Super.delete<MockController>(force: false);

      expect(controller.disableCalled, true);
    });

    test('delete() should dispose Rx instances', () {
      final rxInstance = MockRx();

      Super.create<Rx<dynamic>>(rxInstance);

      expect(rxInstance.disposeCalled, false);

      Super.delete<Rx<dynamic>>(force: false);

      expect(rxInstance.disposeCalled, true);
    });

    test('deleteAll() should delete all instances from the manager', () {
      Super
        ..create<String>('example')
        ..create<int>(42)
        ..create<Rx<dynamic>>(MockRx());

      expect(Super.of<String>(), 'example');
      expect(Super.of<int>(), 42);
      expect(Super.of<Rx<dynamic>>(), isA<MockRx>());

      Super.deleteAll();

      expect(
        () => Super.of<String>(),
        throwsA(isA<StateError>()),
      );
      expect(
        () => Super.of<int>(),
        throwsA(isA<StateError>()),
      );
      expect(
        () => Super.of<Rx<dynamic>>(),
        throwsA(isA<StateError>()),
      );
    });

    test('deleteAll() should disable SuperController instances', () {
      final controller1 = MockController();
      final controller2 = MockController();

      Super
        ..create<MockController>(controller1)
        ..create<SuperController>(controller2);

      expect(controller1.disableCalled, false);
      expect(controller2.disableCalled, false);

      Super.deleteAll();

      expect(controller1.disableCalled, true);
      expect(controller2.disableCalled, true);
    });

    test('deleteAll() should dispose Rx instances', () {
      final rxInstance1 = MockRx();
      final rxInstance2 = MockRx();

      Super
        ..create<MockRx>(rxInstance1)
        ..create<Rx<dynamic>>(rxInstance2);

      expect(rxInstance1.disposeCalled, false);
      expect(rxInstance2.disposeCalled, false);

      Super.deleteAll();

      expect(rxInstance1.disposeCalled, true);
      expect(rxInstance2.disposeCalled, true);
    });

    test('activate() should set the scoped state', () {
      expect(Super.isScoped, true);
    });

    test('deactivate() should reset the scoped state', () {
      Super.deactivate();

      expect(Super.isScoped, false);
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

  @override
  Null get state => null;

  @override
  set state(dynamic state) {}
}
