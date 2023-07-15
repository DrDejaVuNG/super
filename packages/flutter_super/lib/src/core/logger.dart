import 'dart:developer' show log;
import 'package:flutter_super/src/injection.dart';

/// The default Logger of the Super Framework
void logger(Object object, {bool warning = false}) {
  if (Injection.enableLog) {
    if (warning) {
      log('$object', name: 'Super');
    } else {
      log('\x1B[36m$object\x1B[0m', name: 'Super');
    }
  }
}
