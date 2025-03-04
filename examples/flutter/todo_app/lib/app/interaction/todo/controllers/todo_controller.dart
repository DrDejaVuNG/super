import 'package:todo_app/app/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

TodoController get $todoController => Super.init(TodoController());

class MockTodoController extends TodoController {
  @override
  void addTodo() {
    debugPrint('Mock!!!');
  }
}

class TodoController extends SuperController {
  final todoList = <TodoModel>[].rx;

  final title = TextEditingController();
  var content = TextEditingController();

  @override
  void onEnable() {
    super.onEnable();
    debugPrint('TodoView Widget Created');
  }

  @override
  void onAlive() {
    debugPrint("App fully rendered");
  }

  void addTodo() {
    if (title.text == '' || content.text == '') {
      ScaffoldMessenger.of(ctrlContext).showSnackBar(
        const SnackBar(
          content: Text('Please fill empty fields'),
        ),
      );
      return;
    }

    final todo = TodoModel(
      id: '${todoList.length}',
      title: title.text,
      text: content.text,
      created: DateTime.now(),
    );

    todoList.add(todo);
    title.clear();
    content.clear();
    ScaffoldMessenger.of(ctrlContext).showSnackBar(
      const SnackBar(
        content: Text('Successfully added todo'),
      ),
    );
  }

  void removeTodo(TodoModel todo) {
    todoList.remove(todo);
    ScaffoldMessenger.of(ctrlContext).showSnackBar(
      const SnackBar(
        content: Text('Successfully removed todo'),
      ),
    );
  }
}
