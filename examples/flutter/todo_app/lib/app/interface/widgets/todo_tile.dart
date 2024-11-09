import 'package:todo_app/app/domain/domain.dart';
import 'package:todo_app/app/interaction/interaction.dart';
import 'package:flutter/material.dart';

String minutesSinceCreated(DateTime date) {
  return DateTime.now().difference(date).inMinutes.toString();
}

// Uses Controller
class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo});

  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) => $todoController.removeTodo(todo),
      key: Key(todo.id),
      child: ListTile(
        leading: Text(todo.id),
        title: Text(todo.title),
        subtitle: Text(todo.text),
        trailing: Text('${minutesSinceCreated(todo.created)} minutes ago'),
      ),
    );
  }
}

// Uses Notifier
class TodoTile2 extends StatelessWidget {
  const TodoTile2({super.key, required this.todo});

  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) => $todoNotifier.removeTodo(context, todo),
      key: Key(todo.id),
      child: ListTile(
        leading: Text(todo.id),
        title: Text(todo.title),
        subtitle: Text(todo.text),
        trailing: Text('${minutesSinceCreated(todo.created)} minutes ago'),
      ),
    );
  }
}
