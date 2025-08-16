// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:learn_provider/providers/todo_provider.dart';
import 'package:provider/provider.dart';

class TodoDetailScreen extends StatelessWidget {
  final int index;
  const TodoDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final todo = context.watch<TodoProvider>();
    final title = todo.todos[index];

    return Scaffold(
      appBar: AppBar(title: Text('Todo Detail')),
      body: Center(child: Text(title, style: TextStyle(fontSize: 28))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todo.removeTodo(index);
          Navigator.pop(context);
        },
        child: Icon(Icons.delete),
      ),
    );
  }
}
