import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';

part 'rx_list.dart';
part 'rx_map.dart';
part 'rx_notifier.dart';
part 'rx_set.dart';
part 'rx_t.dart';

/// An abstract base class for implementing reactive objects.
///
/// The `Rx` class provides the foundation for creating reactive
/// objects in the Super framework.
/// It manages a list of listeners and notifies them when the object
/// undergoes changes.
/// Subclasses of `Rx` can override the `dispose` method to release
/// any resources or perform cleanup when the reactive object is no
/// longer needed.
///
/// **Note:** This is essentially a [ChangeNotifier] with some adjustments.
///
/// **Not Intended For Use Outside The Super Library.**
///
/// **Unauthorised Usage Could Create Interference With Other APIs
/// In The Library**
// coverage:ignore-start
abstract class Rx {
  int _count = 0;
  static final List<VoidCallback?> _emptyListeners =
      List<VoidCallback?>.filled(0, null);
  List<VoidCallback?> _listeners = _emptyListeners;
  int _notificationCallStackDepth = 0;
  int _reentrantlyRemovedListeners = 0;
  bool _debugDisposed = false;

  bool _creationDispatched = false;

  /// Used by subclasses to assert that the [Rx] has not yet been
  /// disposed.
  static bool debugAssertNotDisposed(Rx rx) {
    assert(
      () {
        if (rx._debugDisposed) {
          throw StateError(
            'A ${rx.runtimeType} was used after being disposed.\n'
            'Once you have called dispose() on a ${rx.runtimeType}, it '
            'can no longer be used.',
          );
        }
        return true;
      }(),
      '',
    );
    return true;
  }

  /// Verify whether [dispose] was called or not.
  bool get mounted => !_debugDisposed;

  /// Checks if the reactive object has registered listeners.
  @protected
  bool get hasListeners => _count > 0;

  /// Adds a listener to the reactive object.
  ///
  /// The `listener` argument is a callback function that will be invoked
  /// whenever the reactive object undergoes changes.
  void addListener(VoidCallback listener) {
    assert(Rx.debugAssertNotDisposed(this), '');
    if (kFlutterMemoryAllocationsEnabled && !_creationDispatched) {
      MemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/foundation.dart',
        className: '$Rx',
        object: this,
      );
      _creationDispatched = true;
    }
    if (_count == _listeners.length) {
      if (_count == 0) {
        _listeners = List<VoidCallback?>.filled(1, null);
      } else {
        final newListeners =
            List<VoidCallback?>.filled(_listeners.length * 2, null);
        for (var i = 0; i < _count; i++) {
          newListeners[i] = _listeners[i];
        }
        _listeners = newListeners;
      }
    }
    _listeners[_count++] = listener;
  }

  void _removeAt(int index) {
    _count -= 1;
    if (_count * 2 <= _listeners.length) {
      final newListeners = List<VoidCallback?>.filled(_count, null);

      // Listeners before the index are at the same place.
      for (var i = 0; i < index; i++) {
        newListeners[i] = _listeners[i];
      }

      // Listeners after the index move towards the start of the list.
      for (var i = index; i < _count; i++) {
        newListeners[i] = _listeners[i + 1];
      }

      _listeners = newListeners;
    } else {
      // When there are more listeners than half the length of the list, we only
      // shift our listeners, so that we avoid to reallocate memory for the
      // whole list.
      for (var i = index; i < _count; i++) {
        _listeners[i] = _listeners[i + 1];
      }
      _listeners[_count] = null;
    }
  }

  /// Removes a listener from the reactive object.
  ///
  /// The `listener` argument is the callback function that was previously added
  /// as a listener and should be removed.
  void removeListener(VoidCallback listener) {
    // This method is allowed to be called on disposed instances for usability
    // reasons. Due to how our frame scheduling logic between render objects and
    // overlays, it is common that the owner of this instance would be disposed
    // a frame earlier than the listeners. Allowing calls to this method after
    // it is disposed makes it easier for listeners to properly clean up.
    for (var i = 0; i < _count; i++) {
      final listenerAtIndex = _listeners[i];
      if (listenerAtIndex == listener) {
        if (_notificationCallStackDepth > 0) {
          // We don't resize the list during notify iterations
          // but we set to null, the listeners we want to remove. We will
          // effectively resize the list at the end of all notify
          // iterations.
          _listeners[i] = null;
          _reentrantlyRemovedListeners++;
        } else {
          // When we are outside the notify iterations we can
          // effectively shrink the list.
          _removeAt(i);
        }
        break;
      }
    }
  }

  /// Disposes the reactive object and releases associated resources.
  ///
  /// Subclasses can override this method to perform cleanup when the reactive
  /// object is no longer needed. After calling this method, the reactive object
  /// should not be used.
  @mustCallSuper
  void dispose() {
    if (_debugDisposed) return;
    assert(
      _notificationCallStackDepth == 0,
      'The "dispose()" method on $this was called during the call to '
      '"notify()". This is likely to cause errors since it modifies '
      'the list of listeners while the list is being used.',
    );
    assert(
      () {
        _debugDisposed = true;
        return true;
      }(),
      '',
    );
    if (kFlutterMemoryAllocationsEnabled && _creationDispatched) {
      MemoryAllocations.instance.dispatchObjectDisposed(object: this);
    }
    _listeners = _emptyListeners;
    _count = 0;
  }

  @protected
  @pragma('vm:notify-debugger-on-exception')
  void _notifyListeners() {
    assert(Rx.debugAssertNotDisposed(this), '');
    if (_count == 0) {
      return;
    }
    _notificationCallStackDepth++;

    final end = _count;
    for (var i = 0; i < end; i++) {
      try {
        _listeners[i]?.call();
      } catch (exception, stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: exception,
            stack: stack,
            library: 'foundation library',
            context: ErrorDescription(
              'while dispatching notifications for $runtimeType',
            ),
            informationCollector: () => <DiagnosticsNode>[
              DiagnosticsProperty<Rx>(
                'The $runtimeType sending notification was',
                this,
                style: DiagnosticsTreeStyle.errorProperty,
              ),
            ],
          ),
        );
      }
    }

    _notificationCallStackDepth--;

    if (_notificationCallStackDepth == 0 && _reentrantlyRemovedListeners > 0) {
      // We really remove the listeners when all notifications are done.
      final newLength = _count - _reentrantlyRemovedListeners;
      if (newLength * 2 <= _listeners.length) {
        // As in _removeAt, we only shrink the list when the real number of
        // listeners is half the length of our list.
        final newListeners = List<VoidCallback?>.filled(newLength, null);

        var newIndex = 0;
        for (var i = 0; i < _count; i++) {
          final listener = _listeners[i];
          if (listener != null) {
            newListeners[newIndex++] = listener;
          }
        }

        _listeners = newListeners;
      } else {
        // Otherwise we put all the null references at the end.
        for (var i = 0; i < newLength; i += 1) {
          if (_listeners[i] == null) {
            // We swap this item with the next not null item.
            var swapIndex = i + 1;
            while (_listeners[swapIndex] == null) {
              swapIndex += 1;
            }
            _listeners[i] = _listeners[swapIndex];
            _listeners[swapIndex] = null;
          }
        }
      }

      _reentrantlyRemovedListeners = 0;
      _count = newLength;
    }
  }
}
// coverage:ignore-end

/// MergeRx
///
/// **Not Intended For Use Outside The Super Library.**
///
/// **Unauthorised Usage Could Create Interference With Other APIs
/// In The Library**
final class MergeRx extends Rx {
  /// Creates a MergeRx instance with the specified list of [Rx] objects.
  ///
  /// The children parameter is a list of [Rx] objects that will be
  /// merged together to act as a single [Rx].
  MergeRx(this.children);

  /// The children parameter is a list of [Rx] objects that will be
  /// merged together to act as a single [Rx].
  final List<Rx?> children;

  /// Adds the specified [listener] to all the merged [Rx] objects.
  ///
  /// The [listener] will be called whenever any of the merged
  /// [Rx] objects notify
  /// about a change.
  @override
  void addListener(VoidCallback listener) {
    for (final child in children) {
      child?.addListener(listener);
    }
  }

  /// Removes the specified [listener] from all the merged [Rx] objects.
  ///
  /// The [listener] will no longer be called when any of the merged
  /// [Rx] objects
  /// notify about a change.
  @override
  void removeListener(VoidCallback listener) {
    for (final child in children) {
      child?.removeListener(listener);
    }
  }

  @override
  String toString() {
    return 'MergeRx([${children.join(", ")}])';
  }
}

/// RxListener
///
/// **Not Intended For Use Outside The Super Library.**
///
/// **Unauthorised Usage Could Create Interference With Other APIs
/// In The Library**
final class RxListener {
  /// Indicates whether the listener is currently active.
  static bool isListening = false;

  /// List of registered [Rx] objects.
  static final List<Rx> _rxList = [];

  /// Starts listening for changes in [Rx] objects.
  ///
  /// This method is called to activate the listener and start capturing
  /// changes in [Rx] objects.
  static void listen() {
    isListening = true;
  }

  /// Retrieves the list of captured [Rx] objects.
  ///
  /// Returns a list of [Rx] objects that have been captured while
  /// the listener was active.
  /// If no [Rx] objects have been captured, a [FlutterError] is thrown.
  static List<Rx> getRxList() {
    isListening = false;
    final newRxList = List.of(_rxList);
    _rxList.clear();
    if (newRxList.isNotEmpty) {
      return newRxList;
    }
    throw FlutterError(
      "Couldn't find any Rx object, you need to use "
      'the value of an Rx object in the SuperBuilder or SuperListener '
      'i.e RxT or RxNotifier.',
    );
  }

  /// Creates a [MergeRx] instance with the captured [Rx] objects.
  ///
  /// Returns a [MergeRx] instance that merges all the captured
  /// [Rx] objects into a single [Rx].
  static MergeRx listenedRx() {
    final rx = MergeRx(getRxList());
    return rx;
  }

  /// Captures an [Rx] object for listening.
  ///
  /// If the listener is active, the [rx] object will be added to
  /// the list of captured [Rx] objects.
  static void _read(Rx rx) {
    if (!isListening) return;
    _rxList.add(rx);
  }
}
