import 'package:flutter_super/src/core/interface.dart';
import 'package:flutter_super/src/core/logger.dart';
import 'package:flutter_super/src/instance.dart';

/// Enables access to functionality through Super
extension SuperExt on SuperInterface {
  /* ========================= App ========================= */

  /// Check the scoped state of the framework.
  bool get isScoped => InstanceManager.scoped;

/* ========================= Logger ========================= */

  /// Create logs using the logger from the Super framework
  void log(
    String msg, {
    bool warning = false,
  }) =>
      logger(
        msg,
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
