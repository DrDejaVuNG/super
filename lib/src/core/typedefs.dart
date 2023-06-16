import 'package:flutter/material.dart';

/// A function type used for overriding instances during testing
/// or dependency injection.
///
/// The [Override] typedef represents a function that takes a [Type]
/// and an instance of a generic type [S] as parameters. It is
/// used in mocking or dependency injection scenarios to replace instances
/// of a particular type with a mock or custom implementation.
typedef Override<S> = void Function(Type type, S dep);

/// A callback function that builds a widget based on a [BuildContext].
///
/// The [RxBuilder] typedef represents a function that takes a [BuildContext]
/// as a parameter and returns a widget. It is used as the builder
/// callback in SuperBuilder that listens to changes in Rx objects and rebuild
/// the UI in response to those changes.
typedef RxBuilder = Widget Function(BuildContext context);

/// A callback function that takes a [BuildContext] as a parameter.
///
/// The [RxCallback] typedef represents a function that takes a [BuildContext]
/// as a parameter and does not return a value. It is used as the listener
/// callback in SuperListener for performing actions or side effects in response
/// to changes in Rx objects.
typedef RxCallback = void Function(BuildContext context);

/// A condition function that determines whether to rebuild based on
/// previous and current values.
///
/// The [RxCondition] typedef represents a function that takes two parameters:
/// the previous value and the current value of a generic type [T].
/// It returns a nullable boolean value, which determines whether to call
/// the listener based on the change in values. If the condition function
/// returns `null`, the listener callback is deferred to the default behavior.
/// This typedef is used for the listenWhen callback in Superlistener for
/// performing actions or side effects in response to changes in Rx objects.
typedef RxCondition<T> = bool? Function(T previous, T current)?;

/// A callback function that builds a widget based on an error and stack trace.
///
/// The [AsyncErrorBuilder] typedef represents a function that takes
/// an [Object] error and a [StackTrace] as parameters and returns a widget.
/// It is used as a builder callback for rendering error states in
/// asynchronous operations, such as network requests or data loading.
typedef AsyncErrorBuilder = Widget Function(
  Object error,
  StackTrace stackTrace,
);

/// A callback function that builds a widget based on asynchronous data.
///
/// The [AsyncDataBuilder] typedef represents a function that takes a generic
/// type [T] as a parameter and returns a widget. It is used as a
/// builder callback for rendering the data received from asynchronous
/// operations, such as network requests or data loading.
/// The type parameter [T] represents the type of the data being received.
typedef AsyncDataBuilder<T> = Widget Function(T? data);
