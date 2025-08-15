import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/todo_loader.dart';
import '../widgets/todo_tile.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addFromInput() {
    final text = _controller.text;
    context.read<TodoProvider>().addTodo(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final todo = context.watch<TodoProvider>();   // ใช้ลิสต์/จำนวน
    final loader = context.watch<TodoLoader>();   // ใช้สถานะโหลด

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          // Badge นับจำนวน รีบิวด์เฉพาะตัวเลข
          Selector<TodoProvider, int>(
            selector: (_, p) => p.count,
            builder: (_, count, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Items: $count', style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
          // Toggle theme รีบิวด์เฉพาะไอคอน
          Consumer<ThemeProvider>(
            builder: (_, theme, __) => IconButton(
              tooltip: 'Toggle Theme',
              icon: Icon(theme.isDark ? Icons.dark_mode : Icons.light_mode),
              onPressed: theme.toggle,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // แถวเพิ่มงาน + ปุ่มโหลด
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add a task…',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addFromInput(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: loader.status == LoadStatus.loading
                      ? null
                      : () {
                          debugPrint('LOAD CLICKED');
                          loader.load();
                        },
                  child: Text(
                    loader.status == LoadStatus.loading ? 'Loading…' : 'Load from API',
                  ),
                ),
              ],
            ),
          ),

          // แสดงสถานะโหลด (อยู่นอก Row เพื่อไม่ให้แนวนอนล้น)
          if (loader.status == LoadStatus.loading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
          if (loader.status == LoadStatus.error)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: ${loader.errorMessage}'),
            ),
          if (loader.status == LoadStatus.done)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Loaded Items:'),
                  const SizedBox(height: 6),
                  ...loader.items.map((e) => Text('• $e')),
                ],
              ),
            ),

          const Divider(height: 16),

          // ลิสต์งาน รีบิวด์เฉพาะแถวที่เปลี่ยน
          Expanded(
            child: ListView.builder(
              itemCount: todo.count,
              itemBuilder: (_, i) => TodoTile(index: i),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.read<TodoProvider>().addTodo('Task ${todo.count + 1}'),
        icon: const Icon(Icons.add),
        label: const Text('Quick add'),
      ),
    );
  }
}
