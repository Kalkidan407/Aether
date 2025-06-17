import 'package:isar/isar.dart';

part 'task.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;

  late String title;
  late DateTime deadline;
  bool isDone = false;
  bool wasEverCompleted = false;
  DateTime? startTime;
  DateTime? endTime;

  Task(this.title, {this.isDone = false, this.startTime, this.endTime});
}
