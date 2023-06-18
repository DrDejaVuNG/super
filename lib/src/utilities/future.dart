import 'dart:async';

/// Extension on Future
extension FutureExt on Future<dynamic> {
  /// An extension method for handling the result of a [Future] with success
  /// and error callbacks.
  ///
  /// The `result` method allows you to provide two callbacks: one for
  /// handling the success case
  /// when the [Future] completes successfully, and one for handling the
  /// error case when an exception occurs.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// Future<int> fetchNumber() async {
  ///   // Simulating an asynchronous operation
  ///   await Future.delayed(Duration(seconds: 2));
  ///
  ///   // Simulating an error
  ///   throw Failure('Failed to fetch number');
  /// }
  ///
  /// void handleSuccess(int number) {
  ///   print('Fetched number: $number');
  /// }
  ///
  /// void handleError(Failure error) {
  ///   print('Error occurred: ${error.message}');
  /// }
  ///
  /// void main() {
  ///   fetchNumber().result(handleError, handleSuccess);
  ///
  ///   // or
  ///
  ///   final request = fetchNumber();
  ///   request.result<Failure, int>(
  ///     (e) => print('Error occurred: ${e.message}');  // could replace `e` with error
  ///     (s) => print('Fetched number: $s');            // could replace `s` with number
  ///   );
  /// }
  /// ```
  ///
  /// In the example above, the `fetchNumber` method is an asynchronous
  /// function that returns a [Future] of type `int`.
  /// The `result` method is used to handle the result of the `fetchNumber`
  /// future.
  /// If the future completes successfully, the `handleSuccess` callback is
  /// invoked with the result value.
  /// If an exception occurs during the future execution, the `handleError`
  /// callback is invoked with the exception object.
  ///
  /// The `onError` callback takes a single parameter of type [O] to
  /// handle any type of exception.
  /// The `onSuccess` callback takes a single parameter of type [T], which
  /// represents the type of the future's result.
  ///
  /// Note: It is recommended to provide type annotations for the `onError`
  /// and `onSuccess` callbacks to ensure type safety and enable better code
  /// completion in IDEs.
  Future<void> result<O extends Object, T>(
    void Function(O e) onError,
    void Function(T s) onSuccess,
  ) async {
    try {
      final s = await this as T;
      onSuccess(s);
    } on O catch (e) {
      onError(e);
    }
  }
}
