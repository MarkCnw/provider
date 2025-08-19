import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_provider/Screen/todo_screen.dart';
import 'package:provider/provider.dart';

import 'package:learn_provider/models/todo_item.dart';

import 'package:learn_provider/services/i_todo_repo.dart';


import 'package:learn_provider/providers/todo_provider.dart';
import 'package:learn_provider/providers/theme_provider.dart';
import 'package:learn_provider/providers/todo_loader.dart';
import 'package:learn_provider/services/fake_todo_service.dart';

void main() {
  testWidgets('เพิ่ม/ติ๊ก/ลบ Remote task ด้วย FakeRepo', (tester) async {
    final fakeRepo = FakeTodoRepo();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TodoProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => TodoLoader(FakeTodoService())),
          Provider<ITodoRepo>(create: (_) => fakeRepo),                  // ⬅️ ใช้ของปลอม
          StreamProvider<List<TodoItem>>(
            create: (ctx) => ctx.read<ITodoRepo>().streamTodos('demo-user'),
            initialData: const [],
          ),
        ],
        child: const MaterialApp(home: TodoScreen()),
      ),
    );

    // เริ่ม: ไม่มี remote item
    expect(find.textContaining('Remote Task'), findsNothing);

    // เพิ่ม 1 ชิ้น
    await tester.tap(find.text('Add remote'));
    await tester.pump();               // เฟรม UI
    await tester.pump(const Duration(milliseconds: 1)); // รอ stream กระตุก

    expect(find.text('Remote Task 1'), findsOneWidget);

    // ติ๊ก done
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    // ลบ
    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pump();
    expect(find.text('Remote Task 1'), findsNothing);

    // ทำความสะอาด
    fakeRepo.dispose();
  });
}
