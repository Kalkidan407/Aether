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
