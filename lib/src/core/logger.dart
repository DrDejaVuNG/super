import 'dart:developer' as dev;
import 'package:flutter_super/src/instance.dart';

/// The default Logger of the Super Framework
void logger(String msg, {bool warning = false}) {
  if (InstanceManager.enableLog) {
    switch (warning) {
      case true:
        dev.log(msg, name: 'Super');
      case false:
        dev.log('\x1B[36m$msg\x1B[0m', name: 'Super');
      default:
    }
  }
}
