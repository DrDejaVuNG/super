import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/// A Counter example using the Super framework.
///
/// This example demonstrates how to use the Super framework to build
/// the starter counter app in flutter.
/// The app consists of a single screen that displays a counter value
/// and a floating action button to increment the counter. 
/// The app utilizes the Super framework for managing state and 
/// separating concerns using controllers.
///
/// To run the counter example:
/// 1. Wrap the root widget of your app with [SuperApp] to enable the
/// Super framework.
/// 2. Create a controller class that extends [SuperController] and
/// define the counter state.
/// 3. Implement the necessary methods in the controller, such as
/// incrementing the counter and disposing of resources.
/// 4. Create a widget that extends [SuperWidget] and initializes
/// the controller.
/// 5. Build the UI using [SuperBuilder] to listen to the state changes
/// and update the UI accordingly.
///
/// This example demonstrates the basic usage of the Super framework
/// and serves as a starting point for more complex apps.
void main() {
  runApp(
    // Adding SuperApp enables the framework for the project
    const SuperApp(child: MyApp()), // Step 1
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}

class HomeController extends SuperController { // Step 2
  // Declare Rx object as `final` for Immutability
  final _count = 0.rx; // RxInt(0);

  int get count => _count.value;

  void increment() { // Step 3
    _count.value++;
  }

  @override
  void onDisable() {
    _count.dispose(); // Dispose Rx object.
    super.onDisable();
  }
}

/// The home view widget that displays the counter and provides an
/// increment button.
///
/// This widget extends [SuperWidget] to initialize the [HomeController].
/// It utilizes [SuperBuilder] to listen to the state changes in the controller
/// and update the UI accordingly.
class HomeView extends SuperWidget<HomeController> { // Step 4
  const HomeView({super.key});

  @override
  HomeController initController() => HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        // SuperBuilder is a widget that listens to Rx objects used in
        // its builder method and rebuilds only when the state changes.
        child: SuperBuilder( // Step 5
          builder: (context) {
            // controller is the instance getter for the Controller of
            // the widget
            return Text(
              '${controller.count}',
              style: Theme.of(context).textTheme.displayLarge,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Increment the count state by calling the increment() method
        onPressed: () => controller.increment(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
