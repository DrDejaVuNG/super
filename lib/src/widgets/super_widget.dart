import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super/src/controller.dart';
import 'package:flutter_super/src/core/interface.dart';
import 'package:flutter_super/src/utilities/super.dart';

/// A [StatelessWidget] that provides the base functionality for
/// widgets that work with a [SuperController].
///
/// This widget serves as a foundation for building widgets that
/// require a controller to manage their state and lifecycle.
/// By extending [SuperWidget] and providing a concrete implementation
/// of [initController()], you can easily associate a controller
/// with the widget.
///
/// **Note:** It is recommended to use one controller per widget to
/// ensure proper encapsulation and separation of concerns.
/// Each widget should have its own dedicated controller for
/// managing its state and lifecycle. This approach promotes
/// clean and modular code by keeping the responsibilities of
/// each widget and its associated controller separate.
///
/// If you have a widget that doesn't require state management
/// or interaction with a controller, it is best to use a vanilla
/// [StatelessWidget] instead. Using a controller in a widget that
/// doesn't have any state could add unnecessary complexity and overhead.
abstract class SuperWidget<T extends SuperController> extends Widget {
  /// The key for the widget.
  const SuperWidget({super.key});

  /// Initializes the controller for the widget.
  ///
  /// This method is responsible for creating and initializing the
  /// controller instance associated with the widget. Subclasses must
  /// override this method and provide a concrete implementation by
  /// returning an instance of the desired controller class.
  ///
  /// Example:
  ///
  /// ```dart
  /// class MyWidget extends SuperWidget<MyController> {
  ///   @override
  ///   MyController initController() => MyController();
  ///
  ///   // Widget implementation...
  /// }
  /// ```
  T initController();

  @override
  // ignore: library_private_types_in_public_api
  _SuperElement<T> createElement() => _SuperElement<T>(this, controller);

  /// The widget controller reference.
  ///
  /// This getter provides access to the associated controller
  /// for the widget. The controller is initialized and managed
  /// automatically by the [Super] framework.
  @nonVirtual
  T get controller => Super.init<T>(initController());

  /// Builds the widget based on the given [BuildContext].
  ///
  /// This method is responsible for defining the widget's UI
  /// based on the provided [BuildContext]. Subclasses must override
  /// this method and provide the specific widget implementation.
  @protected
  Widget build(BuildContext context);
}

/// An element that represents a [SuperWidget] and associates it with
/// a [SuperController].
class _SuperElement<T extends SuperController> extends _ControllerElement<T> {
  /// Creates an element that uses the given widget as its configuration
  /// and associates it with a controller.
  _SuperElement(SuperWidget super.widget, super.controller);

  @override
  Widget build() => (widget as SuperWidget).build(this);

  // coverage:ignore-start
  @override
  void update(SuperWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget, 'Error updating widget');
    rebuild(force: true);
  }
  // coverage:ignore-end
}

/// An abstract class that represents an element with a [SuperController].
abstract class _ControllerElement<T extends SuperController>
    extends ComponentElement {
  /// Creates an element that uses the given widget as its configuration
  /// and associates it with a controller.
  _ControllerElement(super.widget, this.controller);

  /// The controller for the widget.
  @protected
  final T controller;

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    // Store the created element to be used by the controller
    controller.initContext(this);
  }

  @override
  void unmount() {
    controller.disable();
    super.unmount();
  }
}
