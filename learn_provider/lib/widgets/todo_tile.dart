import 'package:flutter/material.dart';
import 'package:learn_provider/Screen/todo_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class TodoTile extends StatelessWidget {
  final int index;
  const TodoTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final title = context.select<TodoProvider, String>(
      (p) => p.todos[index],
    );

    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TodoDetailScreen(index: index),
          ),
        );
      },
      trailing: IconButton(onPressed: ()=>context.read<TodoProvider>().removeTodo(index), icon: Icon(Icons.delete),),
    );
  }
}
