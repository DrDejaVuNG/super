// ignore_for_file: no_runtimetype_tostring,
part of 'rx.dart';

/// {@template rx_t}
/// A reactive container for holding a state of type `T`.
///
/// The `RxT` class is a specialization of the `Rx` class that represents
/// a reactive state. It allows you to store and update a state of type `T`
/// and automatically notifies its listeners when the state changes.
///
/// Example usage:
///
/// ```dart
/// final counter = RxT<int>(0);
///
/// void increment() {
///   counter.state++;
/// }
///
/// // Adding a listener to the counter
/// counter.addListener(() {
///   print('Counter state changed: ${counter.state}');
/// });
///
/// // Updating the counter state
/// incrementCounter(); // This will trigger the listener and print the updated state.
/// ```
///
/// It is best used for local state i.e state used in a single controller.
///
/// **Note:** When using the RxT class, it is important to call the `dispose()`
/// method on the object when it is no longer needed to prevent memory leaks.
/// This can be done using the onDisable method of your controller.
/// {@endtemplate}
final class RxT<T> extends Rx<T> {
  /// {@macro rx_t}
  RxT(this._state);

  T _state;

  /// The current state of the reactive container.
  T get state {
    RxListener._read(this);
    return _state;
  }

  /// Updates the state of the reactive container and notifies listeners.
  ///
  /// The `state` argument is the new state to be assigned to the reactive
  /// container.
  /// If the new state is the same as the current state, no notifications
  /// are triggered.
  set state(T state) {
    if ('$_state' == '$state') return;
    _state = state;
    _notifyListeners();
  }

  @override
  String toString() => '$runtimeType($state)';
}

/// {@macro rx_t}
final class RxString extends RxT<String> {
  /// {@macro rx_t}
  RxString(super.state);
}

/// {@macro rx_t}
final class RxInt extends RxT<int> {
  /// {@macro rx_t}
  RxInt(super.state);
}

/// {@macro rx_t}
final class RxDouble extends RxT<double> {
  /// {@macro rx_t}
  RxDouble(super.state);
}

/// {@macro rx_t}
final class RxBool extends RxT<bool> {
  /// {@macro rx_t}
  RxBool(super.state);
}
