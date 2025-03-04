// ignore_for_file: no_runtimetype_tostring

import 'package:dart_super/dart_super.dart' as dart;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/* =========================== SuperViewModel =========================== */

/// A mixin class that provides a lifecycle for view models used in
/// the application.
///
/// The `SuperViewModel` mixin class allows you to define the lifecycle
/// of your view model classes.
/// It provides methods that are called at specific points in the widget
/// lifecycle,
/// allowing you to initialize resources, handle events, and clean up
/// resources when the view model is no longer needed.
///
/// Example usage:
///
/// ```dart
/// class CounterViewModel extends SuperViewModel {
///   final _count = 0.rx; // RxInt(0);
///
///   int get count => _count.state;
///
///   void increment() => _count.state++;
///
///   @override
///   void onDisable() {
///     _count.dispose(); // Dispose Rx object.
///     super.onDisable();
///   }
/// }
/// ```
///
/// In the example above, `CounterViewModel` extends `SuperViewModel`
/// and defines a `count` variable
/// that is managed by an `Rx` object. The `increment()` method is used
/// to increment the count state.
/// The `onDisable()` method is overridden to dispose of the `Rx` object
/// when the view model is disabled.
///
/// **Note:** It is recommended to define Rx objects as private and only
/// provide a getter for accessing the state.
/// This helps prevent the state from being changed outside of the
/// view model, ensuring that the state is only modified through defined
/// methods within the view model (e.g., `increment()` in the example).
mixin class SuperViewModel implements dart.SuperController {
  /// SuperViewModel Constructor
  SuperViewModel();

  bool _alive = false;
  BuildContext? _context;

  /// The [BuildContext] associated with the view model.
  ///
  /// It represents the context of the first widget that uses the view model
  /// or the immediate widget that initializes the view model after the
  /// original widget is removed from the widget tree when autoDispose
  /// is set to false.
  /// This context is set when the `initContext()` method is called.
  ///
  /// Note: Avoid using the `BuildContext` in the `onEnable()` method
  /// to prevent potential issues.
  @protected
  @visibleForTesting
  BuildContext get ctrlContext {
    if (_context != null) return _context!;
    throw FlutterError(
      'Error: You must neither '
      'make use of BuildContext in the onEnable() method, '
      'nor access this $runtimeType BuildContext without first '
      'connecting the view model to a SuperWidget.',
    );
  }

  /// Checks whether the view model is alive.
  @override
  bool get alive => _alive;

  /// This method is called at the exact moment the widget is allocated
  /// in memory.
  /// It defines the lifecycle of the subclass and should not be overridden.
  ///
  /// It internally calls the [onEnable] method to initialize the view model.
  /// Once the initialization is done, it sets the [alive] flag to true.
  /// This method ensures that [onEnable] is called only once for the
  /// view model.
  @override
  @mustCallSuper
  @nonVirtual
  void enable() {
    if (_alive) return;
    onEnable();
    _alive = true;
  }

  /// Initializes the [BuildContext] associated with the view model.
  @nonVirtual
  void initContext(BuildContext? context) {
    if (_context != null) return;
    _context = context;
  }

  /// This method is called when the view model is removed from memory.
  /// It marks the view model as disabled and calls the [onDisable] method.
  ///
  /// This method should not be overridden.
  @override
  @mustCallSuper
  @nonVirtual
  void disable() {
    if (!_alive) return;
    _alive = false;
    onDisable();
  }

  /// This method is called when the view model is accessed for the first time,
  /// which typically happens when the view model is allocated in memory.
  ///
  /// You can perform initialization tasks for the view model in this method.
  /// For example, initializing view models, setting up listeners,
  /// making asynchronous requests, etc.
  ///
  /// It is recommended to call `super.onEnable()` at the beginning
  /// of the overridden method to ensure that the base class's
  /// initialization is executed.
  ///
  /// After this method is called, the [onAlive] method will be invoked
  /// in the next frame.
  @override
  @protected
  @mustCallSuper
  @visibleForTesting
  void onEnable() {
    Super.log('$runtimeType was enabled.');
    WidgetsBinding.instance.addPostFrameCallback((_) => onAlive());
  }

  /// Called immediately after the [Widget]'s build method is invoked.
  /// It is [BuildContext] safe and is good place to access route
  /// arguments or compute other operations on which the Widget depends on.
  ///
  /// **Important:** This method is called everytime the [Widget]'s build
  /// method is invoked.
  @protected
  @visibleForTesting
  void onBuild() {}

  /// Called one frame after the [onEnable] method. It is [BuildContext]
  /// safe and is the perfect place to handle
  /// route events, such as showing snackbars, dialogs or perform async
  /// operations, or any other actions that should be executed after
  /// the widget is built.
  ///
  /// Override this method to implement the specific behavior for the
  /// view model.
  @override
  @protected
  @visibleForTesting
  void onAlive() {}

  /// This method can be used to dispose of resources used by the view model.
  ///
  /// Override this method to perform any cleanup tasks before the
  /// view model is terminated.
  /// For example, closing events, streams, disposing Rx objects
  /// or controllers that can potentially create memory leaks,
  /// such as TextEditingControllers or AnimationControllers.
  ///
  /// It is recommended to call `super.onDisable()` at the end of
  /// the overridden method to ensure that the base class's cleanup
  /// tasks are executed.
  ///
  /// This method might also be useful for persisting data on disk
  /// before the view model is disabled.
  @override
  @protected
  @mustCallSuper
  @visibleForTesting
  void onDisable() {
    _context = null;
    Super.log('$runtimeType was disabled.');
  }
}

/// Deprecated to align with Flutter's MVVM architecture,
/// Use SuperViewModel instead.
@Deprecated('Use SuperViewModel instead')
class SuperController extends SuperViewModel {}
