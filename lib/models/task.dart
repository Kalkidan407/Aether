import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  late String title;                 // required task name
  late DateTime deadline;           // required deadline (can default to now)
  bool isDone = false;              // is completed now?
  bool wasEverCompleted = false;    // useful for streaks/history
  DateTime? startTime;              // optional start
  DateTime? endTime;                // optional end

  Task();

  Task copyWith(
    String title, {
    bool? isDone = false,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Task()
      ..title = title
      ..isDone = isDone ?? false
      ..startTime = startTime ?? this.startTime
      ..endTime = endTime ?? this.endTime
      ..deadline = this.deadline
      ..wasEverCompleted = this.wasEverCompleted;
  }
}
