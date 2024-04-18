import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';
import 'package:flutter_super/src/core/typedefs.dart';

/// A stateful widget that represents the root of the Super framework.
class SuperApp extends StatefulWidget {
  /// This creates a SuperApp widget. This is a stateful widget that
  /// represents the root of the Super framework.
  ///
  /// The [child] parameter is required and represents the main content
  /// of the app.
  ///
  /// The [config] parameter is an optional [SuperAppConfig] object that
  /// allows you to customize the behavior of the Super framework.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// SuperApp(
  ///   config: SuperAppConfig(
  ///     mocks: [
  ///       MockAuthRepo(),
  ///       MockDatabase(),
  ///     ],
  ///     testMode: true,
  ///     enableLog: kDebugMode,
  ///     onInit: asyncFunction,
  ///     loading: SizedBox(),
  ///     onError: (err, stk) => SizedBox();
  ///   ),
  ///   child: const MyApp(),
  /// );
  /// ```
  const SuperApp({
    required this.child,
    this.config = const SuperAppConfig(),
    super.key,
  });

  /// The main content widget of the app.
  final Widget child;

  /// Configuration options for the Super framework.
  final SuperAppConfig config;

  @override
  State<SuperApp> createState() => _SuperAppState();
}

class _SuperAppState extends State<SuperApp> {
  @override
  void initState() {
    super.initState();
    // Activate the Super framework
    Super.activate(
      mocks: widget.config.mocks,
      testMode: widget.config.testMode,
      enableLog: widget.config.enableLog,
    );
  }

  @override
  void dispose() {
    // Deactivate the Super framework
    Super.deactivate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return the child widget as the main content of the app.
    return AsyncBuilder(
      future: widget.config.onInit,
      builder: (_) => widget.child,
      loading: widget.config.loading ?? const SizedBox(),
      error: widget.config.onError,
    );
  }
}

/// Configuration class for the SuperApp widget.
class SuperAppConfig {
  /// Configuration class for the SuperApp widget.
  /// Example usage:
  ///
  /// ```dart
  /// SuperApp(
  ///   config: SuperAppConfig(
  ///     mocks: [
  ///       MockAuthRepo(),
  ///       MockDatabase(),
  ///     ],
  ///     testMode: true,
  ///     enableLog: false,
  ///     onInit: asyncFunction,
  ///     loading: CircularProgressIndicator(),
  ///   ),
  ///   child: const MyApp(),
  /// );
  /// ```
  const SuperAppConfig({
    this.mocks,
    this.onInit,
    this.onError,
    this.loading,
    this.enableLog = false,
    this.testMode = false,
  });

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

  /// An optional callback that runs before the application is initialized.
  final Future<void>? onInit;

  /// An optional widget to display while the onInit callback is in progress.
  final Widget? loading;

  /// An optional callback that runs if an error occurs during the build phase.
  final AsyncErrorBuilder? onError;
}
