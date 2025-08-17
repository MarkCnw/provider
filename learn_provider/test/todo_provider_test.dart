import 'package:flutter_test/flutter_test.dart';
import 'package:learn_provider/providers/todo_provider.dart';

void main() {
  group('TodoProvider', () {
    late TodoProvider provider;

    setUp(() {
      provider = TodoProvider();
    });

    test('เริ่มต้นควรเป็นลิสต์ว่าง', () {
      expect(provider.count, 0);
      expect(provider.todos, []);
    });

    test('เพิ่มงานใหม่แล้ว count ควรเพิ่ม', () {
      provider.addTodo('Task 1');
      expect(provider.count, 1);
      expect(provider.todos[0], 'Task 1');
    });

    test('ลบงานแล้ว count ลดลง', () {
      provider.addTodo('Task 1');
      provider.addTodo('Task 2');
      provider.removeTodo(0);
      expect(provider.count, 1);
      expect(provider.todos[0], 'Task 2');
    });
  });
}
