import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/instance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SuperExt', () {
    setUp(() {
      InstanceManager.activate(
        testMode: true,
        autoDispose: true,
      );
    });
    
    test('SuperExt - create', () {
      Super.create<String>('Hello');

      expect(Super.of<String>(), 'Hello');
    });

    test('SuperExt - deleteAll', () {
      Super.deleteAll();
      expect(
        () => Super.of<String>(),
        throwsA(isA<FlutterError>()),
      );
    });
  });
}
