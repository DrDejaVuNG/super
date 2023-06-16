part of 'rx.dart';

/// {@template rx_set}
/// A reactive container for managing a set of unique values of type `T`.
///
/// The `RxSet` class is a specialization of the `Rx` class that represents
/// a reactive set. It allows you to store and update a set of unique values
/// of type `T` and automatically notifies its listeners when the set changes.
///
/// Example usage:
///
/// ```dart
/// final items = RxSet<String>();
///
/// void addItem(String item) {
///   items.add(item);
/// }
///
/// // Adding a listener to the set
/// items.addListener(() {
///   print('Set changed: ${items.toList()}');
/// });
///
/// // Updating the set
/// addItem('Apple'); // This will trigger the listener and print the updated set.
/// ```
///
/// **Note:** When using the `RxSet` class, it is important to call the
/// `dispose()` method on the object when it is no longer needed to prevent
/// memory leaks.
/// This can be done using the onDisable method of your controller.
/// {@endtemplate}
final class RxSet<T> extends Rx with SetMixin<T> {
  /// {@macro rx_set}
  RxSet([Set<T>? set]) {
    if (kFlutterMemoryAllocationsEnabled && !_creationDispatched) {
      MemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/foundation.dart',
        className: '$RxSet',
        object: this,
      );
      _creationDispatched = true;
    }
    if (set != null) {
      _set = set;
    } else {
      _set = {};
    }
  }

  late Set<T> _set;

  /// Creates an `RxSet` with the given `set` as the initial set of values.
  ///
  /// The `set` argument is an optional parameter that represents the initial
  /// set of values for the `RxSet`. If not provided, an empty set is created.
  ///
  /// Example:
  ///
  /// ```dart
  /// final mySet = RxSet.of<String>({'apple', 'banana', 'orange'});
  /// ```
  static RxSet<T> of<T>(Set<T> set) => RxSet<T>(set);

  @override
  bool add(T value) {
    final result = _set.add(value);
    if (result) {
      _notifyListeners();
    }
    return result;
  }

  @override
  bool contains(Object? element) {
    return _set.contains(element);
  }

  @override
  Iterator<T> get iterator {
    return _set.iterator;
  }

  @override
  int get length {
    return _set.length;
  }

  @override
  T? lookup(Object? element) {
    return _set.lookup(element);
  }

  @override
  bool remove(Object? value) {
    final result = _set.remove(value);
    if (result) {
      _notifyListeners();
    }
    return result;
  }

  @override
  Set<T> toSet() {
    return this;
  }
}
