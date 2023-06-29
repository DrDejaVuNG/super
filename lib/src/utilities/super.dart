import 'package:flutter/foundation.dart';
import 'package:flutter_super/src/core/interface.dart';
import 'package:flutter_super/src/core/logger.dart';
import 'package:flutter_super/src/instance.dart';

/// Enables access to functionality through Super
extension SuperExt on SuperInterface {
  /* ========================= App ========================= */
  /// Check the scoped state of the framework.
  bool get isScoped => InstanceManager.scoped;

  /// Activate the Super framework
  ///
  /// Not for use outside the [Super] library
  // ignore: use_setters_to_change_properties
  void activate({
    // required bool autoDispose,
    required bool enableLog,
    // required bool testMode,
    // List<Object>? mocks,
  }) {
    _enableLog = enableLog;
    // InstanceManager.activate(
    //   autoDispose: autoDispose,
    //   mocks: mocks,
    //   testMode: testMode,
    // );
  }

  // /// Deactivate the Super framework
  // ///
  // /// Not for use outside the [Super] library
  // void deactivate(String code) {
  //   InstanceManager.deactivate(code);
  // }

/* ========================= Logger ========================= */
  static bool _enableLog = kDebugMode;

  /// Create logs using the logger from the Super framework
  void log(
    String msg, {
    bool warning = false,
  }) =>
      logger(
        msg,
        _enableLog,
        warning: warning,
      );

  /* ========================= Instance ========================= */

  /// Retrieves the instance of a dependency from the manager
  /// and starts the controller if the dependency extends `SuperController`.
  T of<T>() => InstanceManager.of<T>();

  /// Initializes and retrieves the instance of a dependency,
  /// or creates a new instance if it doesn't exist.
  T init<T>(T instance) => InstanceManager.init<T>(instance);

  /// Creates a singleton instance of a dependency and registers
  /// it with the manager.
  void create<T>(T instance, {bool lazy = false}) => InstanceManager.create<T>(
        instance,
        lazy: lazy,
      );

  /// Deletes the instance of a dependency from the manager.
  void delete<T>({String? key}) =>
      InstanceManager.delete<T>(key: key, force: true);

  /// Deletes all instances of dependencies from the manager.
  void deleteAll() => InstanceManager.deleteAll();
}
