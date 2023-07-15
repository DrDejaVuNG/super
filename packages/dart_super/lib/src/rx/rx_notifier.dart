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
abstract class RxNotifier<T> extends Rx<T> {
  /// {@macro rx_notifier}
  RxNotifier() {
    _state = watch();
  }

  late T _state;
  bool _loading = false;

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

  /// The loading state of the notifier.
  ///
  /// This is useful when working with asynchronous state.
  /// By default it is set to false so that none asynchronous state
  /// can be utilized.
  ///
  /// Example:
  ///
  /// ```dart
  /// class BooksNotifier extends RxNotifier<List<Book>> {
  ///   @override
  ///   List<Book> watch() {
  ///     return []; // Initial state
  ///   }
  ///
  ///   void getBooks() async {
  ///     toggleLoading();
  ///     state = await booksRepo.getBooks(); // Update the state
  ///   }
  /// }
  /// ```
  bool get loading => _loading;

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
    if (loading == true) toggleLoading();
    _state = state;
    _notifyListeners();
  }

  /// Toggles the loading state of the notifier. By default the
  /// loading state is false.
  ///
  /// Example:
  ///
  /// ```dart
  /// void getList() async {
  ///   toggleLoading(); // set loading to true
  ///
  ///   state = await dataRepo.getData; // Update the state
  /// }
  /// ```
  /// **Note**: There is no need to call it a second time, when the state
  /// is updated the loading state will be set to false.
  @protected
  @visibleForTesting
  void toggleLoading() => _loading = !_loading;

  @override
  String toString() => '$runtimeType($state)';
}
