class FakeTodoService {
  Future<List<String>> fethTodos() async {
    await Future.delayed(Duration(seconds: 2));
    // โยน error ทดสอบได้โดย uncomment:
    // throw Exception('Network error');
    return ['Buy milk','Read book','Write code'];
  }
}

class FakeRealtimeService {
  // สมมติ “จำนวนผู้ใช้ online” เพิ่มทุกวินาที
  Stream<int> onlineCount() async* {
    var n = 0;
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield n++;
    }
  }
}
