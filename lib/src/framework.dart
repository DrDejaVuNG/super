import 'package:flutter/material.dart';
import 'package:flutter_super/src/injection.dart';

/// A stateful widget that represents the root of the Super framework.
final class SuperApp extends StatefulWidget {
  /// Creates a SuperApp widget.
  ///
  /// The [child] parameter is required and represents the main content
  /// of the app.
  ///
  /// The [mocks] parameter is an optional list of objects used for
  /// mocking dependencies during testing.
  /// The `mocks` property provides a way to inject mock objects into the
  /// application's dependency graph during testing.
  /// These mock objects can replace real dependencies, such as database
  /// connections or network clients,
  /// allowing for controlled and predictable testing scenarios.
  ///
  /// **Note:** When using the `mocks` property, make sure to provide
  /// instantiated mock objects, not just their types.
  /// For example, instead of `[MockAuthRepo]`, use `[MockAuthRepo()]`
  /// to ensure that the mock object is used.
  /// Adding the type without instantiating the mock object will result
  /// in the mock not being utilized.
  ///
  /// It is recommended to use the `mocks` property sparingly and only
  /// when necessary for testing purposes.
  /// In most cases, the application should rely on the actual
  /// dependencies to ensure accurate behavior.
  ///
  /// The [testMode] parameter is an optional boolean value that enables
  /// or disables test mode.
  /// When [testMode] is set to `true`, the Super framework is activated
  /// in test mode.
  /// Test mode can be used to enable additional testing features or
  /// behaviors specific to the Super framework.
  /// By default, test mode is set to `false`.
  ///
  /// The [autoDispose] parameter is an optional boolean value that
  /// determines whether the Super framework should automatically
  /// dispose of controllers, dependencies, and other resources
  /// when they are no longer needed.
  /// By default, [autoDispose] is set to `true`, enabling automatic disposal.
  /// Set [autoDispose] to `false` if you want to manually handle the
  /// disposal of resources in your application.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// SuperApp(
  ///   mocks: [
  ///     MockAuthRepo(),
  ///     MockDatabase(),
  ///   ],
  ///   testMode: true,
  ///   child: const MyApp(),
  /// );
  /// ```
  const SuperApp({
    required this.child,
    super.key,
    this.mocks,
    this.enableLog = false,
    this.testMode = false,
    this.autoDispose = true,
  });

  /// The main content widget of the app.
  final Widget child;

  /// An optional list of objects used for mocking dependencies during testing.
  final List<Object>? mocks;

  /// An optional boolean value that enables or disables logging
  /// in the Super framework.
  final bool enableLog;

  /// An optional boolean value that enables or disables test mode
  /// for the Super framework.
  ///
  /// When [testMode] is set to `true`, the Super framework is
  /// activated in test mode.
  /// Test mode can be used to enable additional testing features
  /// or behaviors specific to the Super framework.
  /// By default, test mode is set to `false`.
  final bool testMode;

  /// An optional boolean value that determines whether the Super framework
  /// should automatically dispose of controllers, dependencies, and other
  /// resources when they are no longer needed.
  ///
  /// By default, [autoDispose] is set to `true`, enabling automatic disposal.
  /// Set [autoDispose] to `false` if you want to manually handle the
  /// disposal of resources in your application.
  ///
  /// When [autoDispose] is `true`, the Super framework will automatically
  /// dispose of controllers, dependencies, and other resources when
  /// the associated widgets are removed from the widget tree.
  ///
  /// When [autoDispose] is `false`, it is the responsibility of the
  /// developer to manually dispose of resources using appropriate
  /// methods provided by the Super framework.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// SuperApp(
  ///   child: MyApp(),
  ///   autoDispose: false,
  /// );
  /// ```
  final bool autoDispose;

  @override
  State<SuperApp> createState() => _SuperAppState();
}

class _SuperAppState extends State<SuperApp> {
  @override
  void initState() {
    super.initState();
    // Activate the Super framework
    Injection.activate(
      autoDispose: widget.autoDispose,
      mocks: widget.mocks,
      testMode: widget.testMode,
      enableLog: widget.enableLog,
    );
  }

  @override
  void dispose() {
    // Deactivate the Super framework
    Injection.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return the child widget as the main content of the app.
    return widget.child;
  }
}
