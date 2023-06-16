// ignore_for_file: no_runtimetype_tostring,
part of 'rx.dart';

/// {@template rx_t}
/// A reactive container for holding a value of type `T`.
///
/// The `RxT` class is a specialization of the `Rx` class that represents
/// a reactive value. It allows you to store and update a value of type `T`
/// and automatically notifies its listeners when the value changes.
///
/// Example usage:
///
/// ```dart
/// final counter = RxT<int>(0);
///
/// void incrementCounter() {
///   counter.value++;
/// }
///
/// // Adding a listener to the counter
/// counter.addListener(() {
///   print('Counter value changed: ${counter.value}');
/// });
///
/// // Updating the counter value
/// incrementCounter(); // This will trigger the listener and print the updated value.
/// ```
///
/// It is best used for local state i.e state used in a single controller.
///
/// **Note:** When using the RxT class, it is important to call the `dispose()`
/// method on the object when it is no longer needed to prevent memory leaks.
/// This can be done using the onDisable method of your controller.
/// {@endtemplate}
final class RxT<T> extends Rx {
  /// {@macro rx_t}
  RxT(this._value) {
    if (kFlutterMemoryAllocationsEnabled) {
      MemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/foundation.dart',
        className: '$RxT',
        object: this,
      );
    }
    _creationDispatched = true;
  }

  T _value;

  /// The current value of the reactive container.
  T get value {
    RxListener._read(this);
    return _value;
  }

  /// Updates the value of the reactive container and notifies listeners.
  ///
  /// The `value` argument is the new value to be assigned to the reactive
  /// container.
  /// If the new value is the same as the current value, no notifications
  /// are triggered.
  set value(T value) {
    if ('$_value' == '$value') return;
    _value = value;
    _notifyListeners();
  }

  @override
  String toString() => '$runtimeType($value)';
}

/// {@macro rx_t}
final class RxString extends RxT<String> {
  /// {@macro rx_t}
  RxString(super.value);
}

/// {@macro rx_t}
final class RxInt extends RxT<int> {
  /// {@macro rx_t}
  RxInt(super.value);
}

/// {@macro rx_t}
final class RxDouble extends RxT<double> {
  /// {@macro rx_t}
  RxDouble(super.value);
}

/// {@macro rx_t}
final class RxBool extends RxT<bool> {
  /// {@macro rx_t}
  RxBool(super.value);
}
