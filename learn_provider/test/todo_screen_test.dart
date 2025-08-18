// // test/todo_screen_test.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:learn_provider/Screen/todo_screen.dart';
// import 'package:provider/provider.dart';

// import 'package:learn_provider/providers/todo_provider.dart';
// import 'package:learn_provider/providers/theme_provider.dart';
// import 'package:learn_provider/providers/todo_loader.dart';
// import 'package:learn_provider/services/fake_todo_service.dart';

// import 'package:learn_provider/models/todo_item.dart';        // ถ้ามี
 

// // ถ้าไม่มีโมเดล ก็ลบ import ข้างบน แล้วปรับ StreamProvider ให้ส่ง <dynamic>[] ก็ได้
// void main() {
//   testWidgets('กดปุ่ม Quick add แล้วเพิ่ม Task', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => TodoProvider()),
//           ChangeNotifierProvider(create: (_) => ThemeProvider()),
//           ChangeNotifierProvider(create: (_) => TodoLoader(FakeTodoService())),
//           // สร้างสตรีมปลอมให้ TodoScreen ใช้งานได้ (แทน Firestore จริง)
//           StreamProvider<List<TodoItem>>(
//             create: (_) => Stream.value(const <TodoItem>[]),
//             initialData: const <TodoItem>[],
//           ),
//         ],
//         child: const MaterialApp(home: TodoScreen()),
//       ),
//     );

//     // ก่อนกด
//     expect(find.text('Items: 0'), findsOneWidget);

//     // กดปุ่ม Quick add (ไอคอน +)
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump(); // ให้เฟรมรีเฟรช

//     // หลังกด ควรเห็น Task 1 และ badge เปลี่ยน
//     expect(find.text('Task 1'), findsOneWidget);
//     expect(find.text('Items: 1'), findsOneWidget);
//   });
// }
