import 'dart:developer' show log;
import 'package:flutter_super/src/injection.dart';

/// The default Logger of the Super Framework
void logger(String msg, {bool warning = false}) {
  if (Injection.enableLog) {
    if (warning) {
      log(msg, name: 'Super');
    } else {
      log('\x1B[36m$msg\x1B[0m', name: 'Super');
    }
  }
}
