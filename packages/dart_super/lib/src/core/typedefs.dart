/// A function type used to define methods which do not return a value.
typedef VoidCallback = void Function();

/// A function type used for overriding instances during testing
/// or dependency injection.
///
/// The [Override] typedef represents a function that takes a [Type]
/// and an instance of a generic type [S] as parameters. It is
/// used in mocking or dependency injection scenarios to replace instances
/// of a particular type with a mock or custom implementation.
typedef Override<S> = void Function(Type type, S dep);
