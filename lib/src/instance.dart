import 'package:flutter/foundation.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/core/logger.dart';

/// A class that manages the instances of dependencies.
class InstanceManager {
  static const _code = 'super';
  static final Map<String, dynamic> _instances = {};
  static List<Object> _mocks = [];
  static bool _isScoped = false;
  static bool _testMode = false;
  static bool? _autoDispose;

  /// Check the scoped state of the framework.
  static bool get scoped => _isScoped;

  /// Generates the key based on the type to register an instance
  /// in the `_instances` map.
  static String _instKey<T>() {
    return T.toString();
  }

  /// Creates a singleton instance of a dependency and registers it
  /// with the manager.
  static void create<T>(T instance, {bool lazy = false}) {
    if (!_isScoped) {
      Super.log(
        'SuperApp not found, Wrap the top level Widget with SuperApp.',
        logType: LogType.error,
      );
      throw FlutterError(
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
  /// and starts the controller if the dependency extends `SuperController`.
  static T of<T>() {
    final key = _instKey<T>();
    if (_instances.containsKey(key)) {
      var inst = _instances[key];
      if (inst == null) {
        throw FlutterError('Instance of "$T" is not registered.');
      }
      if (inst is T Function()) {
        // register T instance and return it
        inst = inst();
        _register(instance: inst, key: key);
        return of<T>();
      }

      final i = inst as T;
      if (i is SuperController) i.start();
      return i;
    } else {
      throw FlutterError(
        '"$T" not found. You have to invoke "Super.init($T())".',
      );
    }
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
    if (_testMode) {
      if (_mocks.isNotEmpty) {
        for (final item in _mocks) {
          final mock = _registerMock<T>(item);
          if (mock != null) {
            _instances[key] = mock;
            return;
          }
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
    final newKey = key ?? _instKey<T>();

    if (!_instances.containsKey(newKey)) {
      Super.log(
        'Instance "$newKey" already removed.',
        logType: LogType.warning,
      );
      return;
    }

    final inst = _instances[newKey];

    if (inst == null) {
      Super.log(
        'Instance "$newKey" is not registered.',
        logType: LogType.error,
      );
    }

    final i = inst;

    if (i is SuperController) i.stop();

    if (i is Rx) i.dispose();

    _instances.remove(newKey);
    if (_instances.containsKey(newKey)) {
      Super.log('Error deleting object "$newKey".', logType: LogType.error);
    } else {
      Super.log('"$newKey" has been terminated.', logType: LogType.warning);
    }
  }

  /// Deletes all instances of dependencies from the manager.
  /// If autoDispose is set to false, [force] must be set to
  /// true to delete resources.
  static void deleteAll({bool force = false}) {
    if (_autoDispose != null && !_autoDispose! && !force) return;
    final keys = _instances.keys.toList();
    for (final key in keys) {
      delete<void>(key: key, force: force);
    }
    _instances.clear();
  }

  /// Activate the Super framework
  ///
  /// Not intended for use outside the [Super] library
  static void activate({
    required bool testMode,
    required bool autoDispose,
    List<Object>? mocks,
  }) {
    // Scope
    _isScoped = true;

    // Test Mode
    _testMode = testMode;

    // Auto Dispose
    _autoDispose = autoDispose;

    // Mocks
    if (mocks != null && mocks.isNotEmpty) {
      _mocks = List.of(mocks);
    }
  }

  /// Deactivate the Super framework
  ///
  /// Not intended for use outside the [Super] library
  static void deactivate(String code) {
    if (code != _code) return;
    // Delete all instances managed by the InstanceManager.
    deleteAll();

    // Reset the scoped state of the framework.
    _isScoped = false;

    // Reset mode of the framework
    _testMode = false;

    // Reset Auto Dispose
    _autoDispose = null;

    // Reset mocks
    _mocks = [];
  }
}
