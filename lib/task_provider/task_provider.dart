import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/isar_services.dart';

class TaskProvider extends ChangeNotifier {
  final IsarService _isarService = IsarService();

  Stream<List<Task>> get tasks => _isarService.watchTasks();

  Future<void> addTask(String title) async {
    final task = Task()
      ..title = title
      ..deadline = DateTime.now();
    await _isarService.addTask(task);
  }

  Future<void> deleteTask(Task task) async {
    await _isarService.deleteTask(task.id);
  }

  Future<void> toggleTask(Task task) async {
    await _isarService.toggleTask(task);
  }
}
