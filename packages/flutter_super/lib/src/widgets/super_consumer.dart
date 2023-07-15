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
/// CounterNotifier get counterNotifier = Super.init(CounterNotifier());
///
/// // ...
///
/// SuperConsumer<int>(
///   rx: counterNotifier,
///   builder: (context, state) {
///     return Text('Count: $state');
///   },
/// )
/// ```
/// In the above example, a [SuperConsumer] widget is created and given
/// a [RxNotifier<int>] object called counterNotifier. Whenever the state
/// of the counterNotifier changes, the  builder function is called with
/// the latest state, and it returns a [Text] widget displaying the count.
///
/// ### Asynchronous State
///
/// The [SuperConsumer] widget can also be used for
/// asynchronous state.
///
/// The optional [loading] parameter can be used to specify a widget
/// to be displayed while an RxNotifier is in loading state.
///
/// Example usage:
/// ```dart
/// CounterNotifier get counterNotifier = Super.init(CounterNotifier());
///
/// class CounterNotifier extends RxNotifier<int> {
///   @override
///   int watch() {
///     return 0; // Initial state
///   }
///
///   Future<void> getData() async {
///     toggleLoading(); // set loading to true
///     state = await Future.delayed(const Duration(seconds: 3), () => 5);
///   }
/// }
///
/// SuperConsumer<int>(
///   rx: counterNotifier,
///   loading: const CircularProgressIndicator();
///   builder: (context, state) {
///     return Text('Count: $state');
///   },
/// )
/// ```
/// As seen above, a [SuperConsumer] widget is created and given
/// a [RxNotifier] object called counterNotifier. When the widget is built,
/// if the RxNotifier is in loading state, the loading widget will be
/// displayed. When the asynchronous method completes and the state is
/// updated, the builder function is called with the state.
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
    this.loading,
    super.key,
  });

  /// The [Rx] object to be consumed and listened to for changes.
  final Rx<T> rx;

  /// A widget to be displayed while an RxNotifier is in
  /// loading state.
  final Widget? loading;

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
  bool _loading = false;

  @override
  void didUpdateWidget(SuperConsumer<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the rx has changed and update the listener accordingly.
    if (widget.rx != oldWidget.rx) {
      oldWidget.rx.removeListener(_handleChange);
    }
  }

  void _initValue() {
    final rx = widget.rx;
    if (rx is RxT<T>) {
      _state = rx.state;
    }
    if (rx is RxNotifier<T>) {
      _state = rx.state;
      _loading = rx.loading;
    }
    widget.rx.addListener(_handleChange);
  }

  @override
  void dispose() {
    widget.rx.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _initValue();
    if (_loading) {
      return widget.loading ?? const CircularProgressIndicator.adaptive();
    }
    return widget.builder(context, _state);
  }
}
