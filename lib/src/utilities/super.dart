import 'package:flutter_super/src/core/interface.dart';
import 'package:flutter_super/src/core/logger.dart';
import 'package:flutter_super/src/instance.dart';

/// Enables access to functionality through Super
extension SuperExt on SuperInterface {
  /* ========================= App ========================= */

  /// Check the scoped state of the framework.
  bool get isScoped => InstanceManager.scoped;

  // /// Activate the Super framework
  // ///
  // /// Not for use outside the [Super] library
  // void activate({
  //   required bool autoDispose,
  //   required bool testMode,
  //   List<Object>? mocks,
  // }) {
  //   InstanceManager.activate(
  //     autoDispose: autoDispose,
  //     mocks: mocks,
  //     testMode: testMode,
  //   );
  // }

  // /// Deactivate the Super framework
  // ///
  // /// Not for use outside the [Super] library
  // void deactivate(String code) {
  //   InstanceManager.deactivate(code);
  // }

/* ========================= Logger ========================= */

  /// Create logs using the logger from the Super framework
  void log(String msg, {LogType logType = LogType.info}) =>
      logger(msg, logType: logType);

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
  /// If autoDispose is set to false, [force] must be set to
  /// true to delete resources.
  void delete<T>({String? key, bool force = false}) =>
      InstanceManager.delete<T>(key: key, force: force);

  /// Deletes all instances of dependencies from the manager.
  /// If autoDispose is set to false, [force] must be set to
  /// true to delete resources.
  void deleteAll({bool force = false}) =>
      InstanceManager.deleteAll(force: force);
}
