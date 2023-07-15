// ignore_for_file: avoid_print
import 'package:dart_super/dart_super.dart';

void main() {
  Super.activate(); // Activate the Super framework

  // Declare a state object
  final count = 0.rx;

  // The method used in the addListener method will be called
  // every time the state changes.
  rxWatch(() => print(count.state), stopWhen: () => count.state > 3);

  // Increment the state
  count.state++; // prints '1'
  count.state++; // prints '2'
  count.state++; // prints '3'
  count.state++; // doesn't print
}
