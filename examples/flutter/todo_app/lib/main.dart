import 'package:flutter/material.dart';
import 'package:todo_app/app/interaction/interaction.dart';
import 'package:todo_app/app/interface/interface.dart';
import 'package:flutter_super/flutter_super.dart';

void main() {
  runApp(
    SuperApp(
      config: SuperAppConfig(
        // testMode: true,
        mocks: [
          MockTodoController(),
        ],
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoView(),
      // home: TodoView2(),
      debugShowCheckedModeBanner: false,
    );
  }
}
