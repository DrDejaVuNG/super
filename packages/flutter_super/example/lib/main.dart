import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

void main() {
  runApp(
    // Adding SuperApp enables the framework for the project
    const SuperApp(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeView());
  }
}

// Inject Dependency for global access (It can easily be mocked later).
CountNotifier get countNotifier => Super.init(CountNotifier());

// The notifier class manages the state in the application.
class CountNotifier extends RxNotifier<int> {
  // Step 2
  @override
  int initial() {
    return 0;
  }

  void increment() => state++; // Step 3
}

class HomeView extends StatelessWidget {
  // Step 4
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // SuperBuilder listens and rebuilds only when the state changes.
    return Scaffold(
      body: Center(
        child: SuperBuilder(
          builder: (context) {
            return Text(
              '${countNotifier.state}',
              style: Theme.of(context).textTheme.displayLarge,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Increment the count state by calling the increment() method
        onPressed: countNotifier.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
