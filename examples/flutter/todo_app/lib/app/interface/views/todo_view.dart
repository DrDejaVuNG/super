import 'package:todo_app/app/interaction/interaction.dart';
import 'package:todo_app/app/interface/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

/*
Note: Both SuperController and RxNotifier can be used in a widget at the same 
time for different reasons, this example simply showcases different implementations 
of seperating the state logic from the UI.

Remember, the controller has no ablity to hold state on its own, it is essentially 
a lifecycle class for SuperWidgets (StatelessWidgets).
*/

// Uses Controller
class TodoView extends SuperWidget<TodoController> {
  const TodoView({super.key});

  @override
  TodoController initController() => $todoController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Super Todos Using Controller")),
      body: SuperBuilder(
        builder: (context) {
          if (controller.todoList.isEmpty) {
            return Center(
              child: Text(
                '0 todos to show',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.todoList.length,
            itemBuilder: (context, index) {
              return TodoTile(todo: controller.todoList[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create a new todo'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: controller.title,
                      decoration: const InputDecoration(
                        hintText: 'Enter Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.content,
                      decoration: const InputDecoration(
                        hintText: 'Enter Text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      controller.addTodo();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Uses Notifier
class TodoView2 extends StatelessWidget {
  const TodoView2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Super Todos Using Notifier")),
      body: SuperConsumer(
        rx: $todoNotifier,
        builder: (context, todoList) {
          if (todoList.isEmpty) {
            return Center(
              child: Text(
                '0 todos to show',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return TodoTile2(todo: todoList[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create a new todo'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: $todoNotifier.title,
                      decoration: const InputDecoration(
                        hintText: 'Enter Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: $todoNotifier.content,
                      decoration: const InputDecoration(
                        hintText: 'Enter Text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      $todoNotifier.addTodo(context);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
