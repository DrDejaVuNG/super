import 'package:flutter/material.dart';
import 'package:flutter_super/src/core/typedefs.dart';
import 'package:flutter_super/src/rx/rx.dart';

/// A widget that calls the listener callback when the given rx object changes.
///
/// The [SuperListener] widget listens to changes in the provided rx object
/// and calls the [listener] callback when the rx object changes its value.
///
/// The [listener] callback is called once when the rx object changes
/// its value.
///
/// The [child] parameter is an optional child widget to be rendered by
/// this widget.
///
/// The [listenWhen] parameter is an optional condition that determines whether
/// the [listener] should be called when the rx object changes. If
/// [listenWhen] evaluates to `true`, the [listener]
/// will be called; otherwise, it will be skipped.
///
/// Example usage:
/// ```dart
/// SuperListener<int>(
///   listen: () => controller.count;
///   listenWhen: (count) => count > 5,
///   listener: (context) {
///     // Handle the state change here
///   }, // Only call the listener if count is greater than 5
///   child: Text('Counter'),
/// )
/// ```
///
/// **Note:** You need to make use of an [Rx] object value in the
/// listen parameter, otherwise, it will result in an error.
class SuperListener<T> extends StatefulWidget {
  /// Creates a widget that rebuilds when the given rx object changes.
  ///
  /// The [listener] callback is called once when the rx object changes
  /// its value.
  ///
  /// The [child] parameter is an optional child widget to be rendered by
  /// this widget.
  ///
  /// The [listenWhen] parameter is an optional condition that determines
  /// whether the [listener] should be called when the rx object changes.
  /// If [listenWhen] evaluates to `true`, the [listener] will be called;
  /// otherwise, it will be skipped.
  const SuperListener({
    required this.listener,
    required this.listen,
    super.key,
    this.child,
    this.listenWhen,
  });

  /// An optional child widget to be rendered by this widget.
  final Widget? child;

  /// Called once when the rx changes value.
  final RxCallback listener;

  /// The value of the [Rx] object to listen to.
  final T Function() listen;

  /// An optional condition that determines whether the [listener]
  /// should be called when the rx object changes. If [listenWhen]
  /// evaluates to `true`, the [listener] will be called; otherwise,
  /// it will be skipped. The [listenWhen] callback receives the previous
  /// and current values of the rx object as arguments.
  final bool Function(T state)? listenWhen;

  @override
  State<SuperListener<T>> createState() => _SuperListenerState<T>();
}

class _SuperListenerState<T> extends State<SuperListener<T>> {
  MergeRx? _rx;
  late T _listen;
  late BuildContext _context;

  @override
  void dispose() {
    _rx?.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    _listen = widget.listen();
    if (widget.listenWhen != null && !widget.listenWhen!(_listen)) return;
    widget.listener(_context);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _rx?.removeListener(_handleChange);

    RxListener.listen();
    _listen = widget.listen();

    _rx = RxListener.listenedRx();
    _rx?.addListener(_handleChange);
    if (widget.child != null) {
      return widget.child!;
    } else {
      return const SizedBox.shrink();
    }
  }
}
