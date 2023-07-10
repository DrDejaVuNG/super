import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/// Extensions on BuildContext
extension ContextExt on BuildContext {
  /* ========================= Instance ========================= */

  /// Works exactly like `Super.of<T>()` but with context and
  /// is familiar
  T read<T>() => Super.of<T>();

  /// This returns the state of an Rx object i.e RxT or
  /// RxNotifier, and rebuilds the widget when the state changes.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// class HomeView extends StatelessWidget {
  ///   const HomeView({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final count = 0.rx; // Quick example
  ///     final state = context.watch(count);
  ///     return Scaffold(
  ///       body: Center(
  ///         child: Text(
  ///           '$state',
  ///            style: const TextStyle(fontSize: 25),
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  ///
  /// This can be used instead of the SuperBuilder/SuperConsumer widgets.
  /// It is worth noting however that, unlike those APIs which rebuild only
  /// the widget in their builder methods, this will rebuild the entire widget.
  T watch<T>(Rx<T> rx) {
    final element = this as Element;
    void rebuild() {
      if (element.mounted) {
        element.markNeedsBuild();
      } else {
        rx.removeListener(rebuild);
      }
    }

    rx
      ..removeListener(rebuild)
      ..addListener(rebuild);
    if (rx is RxT<T>) return rx.value;
    rx as RxNotifier<T>;
    return rx.state;
  }
}
