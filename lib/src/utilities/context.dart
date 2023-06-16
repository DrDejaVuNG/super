import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/// Extensions on BuildContext
extension ContextExt on BuildContext {
  /* ========================= Instance ========================= */

  /// Works exactly like `Super.of<T>()` but with context and
  /// is familiar
  T read<T>() => Super.of<T>();
}
