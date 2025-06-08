// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// import 'package:kuraztest/notifi_service/noti_service.dart';
// import 'package:kuraztest/todoapp/todoapp.dart';

// class Task {
//   String title;
//   bool isDone;
//   TimeOfDay? startTime;
//   TimeOfDay? endTime;

//   Task(this.title, {this.isDone = false, this.startTime, this.endTime});
// }

// class TaskList extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _TaskListState();
// }

// class _TaskListState extends State<TaskList> {
//   bool _isDarkMode = false;
//   final List<Task> tasks = [];
//   final TextEditingController _controller = TextEditingController();
//   ThemeMode themeMode = ThemeMode.system;

//   void addTask(String title) {
//     setState(() {
//       tasks.add(Task(title));
//       _controller.clear();
//     });
//   }

//   void toggleTask(int index) async {
//     setState(() {
//       tasks[index].isDone = !tasks[index].isDone;
//     });

//     final task = tasks[index];
//     if (task.isDone) {
//       // Cancel all 3 notifications when task is marked as done
//       await NotiService().cancelNotification(task.title.hashCode);
//       await NotiService().cancelNotification(task.title.hashCode + 1);
//       await NotiService().cancelNotification(task.title.hashCode + 2);
//     }
//   }

//   void deleteTask(int index) {
//     setState(() {
//       tasks.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme:
//           _isDarkMode
//               ? ThemeData.dark(useMaterial3: true)
//               : ThemeData.light(useMaterial3: true),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'To-Do-List',
//             style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//           ),
//           actions: [
//             IconButton(
//               icon: Icon(_isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
//               onPressed: () {
//                 setState(() {
//                   _isDarkMode = !_isDarkMode;
//                 });
//               },
//             ),
//           ],
//         ),
//         floatingActionButton: IconButton(
//           onPressed: () {},
//           icon: Icon(Icons.settings),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(38.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: const InputDecoration(
//                         labelText: 'Add a task',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       if (_controller.text.trim().isNotEmpty) {
//                         addTask(_controller.text.trim());
//                       }
//                     },
//                     icon: Icon(Icons.add),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = tasks[index];
//                   return Dismissible(
//                     key: UniqueKey(),
//                     onDismissed: (direction) {
//                       setState(() {
//                         tasks.removeAt(index);
//                       });

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('You deleted [ ${task.title} ]'),
//                           backgroundColor: Colors.redAccent,
//                         ),
//                       );
//                     },
//                     background: Container(
//                       color: Colors.red,
//                       child: Icon(Icons.delete),
//                     ),
//                     child: ListTile(
//                       title: Text(
//                         task.title,
//                         style: TextStyle(
//                           fontSize: 15.0,
//                           decoration:
//                               task.isDone
//                                   ? TextDecoration.lineThrough
//                                   : TextDecoration.none,
//                         ),
//                       ),
//                       leading: Checkbox(
//                         value: task.isDone,
//                         onChanged: (_) => toggleTask(index),
//                         activeColor: Colors.green,
//                         shape: CircleBorder(),
//                       ),
//                       trailing:
//                           task.startTime != null && task.endTime != null
//                               ? Text(
//                                 '${task.startTime!.format(context)} - ${task.endTime!.format(context)}',
//                               )
//                               : IconButton(
//                                 onPressed: () async {
//                                   final pickedStart = await showTimePicker(
//                                     context: context,
//                                     initialTime: TimeOfDay.now(),
//                                     helpText: 'Pick Start Time',
//                                     initialEntryMode: TimePickerEntryMode.input,
//                                   );

//                                   if (pickedStart != null) {
//                                     final pickedEnd = await showTimePicker(
//                                       context: context,
//                                       initialTime: pickedStart,
//                                       helpText: 'Pick End Time',
//                                       initialEntryMode:
//                                           TimePickerEntryMode.input,
//                                     );

//                                     if (pickedEnd != null) {
//                                       setState(() {
//                                         task.startTime = pickedStart;
//                                         task.endTime = pickedEnd;
//                                       });

//                                       // Schedule 3 notifications if task is not done
//                                       if (!task.isDone) {
//                                         final now = DateTime.now();
//                                         final deadline = DateTime(
//                                           now.year,
//                                           now.month,
//                                           now.day,
//                                           pickedEnd.hour,
//                                           pickedEnd.minute,
//                                         );

//                                         final duration = deadline.difference(
//                                           now,
//                                         );
//                                         if (duration.inSeconds > 0) {
//                                           final half = now.add(
//                                             Duration(
//                                               seconds:
//                                                   (duration.inSeconds * 0.5)
//                                                       .round(),
//                                             ),
//                                           );
//                                           final threeQuarter = now.add(
//                                             Duration(
//                                               seconds:
//                                                   (duration.inSeconds * 0.75)
//                                                       .round(),
//                                             ),
//                                           );

//                                           await NotiService().scheduleNotification(
//                                             id: task.title.hashCode,
//                                             title: "Reminder",
//                                             body:
//                                                 "Halfway to deadline: ${task.title}",
//                                             scheduledTime: half,
//                                           );
//                                           await NotiService().scheduleNotification(
//                                             id: task.title.hashCode + 1,
//                                             title: "Almost due!",
//                                             body:
//                                                 "75% time passed for task: ${task.title}",
//                                             scheduledTime: threeQuarter,
//                                           );
//                                           await NotiService().scheduleNotification(
//                                             id: task.title.hashCode + 2,
//                                             title: "You missed the task",
//                                             body:
//                                                 "Reschedule the task: ${task.title}",
//                                             scheduledTime: deadline,
//                                           );
//                                         }
//                                       }
//                                     }
//                                   }
//                                 },
//                                 icon: Icon(Icons.timer),
//                               ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
