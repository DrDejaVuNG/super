part of 'rx.dart';

/// {@template rx_notifier}
/// An abstract base class for creating reactive notifiers that manage
/// a state of type `T`.
///
/// The `RxNotifier` class provides a foundation for creating reactive notifiers
/// that encapsulate a piece of immutable state and notify their listeners
/// when the state changes. Subclasses of `RxNotifier` must override the
/// `watch` method to provide the initial state and implement the logic
/// for updating the state.
///
/// Example usage:
///
/// ```dart
/// class CounterNotifier extends RxNotifier<int> {
///   @override
///   int watch() {
///     return 0; // Initial state
///   }
///
///   void increment() {
///     state++; // Update the state
///   }
/// }
///
/// final counter = CounterNotifier();
///
/// // Adding a listener to the notifier
/// counter.addListener(() {
///   print('Counter changed: ${counter.state}');
/// });
///
/// // Updating the state
/// counter.increment(); // This will trigger the listener and print the updated state.
/// ```
///
/// It is best used for global state i.e state used in multiple controllers
/// but it could also be used for a single controller to abstract a
/// state and its events e.g if a state has a lot events, rather than
/// complicating your controller, you could use an RxNotifier for that singular
/// state instead.
///
/// **Note:** When using the RxNotifier class, it is important to call the
/// `dispose()` method on the object when it is no longer needed to
/// prevent memory leaks.
/// This can be done using the onDisable method of your controller.
/// {@endtemplate}
abstract class RxNotifier<T> extends Rx {
  /// {@macro rx_notifier}
  RxNotifier() {
    if (kFlutterMemoryAllocationsEnabled && !_creationDispatched) {
      MemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/foundation.dart',
        className: '$RxNotifier',
        object: this,
      );
      _creationDispatched = true;
    }
    _state = watch();
  }

  late T _state;

  /// Retrieves the initial state for the notifier.
  ///
  /// Subclasses must override this method to provide the initial state for
  /// the notifier. The initial state is returned and used as the current state
  /// when the notifier is created.
  ///
  /// Example:
  ///
  /// ```dart
  /// @override
  /// int watch() {
  ///   return 0; // Initial state
  /// }
  /// ```
  @protected
  T watch();

  /// The current state of the notifier.
  T get state {
    RxListener._read(this);
    return _state;
  }

  /// Sets the new state for the notifier.
  ///
  /// The `state` argument represents the new state value for the notifier.
  /// If the new state is different from the current state, the notifier will
  /// update its state and notify its listeners.
  ///
  /// Example:
  ///
  /// ```dart
  /// void increment() {
  ///   state++; // Update the state
  /// }
  /// ```
  @protected
  @visibleForTesting
  set state(T state) {
    if ('$_state' == '$state') return;
    _state = state;
    _notifyListeners();
  }

  @override
  String toString() => '$runtimeType($state)';
}
