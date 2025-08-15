import 'package:flutter/foundation.dart';

class TodoProvider with ChangeNotifier {
  final List<String> _todos = [];

  List<String> get todos => List.unmodifiable(_todos);

  void addTodo(String title) {
    if (title.trim().isEmpty) return;
    _todos.add(title.trim());
    notifyListeners();
  }

  void removeTodo(int index) {
    if (index < 0 || index >= _todos.length) return;
    _todos.removeAt(index);
    notifyListeners();
  }

  int get count => _todos.length;
  String? titleAt(int index) =>
      (index >= 0 && index < _todos.length) ? _todos[index] : null;
}
