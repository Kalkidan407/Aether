
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late Future<Isar> _dbFuture;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dbFuture = _initDb();
  }

  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([TaskSchema], directory: dir.path);
  }

  Future<void> _addTask(String title) async {
    final isar = await _dbFuture;
    final task = Task()
      ..title = title
      ..deadline = DateTime.now();
    await isar.writeTxn(() => isar.tasks.put(task));
  }

  Future<void> _toggleTask(Isar isar, Task task) async {
    task.isDone = !task.isDone;
    await isar.writeTxn(() => isar.tasks.put(task));
  }

  Future<void> _deleteTask(Isar isar, Task task) async {
    await isar.writeTxn(() => isar.tasks.delete(task.id));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Isar>(
      future: _dbFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final isar = snapshot.data!;

        return StreamBuilder<List<Task>>(
          stream: isar.tasks.where().watch(fireImmediately: true),
          builder: (context, snapshot) {
            final tasks = snapshot.data ?? [];

            return Scaffold(
              appBar: AppBar(title: const Text('To-Do List')),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                                hintText: 'Enter a task'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            final title = _controller.text.trim();
                            if (title.isNotEmpty) {
                              _addTask(title);
                              _controller.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task.title,
                              style: TextStyle(
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null)),
                          leading: Checkbox(
                            value: task.isDone,
                            onChanged: (_) => _toggleTask(isar, task),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteTask(isar, task),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           //  startTime = await showTimePicker(
                          //   context: context,
                          //   initialTime: TimeOfDay.now(),
                          //   helpText: 'Pick Start Time',
                          //   initialEntryMode: TimePickerEntryMode.input,
                          // );

                          // if (startTime != null) {
                          //    endTime = await showTimePicker(
                          //     context: context,
                          //     initialTime: startTime,
                          //     helpText: 'Pick End Time',
                          //     initialEntryMode:
                          //         TimePickerEntryMode.input,
                          //   );

                          //   if (endTime != null) {
                          //     setState(() {
                          //       task.startTime = startTime;
                          //       task.endTime = endTime;
                          //     });

                          //     if (!task.isDone) {
                          //       final now = DateTime.now();

                          //       final scheduledTime = DateTime(
                          //         now.year,
                          //         now.month,
                          //         now.day,
                          //         pickedEnd.hour,
                          //         pickedEnd.minute,
                          //       );

                          //       final scheduledTimeAtStart = DateTime(
                          //         now.year,
                          //         now.month,
                          //         now.day,
                          //         pickedStart.hour,
                          //         pickedStart.minute,
                          //       );
                          //       final duration = scheduledTime
                          //           .difference(now);

                          //       if (duration.inSeconds > 0) {
                          //         final half = now.add(duration * 0.5);
                          //         final threeQuarter = now.add(
                          //           duration * 0.75,
                          //         );

                          //         await NotiService().scheduleNotification(
                          //           id: task.title.hashCode + 2,
                          //           title: "Reminder",
                          //           body:
                          //               "Halfway to deadline: ${task.title}",
                          //           scheduledTime: half,
                          //         );

                          //         await NotiService().scheduleNotification(
                          //           id: task.title.hashCode + 3,
                          //           title: "Almost due!",
                          //           body:
                          //               "75% time passed for task: ${task.title}",
                          //           scheduledTime: threeQuarter,
                          //         );

                          //         await NotiService().scheduleNotification(
                          //           id: task.title.hashCode + 1,
                          //           title:
                          //               "Your task started, go and complete :)",
                          //           body:
                          //               "${task.title} add to your today to to list",
                          //           scheduledTime: scheduledTimeAtStart,
                          //         );
                          //       }
                          //     }
                          //   }
                          // }



                          

                          