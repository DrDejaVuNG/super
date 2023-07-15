import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/injection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SuperExt', () {
    setUp(() {
      Injection.activate(
        testMode: true,
        autoDispose: true,
        enableLog: true,
      );
    });

    test('SuperExt - create', () {
      Super.create<String>('Hello');

      expect(Super.of<String>(), 'Hello');

      Super.log('Test Complete');
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
