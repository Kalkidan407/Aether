import 'package:flutter/material.dart';
import 'package:kuraztest/task/task.dart';

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TaskList(), debugShowCheckedModeBanner: false);
  }
}
