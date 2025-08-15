import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class TodoTile extends StatelessWidget {
    final int index;
    const TodoTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    // ฟังเฉพาะ title ของแถวนี้ (ถ้าโดนลบ ให้เป็น null แล้วไม่แครช)
    final title = context.select<TodoProvider, String?>(
      (p) => p.titleAt(index),
    );

    if (title == null) {
      // แถวนี้อาจถูกลบไปในเฟรมก่อนหน้า
      return const SizedBox.shrink();
    }

    return ListTile(
      title: Text(title),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => context.read<TodoProvider>().removeTodo(index),
      ),
    );
  }
}
