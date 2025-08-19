class FakeTodoService {
  Future<List<String>> fethTodos() async {
    // จำลองการโหลดจาก API
    await Future.delayed(Duration(seconds: 2)); // จำลองความช้า
    
    return [
      'Buy groceries from API',
      'Walk the dog from API', 
      'Study Flutter from API',
      'Call mom from API',
      'Fix the car from API',
    ];
  }
}