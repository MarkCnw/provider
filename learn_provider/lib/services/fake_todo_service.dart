class FakeTodoService {
  Future<List<String>> fethTodos() async {
    await Future.delayed(Duration(seconds: 2));
    // โยน error ทดสอบได้โดย uncomment:
    // throw Exception('Network error');
    return ['Buy milk','Read book','Write code'];
  }
}
