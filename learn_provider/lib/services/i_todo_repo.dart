import 'package:learn_provider/models/todo_item.dart';

abstract class ITodoRepo {
  Stream<List<TodoItem>> streamTodos(String userId);
  Future<void> addTodo(String userId, String title);
  Future<void> toggleDone(String id, bool value);
  Future<void> delete(String id);
}
