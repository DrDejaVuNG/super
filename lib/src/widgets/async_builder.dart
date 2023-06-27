import 'dart:async' show StreamSubscription;

import 'package:flutter/material.dart';
import 'package:flutter_super/src/core/typedefs.dart';

/// A stateful widget that builds itself based on the state of an
/// asynchronous computation.
///
/// Example usage:
///
/// ```dart
/// AsyncBuilder<int>(
///   future: Future.delayed(const Duration(seconds: 2), () => 10),
///   builder: (data) => Text('Data: $data'),
///   error: (error, stackTrace) => Text('Error: $error'),
///   loading: const CircularProgressIndicator.adaptive(),
/// ),
/// ```
class AsyncBuilder<T> extends StatefulWidget {
  /// Creates an AsyncBuilder widget.
  ///
  /// The [builder] parameter is a required callback function that
  /// returns the widget to be built.
  /// The [future] parameter represents an asynchronous computation
  /// that will trigger a rebuild when completed.
  /// The [stream] parameter represents an asynchronous data stream
  /// that will trigger a rebuild when new data is available.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// AsyncBuilder<int>(
  ///   future: Future.delayed(const Duration(seconds: 2), () => 10),
  ///   builder: (data) => Text('Data: $data'),
  ///   error: (error, stackTrace) => Text('Error: $error'),
  ///   loading: const CircularProgressIndicator.adaptive(),
  /// ),
  /// ```
  const AsyncBuilder({
    required this.builder,
    super.key,
    this.future,
    this.stream,
    this.loading,
    this.error,
  }) : assert(
          future == null || stream == null,
          'Use either a stream or a future not both at the same time',
        );

  /// The asynchronous computation to which this builder is currently connected.
  final Future<T>? future;

  /// The asynchronous data stream to which this builder is currently
  /// connected.
  final Stream<T>? stream;

  /// The build strategy currently used by this builder.
  /// The [builder] is provided with an [AsyncSnapshot] object that
  /// reflects the connection state and data of the asynchronous computation.
  final AsyncDataBuilder<T> builder;

  /// A widget to display while the asynchronous computation is in
  /// progress.
  final Widget? loading;

  /// A widget builder that constructs an error widget when an error
  /// occurs in the asynchronous computation.
  final AsyncErrorBuilder? error;

  /// Whether the latest error received by the asynchronous computation
  /// should be rethrown or swallowed.
  /// This property is useful for debugging purposes.
  static bool debugRethrowError = false;

  /// Returns the initial snapshot based on the initial data.
  AsyncSnapshot<T> initial() => AsyncSnapshot<T>.nothing();

  /// Returns the snapshot after the connection to the asynchronous
  /// computation is established.
  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  /// Returns the snapshot after new data is received from the
  /// asynchronous computation.
  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  /// Returns the snapshot after an error occurs in the asynchronous
  /// computation.
  AsyncSnapshot<T> afterError(
    AsyncSnapshot<T> current,
    Object error,
    StackTrace stackTrace,
  ) {
    return AsyncSnapshot<T>.withError(
      ConnectionState.active,
      error,
      stackTrace,
    );
  }

  // coverage:ignore-start
  /// Returns the snapshot after the asynchronous computation is completed.
  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  /// Returns the snapshot after the connection to the asynchronous
  /// computation is disconnected.
  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);
  // coverage:ignore-end

  @override
  State<AsyncBuilder<T>> createState() => _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<AsyncBuilder<T>> {
  /// An object that identifies the currently active callbacks. Used to avoid
  /// calling setState from stale callbacks, e.g. after disposal of this state,
  /// or after widget reconfiguration to a new Future.
  Object? _activeCallbackIdentity;
  StreamSubscription<T>? _subscription;
  late AsyncSnapshot<T> _snapshot;

  @override
  Widget build(BuildContext context) {
    if (_snapshot.connectionState == ConnectionState.waiting) {
      return widget.loading != null
          ? widget.loading!
          : const CircularProgressIndicator.adaptive();
    }
    if (_snapshot.hasError) {
      return widget.error != null
          ? widget.error!(_snapshot.error!, _snapshot.stackTrace!)
          : Text(_snapshot.error!.toString());
    }
    return widget.builder(_snapshot.data);
  }

  // coverage:ignore-start
  @override
  void initState() {
    super.initState();
    _snapshot = widget.initial();
    _subscribe();
  }

  @override
  void didUpdateWidget(AsyncBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.future != null) {
      if (oldWidget.future != widget.future) {
        if (_activeCallbackIdentity != null) {
          _unsubscribe();
          _snapshot = widget.afterDisconnected(_snapshot);
        }
        _subscribe();
      }
    } else if (widget.stream != null) {
      if (oldWidget.stream != widget.stream) {
        if (_subscription != null) {
          _unsubscribe();
          _snapshot = widget.afterDisconnected(_snapshot);
        }
        _subscribe();
      }
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.future != null) {
      final callbackIdentity = Object();
      _activeCallbackIdentity = callbackIdentity;
      widget.future!.then<void>(
        (T data) {
          if (_activeCallbackIdentity == callbackIdentity) {
            setState(() {
              _snapshot = widget.afterData(_snapshot, data);
            });
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (_activeCallbackIdentity == callbackIdentity) {
            setState(() {
              _snapshot = widget.afterError(_snapshot, error, stackTrace);
            });
          }
          assert(
            () {
              if (AsyncBuilder.debugRethrowError) {
                Future<Object>.error(error, stackTrace);
              }
              return true;
            }(),
            '',
          );
        },
      );
      if (_snapshot.connectionState != ConnectionState.done) {
        _snapshot = widget.afterConnected(_snapshot);
      }
    } else if (widget.stream != null) {
      _subscription = widget.stream!.listen(
        (T data) {
          setState(() {
            _snapshot = widget.afterData(_snapshot, data);
          });
        },
        onError: (Object error, StackTrace stackTrace) {
          setState(() {
            _snapshot = widget.afterError(_snapshot, error, stackTrace);
          });
        },
        onDone: () {
          setState(() {
            _snapshot = widget.afterDone(_snapshot);
          });
        },
      );
      _snapshot = widget.afterConnected(_snapshot);
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }
  }
  // coverage:ignore-end
}
