// import 'package:flutter_test/flutter_test.dart';
// import 'package:learn_provider/providers/todo_provider.dart';

// void main() {
//   group('TodoProvider', () {
//     late TodoProvider provider;

//     setUp(() {
//       provider = TodoProvider();
//     });

//     test('เริ่มต้นควรไม่มีงาน', () {
//       expect(provider.count, 0);
//     });

//     test('เพิ่มงานแล้ว count ควรเพิ่ม', () {
//       provider.addTodo('Test Task');
//       expect(provider.count, 1);
//       expect(provider.todos.first, 'Test Task');
//     });

//     test('ลบงานแล้ว count ควรลด', () {
//       provider.addTodo('Task 1');
//       provider.removeTodo(0);
//       expect(provider.count, 0);
//     });
//   });
// }
