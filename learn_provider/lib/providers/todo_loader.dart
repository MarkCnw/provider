import 'package:flutter/material.dart';
import 'package:learn_provider/services/fake_todo_service.dart';

enum LoadStatus { idle, loading, done, error }

class TodoLoader with ChangeNotifier {
  final FakeTodoService _svc;
  TodoLoader(this._svc);

  LoadStatus status = LoadStatus.idle;
  String? errorMessage;
  List<String> items = [];

  Future<void> load() async {
    status = LoadStatus.loading;
    notifyListeners();
    try {
      items = await _svc.fethTodos();
      status = LoadStatus.done;
    } catch (e) {
      errorMessage = e.toString();
      status = LoadStatus.error;
    }
    notifyListeners();
    
  }
}
