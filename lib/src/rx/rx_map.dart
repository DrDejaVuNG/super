part of 'rx.dart';

/// {@template rx_map}
/// A reactive map that extends the functionality of a regular Dart map
/// and notifies its listeners when the map is modified.
///
/// The `RxMap` class provides a convenient way to create and manage a
/// map of key-value pairs that can be observed for changes. It extends
/// the `MapMixin` class to provide an implementation of the `Map` interface
/// and adds reactive behavior by notifying listeners whenever the map is
/// modified.
///
/// Example usage:
///
/// ```dart
/// final userMap = RxMap<String, String>();
///
/// // Adding a listener to the map
/// userMap.addListener(() {
///   print('Map changed: ${userMap.keys}: ${userMap.values}');
/// });
///
/// // Modifying the map
/// userMap['name'] = 'John Doe'; // This will trigger the listener and print the updated map.
/// userMap['age'] = '30';
///
/// // Accessing the values
/// print(userMap['name']); // Output: John Doe
///
/// // Removing a key-value pair
/// userMap.remove('age');
/// ```
///
/// **Note:** When using the `RxMap` class, it is important to call the
/// `dispose()` method on the object when it is no longer needed to
/// prevent memory leaks.
/// This can be done using the onDisable method of your controller.
/// {@endtemplate}
final class RxMap<K, V> extends Rx with MapMixin<K, V> {
  /// {@macro rx_map}
  RxMap([Map<K, V>? map]) {
    if (kFlutterMemoryAllocationsEnabled && !_creationDispatched) {
      MemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/foundation.dart',
        className: '$RxMap',
        object: this,
      );
      _creationDispatched = true;
    }
    if (map != null) {
      _map = map;
    } else {
      _map = {};
    }
  }

  late Map<K, V> _map;

  /// Creates an `RxMap` from an existing map.
  ///
  /// The `map` argument represents an existing map from which an `RxMap`
  /// instance is created. The keys and values of the `map` are copied
  /// to the `RxMap`, and any modifications made to the `RxMap` will not
  /// affect the original `map`.
  ///
  /// Example:
  ///
  /// ```dart
  /// final existingMap = {'name': 'John Doe', 'age': '30'};
  /// final rxMap = RxMap<String, String>.of(existingMap);
  /// ```
  static RxMap<K, V> of<K, V>(Map<K, V> map) => RxMap<K, V>(map);

  @override
  void addAll(Map<K, V> other) {
    other.forEach((K key, V value) {
      _map[key] = value;
    });
    _notifyListeners();
  }

  @override
  V? operator [](Object? key) {
    return _map[key];
  }

  @override
  void operator []=(K key, V value) {
    _map[key] = value;
    _notifyListeners();
  }

  @override
  void clear() {
    _map.clear();
    _notifyListeners();
  }

  @override
  Iterable<K> get keys {
    return _map.keys;
  }

  @override
  V? remove(Object? key) {
    final result = _map.remove(key);
    if (result != null) {
      _notifyListeners();
    }
    return result;
  }
}
