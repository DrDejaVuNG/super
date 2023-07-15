import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/// A Counter example using the Super framework.
///
/// This example demonstrates how to use the Super framework to build
/// the starter counter app in flutter.
/// The app consists of a single screen that displays a counter state
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
/// 4. Create a widget that extends [StatelessWidget] and initializes
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

/// MyApp is the root widget of the application. 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}

/// Inject Dependency for global access (It can easily be mocked later).
HomeController get homeController => Super.init(HomeController()); 

/// The controller class manages the state and logic in the application.
class HomeController extends SuperController { // Step 2
  final _count = 0.rx; // RxInt(0);

  int get count => _count.state;

  void increment() => _count.state++; // Step 3

  @override
  void onDisable() {
    _count.dispose(); // Dispose Rx object.
    super.onDisable();
  }
}

class HomeView extends StatelessWidget { // Step 4
  const HomeView({super.key});

  HomeController get controller => homeController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // SuperBuilder listens and rebuilds only when the state changes.
        child: SuperBuilder( // Step 5
          builder: (context) {
            // controller is the Widget Controller reference
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
