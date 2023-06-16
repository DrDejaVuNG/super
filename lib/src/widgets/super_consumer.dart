import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/// {@template super_consumer}
/// A widget that consumes a [Rx] object and rebuilds whenever it changes.
///
/// [SuperConsumer] is a StatefulWidget that listens to changes in a [Rx] object
/// and rebuilds its child widget whenever the [Rx] object's state changes.
///
/// The [SuperConsumer] widget takes a [builder] function, which is
/// called whenever the [Rx] object changes. The [builder] function receives
/// the current [BuildContext] and the latest state of the [Rx] object,
/// and returns the widget tree to be built.
///
/// Example usage:
/// ```dart
/// final counter = RxNotifier<int>(0);
///
/// // ...
///
/// SuperConsumer<int>(
///   rx: counter,
///   builder: (context, state) {
///     return Text('Count: $state');
///   },
/// )
/// ```
///
/// In the above example, a [SuperConsumer] widget is created and given
/// a [RxNotifier<int>] object called counter. Whenever the state of
/// counter changes, the  builder function is called with the latest state,
/// and it returns a [Text] widget displaying the count.
///
/// See also:
///
///   * [RxNotifier] class from the `flutter_super` package.
///   * [RxT] class from the `flutter_super` package.
///   * [SuperBuilder] widget, which rebuilds when the [Rx] object changes
/// without needing an rx parameter.
/// {@endtemplate}
class SuperConsumer<T> extends StatefulWidget {
  /// {@macro super_consumer}
  const SuperConsumer({
    required this.builder,
    required this.rx,
    super.key,
  });

  /// The [Rx] object to be consumed and listened to for changes.
  final Rx rx;

  /// The function that defines the widget tree to be built when the
  /// [Rx] object changes.
  ///
  /// The [builder] function is called with the current [BuildContext]
  /// and the latest value of the [Rx] object. It should return the
  /// widget tree to be built based on the current value.
  final Widget Function(BuildContext context, T state) builder;

  @override
  State<SuperConsumer<T>> createState() => _SuperConsumerState<T>();
}

class _SuperConsumerState<T> extends State<SuperConsumer<T>> {
  late T _state;

  @override
  void initState() {
    super.initState();
    _initValue();
    // Add the listener to the rx during initialization.
    widget.rx.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(SuperConsumer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the rx has changed and update the listener accordingly.
    if (widget.rx != oldWidget.rx) {
      oldWidget.rx.removeListener(_handleChange);
      widget.rx.addListener(_handleChange);
    }
  }

  void _initValue() {
    // Obtain the initial state from the rx.
    final rx = widget.rx;
    if (rx is RxT<T>) {
      _state = rx.value;
    }
    if (rx is RxNotifier<T>) {
      _state = rx.state;
    }
  }

  @override
  void dispose() {
    // Remove the listener from the rx when disposing the widget.
    widget.rx.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    // Trigger a rebuild of the widget whenever the rx changes value.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _initValue();
    return widget.builder(context, _state);
  }
}
