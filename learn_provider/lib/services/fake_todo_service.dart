import 'dart:async';
import '../models/todo_item.dart';
import 'i_todo_repo.dart';

class FakeTodoRepo implements ITodoRepo {
  final _ctrl = StreamController<List<TodoItem>>.broadcast();
  final List<TodoItem> _items = [];
  int _seq = 0;

  FakeTodoRepo() {
    // เริ่มด้วยลิสต์ว่าง
    _emit();
  }

  void _emit() => _ctrl.add(List.unmodifiable(_items));

  @override
  Stream<List<TodoItem>> streamTodos(String userId) => _ctrl.stream;

  @override
  Future<void> addTodo(String userId, String title) async {
    _items.add(TodoItem(id: 'id${_seq++}', title: title, done: false));
    _emit();
  }

  @override
  Future<void> toggleDone(String id, bool value) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i != -1) {
      _items[i] = TodoItem(id: _items[i].id, title: _items[i].title, done: value);
      _emit();
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
    _emit();
  }

  void dispose() => _ctrl.close();
}
