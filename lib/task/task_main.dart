import 'package:flutter/material.dart';
import 'package:kuraztest/heat_map/heatmap_data_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:kuraztest/notifi_service/noti_service.dart';
import 'draggable_sheet.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';

TimeOfDay? startTime;
TimeOfDay? endTime;

class TaskList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _isDarkMode = true;
  final List<Task> tasks = [];
  late final TextEditingController _controller = TextEditingController();
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

  String capitalize(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1);
  }

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title));
      _controller.clear();
      _controller.clearComposing();
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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            'Aether',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
              ),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
            IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          ],
        ),

        floatingActionButton: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 53, 7, 127),
            onPressed: () => showDraggableSheet(context),
            child: Icon(Icons.grid_view, size: 30, color: Colors.white),
          ),
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
                            iconColor: const Color.fromARGB(255, 241, 226, 172),
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
                        capitalize(task.title),
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
                        onChanged: (value) {
                          setState(() {
                            task.isDone = value!;
                          });
                          final heatmapDataProvider =
                              Provider.of<HeatmapDataProvider>(
                                context,
                                listen: false,
                              );
                          if (value!) {
                            heatmapDataProvider.markTaskDone(DateTime.now());
                          }
                        },

                        activeColor: Colors.green,
                      ),
                      trailing:
                      // task.startTime != null && task.endTime != null
                      //     ? Text(
                      //       '${task.startTime!.hour} - ${task.endTime!.hour}',
                      //     )
                      IconButton(
                        onPressed: () async {
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
