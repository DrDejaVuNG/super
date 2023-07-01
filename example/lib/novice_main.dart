import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart'; // Step 1

void main() {
  runApp(
    // Adding SuperApp enables the framework for the project
    const SuperApp(child: MyApp()), // Step 2
  );
}

class MyApp extends StatelessWidget { // Step 3
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}

class HomeView extends StatelessWidget { // Step 4
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) { 
    // Declare Rx object as `final` for Immutability
    final count = 0.rx; // RxInt(0); // Step 5
    return Scaffold(
      appBar: AppBar(title: const Text('Counter example')),
      body: Center(
        // SuperBuilder listens to Rx objects used in its builder 
        // method and rebuilds only when the state changes.
        child: SuperBuilder( // Step 6
          builder: (context) {
            return Text(
            // .value is used to access the state of the Rx object.
              '${count.value}',
              style: Theme.of(context).textTheme.displayLarge,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Increment the count state
        onPressed: () => count.value++, // Step 7
        child: const Icon(Icons.add),
      ),
    );
  }
}
