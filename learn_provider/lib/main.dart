import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_provider/Screen/todo_screen.dart';

import 'package:learn_provider/models/todo_item.dart';
import 'package:learn_provider/providers/todo_loader.dart';
import 'package:learn_provider/services/fake_todo_service.dart';

// 🔥 เพิ่ม imports สำหรับ Interface
import 'package:learn_provider/services/i_todo_repo.dart';
import 'package:learn_provider/services/todo_repo.dart'; // ของจริง
// import 'package:learn_provider/services/fake_todo_repo.dart'; // ของปลอม (สำหรับเทส)

import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  const userId = 'demo-user'; // ← เปลี่ยนให้ตรงผู้ใช้จริง

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => TodoLoader(FakeTodoService()),
        ),

        // 🔥 เพิ่ม Interface Provider
        Provider<ITodoRepo>(create: (_) => TodoRepo()), // ⬅️ ของจริงตอนรันแอป
        // Provider<ITodoRepo>(create: (_) => FakeTodoRepo()), // ⬅️ ใช้ตอนเทส

        // 🔥 ปรับให้ใช้ repo ผ่าน context
        StreamProvider<List<TodoItem>>(
          create: (ctx) => ctx.read<ITodoRepo>().streamTodos(userId),
          initialData: const [],
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ฟังเฉพาะ isDark ให้รีบิวด์เฉพาะ MaterialApp
    final isDark = context.select<ThemeProvider, bool>((t) => t.isDark);

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const TodoScreen(),
    );
  }
}