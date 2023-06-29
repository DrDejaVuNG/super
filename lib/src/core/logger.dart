import 'dart:developer' as dev;

/// The default Logger of the Super Framework
void logger(String msg, bool enableLog, {bool warning = false}) {
  if (enableLog) {
    switch (warning) {
      case true:
        dev.log(msg, name: 'Super');
      case false:
        dev.log('\x1B[36m$msg\x1B[0m', name: 'Super');
      default:
    }
  }
}
