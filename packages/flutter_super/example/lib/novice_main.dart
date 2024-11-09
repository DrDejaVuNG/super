import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

void main() {
  runApp(
    // Adding SuperApp enables the framework for the project
    const SuperApp(child: MaterialApp(home: HomeView())), // Step 1
  );
}

// Define a state object
final count = 0.rx; // RxInt(0); // Step 2

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // This returns the state of an Rx object and rebuilds the widget
    // when the state changes.
    final state = context.watch(count); // Step 3
    return Scaffold(
      body: Center(
        child: Text(
          // Use the count state
          '$state', // Step 4
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Increment the count state
        onPressed: () => count.state++, // Step 5
        child: const Icon(Icons.add),
      ),
    );
  }
}
