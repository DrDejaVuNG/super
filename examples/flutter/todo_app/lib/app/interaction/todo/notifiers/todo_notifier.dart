import 'package:todo_app/app/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super/flutter_super.dart';

TodoNotifier get $todoNotifier => Super.init(TodoNotifier());

class TodoNotifier extends RxNotifier<List<TodoModel>> {
  @override
  List<TodoModel> initial() {
    return [];
  }

  final title = TextEditingController();
  var content = TextEditingController();

  void addTodo(BuildContext context) {
    if (title.text == '' || content.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill empty fields'),
        ),
      );
      return;
    }
    final todo = TodoModel(
      id: '${state.length}',
      title: title.text,
      text: content.text,
      created: DateTime.now(),
    );

    state = [...state, todo];
    title.clear();
    content.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully added todo'),
      ),
    );
  }

  void removeTodo(BuildContext context, TodoModel todo) {
    final list = state;
    list.remove(todo);
    state = list;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully removed todo'),
      ),
    );
  }
}
