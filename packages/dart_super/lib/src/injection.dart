import 'package:dart_super/src/controller.dart';
import 'package:dart_super/src/core/logger.dart';
import 'package:dart_super/src/rx/rx.dart';

/// A class that manages the instances of dependencies.
class Injection {
  static final Map<String, dynamic> _instances = {};
  static List<Object> _mocks = [];
  static bool _scoped = false;
  static bool _testMode = false;
  static bool _enableLog = false;
  static bool? _autoDispose;

  /// Enable Logs in the Super Framework
  static bool get enableLog => _enableLog;

  /// Check the scoped state of the framework.
  static bool get scoped => _scoped;

  /// Generates the key based on the type to register an instance
  /// in the `_instances` map.
  static String _instKey<T>() {
    return T.toString();
  }

  /// Creates a singleton instance of a dependency and registers it
  /// with the manager.
  static void create<T>(T instance, {bool lazy = false}) {
    if (!_scoped) {
      throw StateError(
        'SuperApp not found, Wrap the root widget of your app '
        'with [SuperApp] to enable the Super framework.',
      );
    }
    final key = _instKey<T>();
    if (lazy) {
      _instances[key] = () => instance;
      return;
    }
    _register<T>(instance: instance, key: key);
  }

  /// Retrieves the instance of a dependency from the manager
  /// and enables the controller if the dependency extends `SuperController`.
  static T of<T>() {
    final key = _instKey<T>();
    if (_instances.containsKey(key)) {
      var inst = _instances[key];

      if (inst is T Function()) {
        // register T instance and return it
        inst = inst();
        _register(instance: inst, key: key);
        return of<T>();
      }

      if (inst is SuperController) inst.enable();
      return inst as T;
    }
    throw StateError(
      'Failed to retrieve $T dependency. Call "Super.init($T())" instead.',
    );
  }

  /// Initializes and retrieves the instance of a dependency, or creates
  /// a new instance if it doesn't exist.
  static T init<T>(T inst) {
    try {
      return of<T>();
    } catch (e) {
      create<T>(inst);
      return of<T>();
    }
  }

  /// Registers the instance into the `_instances` map.
  static void _register<T>({
    required T instance,
    required String key,
  }) {
    if (_testMode && _mocks.isNotEmpty) {
      for (final item in _mocks) {
        final mock = _registerMock<T>(item);
        if (mock != null) {
          _instances[key] = mock;
          return;
        }
      }
    }
    _instances[key] = instance;
  }

  /// Attempts to register a mock instance into the `_instances` map.
  static T? _registerMock<T>(Object mock) {
    try {
      return mock as T;
    } catch (e) {
      return null;
    }
  }

  /// Deletes the instance of a dependency from the manager.
  /// If autoDispose is set to false, [force] must be set to
  /// true to delete resources.
  static void delete<T>({String? key, bool force = false}) {
    if (_autoDispose != null && !_autoDispose! && !force) return;
    final instKey = key ?? _instKey<T>();
    if (!_instances.containsKey(instKey)) return;
    final inst = _instances[instKey];

    if (inst is SuperController) inst.disable();
    if (inst is Rx) inst.dispose();

    _instances.remove(instKey);
    logger(
      '$instKey dependency was deleted.',
      warning: true,
    );
  }

  /// Deletes all instances of dependencies from the manager.
  static void deleteAll() {
    final keys = _instances.keys.toList();
    for (final key in keys) {
      delete<void>(key: key, force: true);
    }
    _instances.clear();
  }

  /// Activate the Super framework
  ///
  /// Not intended for use outside the Super library
  static void activate({
    required bool testMode,
    required bool enableLog,
    required bool autoDispose,
    List<Object>? mocks,
  }) {
    _scoped = true;
    _testMode = testMode;
    _enableLog = enableLog;
    _autoDispose = autoDispose;

    if (mocks != null && mocks.isNotEmpty) {
      _mocks = List.of(mocks);
    }
  }

  /// Deactivate the Super framework
  ///
  /// Not intended for use outside the Super library
  static void deactivate() {
    deleteAll();
    _scoped = false;
    _testMode = false;
    _autoDispose = null;
    _mocks = [];
  }
}
