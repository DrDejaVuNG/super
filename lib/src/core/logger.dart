import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

/// The default Logger of the Super Framework
void logger(String msg, {LogType logType = LogType.info}) {
  if (logType == LogType.error || kDebugMode) {
    switch (logType) {
      case LogType.error:
        dev.log('\x1B[31m$msg\x1B[0m', name: 'Super');
      case LogType.warning:
        dev.log(msg, name: 'Super');
      case LogType.success:
        dev.log('\x1B[32m$msg\x1B[0m', name: 'Super');
      case LogType.info:
        dev.log('\x1B[36m$msg\x1B[0m', name: 'Super');
    }
  }
}

/// Log Types
enum LogType {
  /// Color cyan for informative logs
  info,

  /// Color yellow for warning logs
  warning,

  /// Color red for error logs
  error,

  /// Color green for success logs
  success,
}
