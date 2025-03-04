import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/// A [StatelessWidget] that provides the base functionality for
/// widgets that work with a [SuperViewModel].
///
/// This widget serves as a foundation for building widgets that
/// require a view model to manage their state and lifecycle.
/// By extending [SuperWidget] and providing a concrete implementation
/// of [initViewModel()], you can easily associate a view model
/// with the widget.
///
/// **Note:** It is recommended to use one view model per widget to
/// ensure proper encapsulation and separation of concerns.
/// Each widget should have its own dedicated view model for
/// managing its state and lifecycle. This approach promotes
/// clean and modular code by keeping the responsibilities of
/// each widget and its associated view model separate.
///
/// If you have a widget that doesn't require state management
/// or interaction with a view model, it is best to use a vanilla
/// [StatelessWidget] instead. Using a view model in a widget that
/// doesn't have any state could add unnecessary complexity and overhead.
abstract class SuperWidget<T extends SuperViewModel> extends Widget {
  /// The key for the widget.
  const SuperWidget({super.key});

  /// Initializes the view model for the widget.
  ///
  /// This method is responsible for creating and initializing the
  /// view model instance associated with the widget. Subclasses must
  /// override this method and provide a concrete implementation by
  /// returning an instance of the desired view model class.
  ///
  /// Example:
  ///
  /// ```dart
  /// class MyWidget extends SuperWidget<MyViewModel> {
  ///   @override
  ///   MyViewModel initViewModel() => MyViewModel();
  ///
  ///   // Widget implementation...
  /// }
  /// ```
  T initViewModel();

  @override
  // ignore: library_private_types_in_public_api
  _SuperElement<T> createElement() => _SuperElement<T>(this, ref);

  /// The widget view model reference.
  ///
  /// This getter provides access to the associated view model
  /// for the widget. The view model is initialized and managed
  /// automatically by the [Super] framework.
  @nonVirtual
  T get ref => Super.init<T>(initViewModel());

  /// Deprecated to align with Flutter's MVVM architecture,
  /// Use ref instead.
  @Deprecated('Use ref instead')
  T get controller => ref;

  /// Builds the widget based on the given [BuildContext].
  ///
  /// This method is responsible for defining the widget's UI
  /// based on the provided [BuildContext]. Subclasses must override
  /// this method and provide the specific widget implementation.
  @protected
  Widget build(BuildContext context);
}

/// An element that represents a [SuperWidget] and associates it with
/// a [SuperViewModel].
class _SuperElement<T extends SuperViewModel> extends ComponentElement {
  /// Creates an element that uses the given widget as its configuration
  /// and associates it with a view model.
  _SuperElement(SuperWidget super.widget, this.ref) {
    // Store the created element to be used by the view model
    ref.initContext(this);
  }

  /// The view model for the widget.
  @protected
  final T ref;

  @override
  Widget build() {
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    ref.onBuild();
    return (widget as SuperWidget).build(this);
  }

  // coverage:ignore-start
  @override
  void update(SuperWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget, 'Error updating widget');
    rebuild(force: true);
  }
  // coverage:ignore-end

  @override
  void unmount() {
    Super.delete<T>(force: false);
    super.unmount();
  }
}
