import 'package:dart_super/src/core/interface.dart';
import 'package:dart_super/src/core/logger.dart';
import 'package:dart_super/src/injection.dart';

/// Enables access to functionality through Super
extension SuperExt on SuperInterface {
  /// Activate the Super framework
  void activate({
    bool testMode = false,
    List<Object>? mocks,
    bool enableLog = false,
  }) {
    Injection.activate(
      mocks: mocks,
      testMode: testMode,
      enableLog: enableLog,
    );
  }

  /// Deactivate the Super framework
  void deactivate() {
    Injection.deactivate();
  }

  /// Check the scoped state of the framework.
  bool get isScoped => Injection.scoped;

/* ========================= Logger ========================= */

  /// Create logs using the logger from the Super framework
  void log(Object val, {bool warning = false}) => logger(val, warning: warning);

  /* ========================= Instance ========================= */

  /// Retrieves the instance of a dependency from the manager
  /// and enables the controller if the dependency extends `SuperController`.
  T of<T>() => Injection.of<T>();

  /// Initializes and retrieves the instance of a dependency,
  /// or creates a new instance if it doesn't exist.
  T init<T>(T instance, {bool autoDispose = true}) =>
      Injection.init<T>(instance, autoDispose);

  /// Creates a singleton instance of a dependency and registers
  /// it with the manager.
  void create<T>(T instance, {bool autoDispose = true}) =>
      Injection.create<T>(instance, autoDispose);

  /// Deletes the instance of a dependency from the manager.
  void delete<T>({String? key, bool force = true}) {
    return Injection.delete<T>(
      key: key,
      force: force,
    );
  }

  /// Deletes all instances of dependencies from the manager.
  void deleteAll() => Injection.deleteAll();
}
