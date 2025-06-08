import 'package:flutter/material.dart';
import 'package:kuraztest/task/task.dart';
import 'package:kuraztest/notifi_service/noti_service.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  State<ToDoApp> createState() => _ToDoAppState();

  static _ToDoAppState? of(BuildContext context) =>
      context.findAncestorStateOfType();
}

class _ToDoAppState extends State<ToDoApp> {
  ThemeMode themeMode = ThemeMode.system;
  // void toggleTheme(ThemeMode mode) {
  //   setState(() {
  //     _themeMode = mode;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: themeMode,
      // darkTheme: ThemeData.dark(),
      home: TaskList(),
    );
  }
}
