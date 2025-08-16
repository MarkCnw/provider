import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_provider/models/todo_item.dart';

class TodoRepo {
  final _col = FirebaseFirestore.instance.collection('todos');

  Stream<List<TodoItem>> streamTodos(String userId) {
    return _col
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => TodoItem.fromMap(d.data(), d.id))
              .toList(growable: false),
        );
  }

  Future<void> addTodo(String userId, String title) async {
    await _col.add({'userId': userId, 'title': title, "done": false});
  }

  Future<void> toggleDone(String id, bool value) async {
    await _col.doc(id).update({'done': value});
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
