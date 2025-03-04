import 'package:flutter_super/flutter_super.dart';

class TodoModel with SuperModel {
  TodoModel({
    required this.id,
    required this.title,
    required this.text,
    required this.created,
  });

  final String id;
  final String title;
  final String text;
  final DateTime created;

  TodoModel copyWith({
    String? id,
    String? title,
    String? text,
    DateTime? created,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      created: created ?? this.created,
    );
  }

  @override
  List<Object?> get props => [id, title, text, created];
}
