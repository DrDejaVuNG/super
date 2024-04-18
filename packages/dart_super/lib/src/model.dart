import 'package:meta/meta.dart';

/// A class that provides value equality checking for classes.
///
/// Classes that extend this class should implement the `props` getter, which
/// returns a list of the class properties that should be used for equality
/// checking.
///
/// Example usage:
/// ```dart
/// class UserModel with SuperModel {
///   final int id;
///   final String name;
///
///   UserModel(this.id, this.name);
///
///   @override
///   List<Object> get props => [id, name];
/// }
/// ```
mixin SuperModel {
  /// Contains the class properties.
  ///
  /// Subclasses must override this getter and provide a list of properties
  /// that should be used for equality checking.
  List<Object?> get props;

  @override
  @nonVirtual
  bool operator ==(Object other) {
    return toString() == other.toString();
  }

  @override
  @nonVirtual
  String toString() => '$runtimeType($props)';
}
