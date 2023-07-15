part of 'rx.dart';

/// Executes a callback function while listening to changes in Rx objects
/// and automatically stops listening when a specified condition is met.
///
/// The [callback] function is executed while Rx objects are being listened to.
/// After the callback execution, the changes in the Rx objects are captured and
/// an [RxMerge] instance is created from the captured Rx objects.
///
/// The [stopWhen] parameter is an optional function that determines whether
/// to stop listening to Rx objects. If provided, the [callback] function will
/// be called repeatedly until the [stopWhen] condition returns true.
/// Once the [stopWhen] condition returns true, the callback will no longer
/// be called and the listener will be automatically removed.
///
/// Example:
/// 
/// ```dart
/// RxInt count = 0.rx;
///
/// void increment() {
///   count.state++;
/// }
///
/// void printCount() {
///   print('Current count: ${count.state}');
/// }
///
/// void main() {
///   rxCallback(() {
///     printCount();
///   }, stopWhen: () => count.state >= 10);
/// }
/// 
/// increment();
/// ```
///
/// In the above example, the `rxCallback` is used to execute 
/// the `printCount` function while listening to changes in the 
/// `count` Rx object.
/// The callback function will be repeatedly called until the 
/// `stopWhen` condition returns true (when the count reaches 10).
void rxCallback(VoidCallback callback, {bool Function()? stopWhen}) {
  RxListener.listen();
  callback();
  final rx = RxListener.listenedRx();

  void call() {
    if (stopWhen != null && !stopWhen()) {
      callback();
      return;
    }
    rx.removeListener(call);
  }

  rx.addListener(call);
}
