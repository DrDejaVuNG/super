import 'package:flutter_super/src/rx/rx.dart';

/// {@macro rx_t}
extension RxTExt<T> on T {
  /// Returns an `RxT` instance with this `T` as it's initial value.
  RxT<T> get rx => RxT<T>(this);
}

/// {@macro rx_t}
extension RxStringExt on String {
  /// Returns an `RxString` with this `String` as it's initial value.
  RxString get rx => RxString(this);
}

/// {@macro rx_t}
extension RxIntExt on int {
  /// Returns an `RxInt` with this `int` as it's initial value.
  RxInt get rx => RxInt(this);
}

/// {@macro rx_t}
extension RxDoubleExt on double {
  /// Returns an `RxDouble>` with this `double` as it's initial value.
  RxDouble get rx => RxDouble(this);
}

/// {@macro rx_t}
extension RxBoolExt on bool {
  /// Returns an `RxBool` with this `bool` as it's initial value.
  RxBool get rx => RxBool(this);
}

/// {@macro rx_set}
extension RxSetExt<T> on Set<T> {
  /// Returns an `RxSet<T>` with this `Set`.
  RxSet<T> get rx => RxSet<T>(this);
}

/// {@macro rx_map}
extension RxMapExt<K, V> on Map<K, V> {
  /// Returns an `RxMap<K, V>` with this `Map`.
  RxMap<K, V> get rx => RxMap<K, V>(this);
}

/// {@macro rx_list}
extension RxListExt<T> on List<T> {
  /// Returns an `RxList<T>` with this `List`.
  RxList<T> get rx => RxList<T>(this);
}
