import 'package:dart_super/src/controller.dart';
import 'package:dart_super/src/core/logger.dart';
import 'package:dart_super/src/rx/rx.dart';

/// A class that manages the instances of dependencies.
class Injection {
  static final Map<String, ({bool disp, dynamic inst})> _instances = {};
  static List<Object> _mocks = [];
  static bool _scoped = false;
  static bool _testMode = false;
  static bool _enableLog = false;

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
  static void create<T>(T instance, bool autoDispose) {
    if (!_scoped) {
      throw StateError(
        'SuperApp not found, Wrap the root widget of your app '
        'with [SuperApp] to enable the Super framework.',
      );
    }

    final key = _instKey<T>();
    _register<T>(instance: instance, key: key, autoDispose: autoDispose);
  }

  /// Retrieves the instance of a dependency from the manager
  /// and enables the controller if the dependency extends `SuperController`.
  static T of<T>() {
    final key = _instKey<T>();
    if (_instances.containsKey(key)) {
      final inst = _instances[key]!.inst;

      if (inst is SuperController) inst.enable();
      return inst as T;
    }
    throw StateError(
      'Failed to retrieve $T dependency. Call "Super.init($T())" instead.',
    );
  }

  /// Initializes and retrieves the instance of a dependency, or creates
  /// a new instance if it doesn't exist.
  static T init<T>(T inst, bool autoDispose) {
    try {
      return of<T>();
    } catch (e) {
      create<T>(inst, autoDispose);
      return of<T>();
    }
  }

  /// Registers the instance into the `_instances` map.
  static void _register<T>({
    required T instance,
    required String key,
    required bool autoDispose,
  }) {
    if (_testMode && _mocks.isNotEmpty) {
      for (final item in _mocks) {
        final mock = _registerMock<T>(item);
        if (mock != null) {
          _instances[key] = (inst: mock, disp: autoDispose);
          return;
        }
      }
    }
    _instances[key] = (inst: instance, disp: autoDispose);
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
    final instKey = key ?? _instKey<T>();
    if (!_instances.containsKey(instKey)) return;

    final inst = _instances[instKey]!.inst;
    if (!_instances[instKey]!.disp && !force) return;

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
    List<Object>? mocks,
  }) {
    _scoped = true;
    _testMode = testMode;
    _enableLog = enableLog;

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
    _mocks = [];
  }
}
