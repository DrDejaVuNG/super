import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/core/typedefs.dart';

/// A stateful widget that rebuilds its child widget when the [Rx]
/// object changes.
///
/// The [SuperBuilder] widget allows you to rebuild a part of your
/// UI in response
/// to changes in an [Rx] object. It takes a [builder] callback function
/// that receives a [BuildContext] and returns the widget to be built.
///
/// The [builder] callback will be invoked whenever the [Rx] object
/// changes its state, triggering a rebuild of the widget. The [Rx]
/// object can be accessed within the [builder] callback, allowing
/// you to incorporate its state into your UI.
///
/// The [buildWhen] parameter is an optional condition that determines
/// whether the [builder] should be called when the [Rx] object changes.
/// If [buildWhen] evaluates to `false`, the [builder] will not be called,
/// and the child widget will not be rebuilt.
///
/// Example usage:
///
/// ```dart
/// class CounterWidget extends SuperWidget {
///   const CounterWidget({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     final counter = 0.rx; // RxT<int>(0);
///     return SuperBuilder(
///       builder: (context) => Text(
///         "${counter.state}",
///         style: const TextStyle(fontSize: 25),
///       ),
///     ),
///   }
/// }
/// ```
///
/// **Note:** Unless you specify an Id, you need to make use of an [Rx] object
/// state in the builder method, otherwise, it will result in an error.
class SuperBuilder extends StatefulWidget {
  /// Creates a SuperBuilder widget.
  ///
  /// The [builder] parameter is a callback function that takes a [BuildContext]
  /// and returns the widget to be built.
  ///
  /// The [buildWhen] parameter is an optional condition that determines
  /// whether the [builder] should be called when the [Rx] object changes.
  /// If [buildWhen] evaluates to `false`, the [builder] will not be called,
  /// and the child widget will not be rebuilt.
  const SuperBuilder({
    required this.builder,
    this.buildWhen,
    super.key,
  });

  /// Called every time the [Rx] object changes state.
  final RxBuilder builder;

  /// An optional condition that determines whether the [builder] should
  /// be called when the [Rx] object changes. If [buildWhen] evaluates to
  /// `false`, the [builder] will not be called, and the child widget will
  /// not be rebuilt.
  final bool Function()? buildWhen;

  @override
  State<SuperBuilder> createState() => _SuperBuilderState();
}

class _SuperBuilderState extends State<SuperBuilder> {
  RxMerge<dynamic>? _rx;

  @override
  void dispose() {
    // Remove the listener from the rx
    _rx?.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    if (widget.buildWhen != null && !widget.buildWhen!()) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _rx?.removeListener(_handleChange);

    RxListener.listen();
    final child = widget.builder(context);

    _rx = RxListener.listenedRx();
    _rx?.addListener(_handleChange);
    return child;
  }
}
