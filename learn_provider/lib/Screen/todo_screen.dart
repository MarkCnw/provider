import 'package:flutter/material.dart';
import 'package:learn_provider/Screen/remote_todo_detail_screen.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/todo_loader.dart';
import '../widgets/todo_tile.dart';

// Remote (Firestore) - 🔥 ใช้ Interface แทน
import '../models/todo_item.dart';
import '../services/i_todo_repo.dart'; // ⬅️ Interface

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
    // โลคอล (Provider)
    final todo = context.watch<TodoProvider>();

    // 🔥 ดึง repo ที่ฉีดมา (ไม่ใช่ new TodoRepo() ตรงๆ)
    final repo = context.read<ITodoRepo>();

    // ใช้ watch เพื่อให้ UI รีบิวด์เมื่อ status/ผลลัพธ์เปลี่ยน
    final loader = context.watch<TodoLoader?>();

    // รีโมท (Firestore) มาจาก StreamProvider<List<TodoItem>>
    final remoteTodos = context.watch<List<TodoItem>>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          // แสดงจำนวนรายการโลคอลแบบประหยัดรีบิวด์
          Selector<TodoProvider, int>(
            selector: (_, p) => p.count,
            builder: (_, count, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Items: $count',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          // ปุ่มสลับธีม
          Consumer<ThemeProvider>(
            builder: (_, theme, __) => IconButton(
              tooltip: 'Toggle Theme',
              icon: Icon(
                theme.isDark ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: theme.toggle,
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // แถวเพิ่มงานโลคอล + ปุ่มโหลด (ถ้าใช้)
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
                // ปุ่มโหลดจาก service (optional)
                ElevatedButton(
                  onPressed:
                      (loader != null &&
                          loader.status != LoadStatus.loading)
                      ? () {
                          debugPrint('LOAD CLICKED');
                          loader.load();
                        }
                      : null,
                  child: Text(
                    (loader != null && loader.status == LoadStatus.loading)
                        ? 'Loading…'
                        : 'Load from API',
                  ),
                ),
              ],
            ),
          ),

          // แสดงสถานะโหลด (เฉพาะกรณีใช้ TodoLoader)
          if (loader != null && loader.status == LoadStatus.loading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
          if (loader != null && loader.status == LoadStatus.error)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Error: ${loader.errorMessage}'),
            ),
          if (loader != null && loader.status == LoadStatus.done)
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

          // ----- โลคอลรายการ -----
          Expanded(
            child: ListView.builder(
              itemCount: todo.count,
              itemBuilder: (_, i) =>
                  TodoTile(index: i), // รีบิวด์เฉพาะแถวที่เปลี่ยน
            ),
          ),

          const Divider(),

          // ----- ส่วน Remote (Firestore) -----
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Remote (Firestore)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // 🔥 ใช้ repo ผ่าน interface
                ElevatedButton(
                  onPressed: () => repo.addTodo(
                    'demo-user',
                    'Remote Task ${remoteTodos.length + 1}',
                  ),
                  child: const Text('Add remote'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: remoteTodos.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (_, i) {
                final t = remoteTodos[i];
                return ListTile(
                  title: Text(t.title),
                  // 🔥 ใช้ repo ผ่าน interface
                  leading: Checkbox(
                    value: t.done,
                    onChanged: (v) => repo.toggleDone(t.id, v ?? false),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => repo.delete(t.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RemoteTodoDetailScreen(id: t.id),
                      ),
                    );
                  },
                );
              },
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