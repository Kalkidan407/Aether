import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:kuraztest/notifi_service/noti_service.dart';
import 'package:kuraztest/todoapp/todoapp.dart';

class Task {
  String title;
  bool isDone;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Task(this.title, {this.isDone = false, this.startTime, this.endTime});
}

class TaskList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _isDarkMode = false;
  final List<Task> tasks = [];
  final TextEditingController _controller = TextEditingController();
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    tz.initializeTimeZones();
  }

  void _requestPermissions() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title));
      _controller.clear();
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          _isDarkMode
              ? ThemeData.dark(useMaterial3: true)
              : ThemeData.light(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'To-Do-List',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
          ],
        ),
        floatingActionButton: IconButton(
          onPressed: () {},
          icon: Icon(Icons.settings),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(38.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        labelText: 'Add a task',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        addTask(_controller.text.trim());
                      }
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm'),
                            iconColor: Colors.amberAccent,
                            content: Text(
                              'Are you sure you want to delete : ${task.title} ?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),

                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      setState(() {
                        tasks.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(' You delete, [ ${task.title} ] '),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    },
                    // confirmDismiss:,
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15.0,
                          decoration:
                              task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => toggleTask(index),
                        activeColor: Colors.green,
                        shape: CircleBorder(),
                      ),
                      trailing:
                          task.startTime != null && task.endTime != null
                              ? Text(
                                '${task.startTime!.format(context)} - ${task.endTime!.format(context)}',
                              )
                              : IconButton(
                                onPressed: () async {
                                  final pickedStart = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    helpText: 'Pick Start Time',
                                    initialEntryMode: TimePickerEntryMode.input,
                                  );

                                  if (pickedStart != null) {
                                    final pickedEnd = await showTimePicker(
                                      context: context,
                                      initialTime: pickedStart,
                                      helpText: 'Pick End Time',
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                    );

                                    if (pickedEnd != null) {
                                      setState(() {
                                        task.startTime = pickedStart;
                                        task.endTime = pickedEnd;
                                      });

                                      if (!task.isDone) {
                                        final now = DateTime.now();

                                        final scheduledTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedEnd.hour,
                                          pickedEnd.minute,
                                        );

                                        final scheduledTimeAtStart = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          pickedStart.hour,
                                          pickedStart.minute,
                                        );
                                        final duration = scheduledTime
                                            .difference(now);

                                        if (duration.inSeconds > 0) {
                                          final half = now.add(duration * 0.5);
                                          final threeQuarter = now.add(
                                            duration * 0.75,
                                          );

                                          await NotiService().scheduleNotification(
                                            id: task.title.hashCode + 2,
                                            title: "Reminder",
                                            body:
                                                "Halfway to deadline: ${task.title}",
                                            scheduledTime: half,
                                          );

                                          await NotiService().scheduleNotification(
                                            id: task.title.hashCode + 3,
                                            title: "Almost due!",
                                            body:
                                                "75% time passed for task: ${task.title}",
                                            scheduledTime: threeQuarter,
                                          );

                                          await NotiService().scheduleNotification(
                                            id: task.title.hashCode + 1,
                                            title: "new task add",
                                            body:
                                                "${task.title} add to your today to to list",
                                            scheduledTime: scheduledTimeAtStart,
                                          );
                                        }
                                      }
                                    }
                                  }
                                },
                                icon: Icon(Icons.timer),
                              ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
