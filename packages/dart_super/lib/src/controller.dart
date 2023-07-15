// ignore_for_file: no_runtimetype_tostring
import 'package:dart_super/src/core/logger.dart';
import 'package:dart_super/src/injection.dart';
import 'package:meta/meta.dart';

/* =========================== SuperController =========================== */

/// A mixin class that provides a lifecycle for controllers used in
/// the application.
///
/// The `SuperController` mixin class allows you to define the lifecycle
/// of your controller classes.
/// It provides methods that are called at specific points allowing you
/// to initialize resources, handle events, and clean up resources when
/// the controller is no longer needed.
///
/// Example usage:
///
/// ```dart
/// class CounterController extends SuperController {
///   final _count = 0.rx; // RxInt(0);
///
///   int get count => _count.state;
///
///   void increment() {
///     _count.state++;
///   }
///
///   @override
///   void onDisable() {
///     _count.dispose(); // Dispose Rx object.
///     super.onDisable();
///   }
/// }
/// ```
///
/// In the example above, `CounterController` extends `SuperController`
/// and defines a `count` variable
/// that is managed by an `Rx` object. The `increment()` method is used
/// to increment the count state.
/// The `onDisable()` method is overridden to dispose of the `Rx` object
/// when the controller is disabled.
///
/// **Note:** It is recommended to define Rx objects as private and only
/// provide a getter for accessing the state.
/// This helps prevent the state from being changed outside of the
/// controller, ensuring that the state is only modified through defined
/// methods within the controller (e.g., `increment()` in the example).
mixin class SuperController {
  /// SuperController Constructor
  SuperController();

  bool _alive = false;

  /// Checks whether the controller is alive.
  bool get alive => _alive;

  /// This method is called first time the controller is accessed or utilized.
  /// It defines the lifecycle of the subclass and should not be overridden.
  ///
  /// It internally calls the [onEnable] method to initialize the controller.
  /// Once the initialization is done, it sets the [alive] flag to true.
  /// This method ensures that [onEnable] is called only once for the
  /// controller.
  @mustCallSuper
  @nonVirtual
  void enable() {
    if (_alive) return;
    onEnable();
    _alive = true;
  }

  /// This method is called when the controller is removed from memory.
  /// It marks the controller as disabled and calls the [onDisable] method.
  ///
  /// This method should not be overridden.
  @mustCallSuper
  @nonVirtual
  void disable() {
    if (!_alive) return;
    _alive = false;
    onDisable();
  }

  /// This method is called when the controller is accessed for the first time,
  /// which typically happens when the controller is allocated in memory.
  ///
  /// You can perform initialization tasks for the controller in this method.
  /// For example, initializing controllers, setting up listeners,
  /// making asynchronous requests, etc.
  ///
  /// It is recommended to call `super.onEnable()` at the beginning
  /// of the overridden method
  /// to ensure that the base class's initialization is executed.
  ///
  /// After this method is called, the [onAlive] method will be invoked
  /// in the next frame.
  @protected
  @mustCallSuper
  @visibleForTesting
  void onEnable() {
    logger('$runtimeType was enabled.');
    Future.delayed(const Duration(milliseconds: 15), onAlive);
  }

  /// Called one frame after the [onEnable] method.
  ///
  /// Override this method to implement the specific behavior for the
  /// controller.
  @protected
  @visibleForTesting
  void onAlive() {}

  /// This method can be used to dispose of resources used by the controller.
  ///
  /// Override this method to perform any cleanup tasks before the
  /// controller is terminated.
  /// For example, closing events, streams, disposing Rx objects
  /// or controllers that can potentially create memory leaks,
  /// such as TextEditingControllers or AnimationControllers.
  ///
  /// It is recommended to call `super.onDisable()` at the end of
  /// the overridden method
  /// to ensure that the base class's cleanup tasks are executed.
  ///
  /// This method might also be useful for persisting data on disk
  /// before the controller is disabled.
  @protected
  @mustCallSuper
  @visibleForTesting
  void onDisable() {
    logger('$runtimeType was disabled.');
    Injection.delete<void>(key: '$runtimeType');
  }
}
