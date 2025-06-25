import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kuraztest/heat_map/heatmap_data_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
//import 'package:kuraztest/notifi_service/noti_service.dart';
import 'draggable_sheet.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';

import '../services/isar_services.dart';

// TimeOfDay? startTime;
// TimeOfDay? endTime;



class TaskList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _isDarkMode = true;
   late Future<Isar> _dbFuture;
  final IsarService isarService = IsarService();

  late final TextEditingController _controller = TextEditingController();
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    tz.initializeTimeZones();
    _dbFuture = _initDb();
  }
  Future<Isar> _initDb() async{
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([TaskSchema], directory: dir.path);
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

 Future<void> _addTask(String title) async {
    final isar  = await _dbFuture;
    final task = Task()
      ..title = title
      ..deadline = DateTime.now();
      await isar.writeTxn(() => isar.tasks.put(task));
  }


  Future<void> _toggleTask(Isar isar, Task task) async{
     task.isDone = !task.isDone;
     await isar.writeTxn(() => isar.tasks.put(task));
  }

  Future<void> _deleteTask(Isar isar, Task task) async {
    await isar.writeTxn(() => isar.tasks.delete(task.id));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: _dbFuture, 
    builder: (context, snapshot) {
       if (!snapshot.hasData) return const CircularProgressIndicator();
        final isar = snapshot.data!;
       return   
         StreamBuilder<List<Task>> (
          stream: isar.tasks.where().watch(fireImmediately: true),
          builder: (context, snapshot) {
     final tasks = snapshot.data ?? [];

       return  MaterialApp(
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
                      final title = _controller.text.trim();
                      if (title.isNotEmpty) {

                        _addTask(title);
                        _controller.clear();
                        
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
                    key: Key(task.id.toString()),
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
                    onDismissed: (_) async{
                      await isarService.deleteTask(task.id);
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
                        onChanged: (_) { 
                          _toggleTask(isar, task);
                        
                          final heatmapDataProvider =
                              Provider.of<HeatmapDataProvider>(
                                context,
                                listen: false,
                              );
                          
                            heatmapDataProvider.markTaskDone(DateTime.now());
                          
                        },

                        activeColor: Colors.green,
                      ),
                      trailing:
                      // task.startTime != null && task.endTime != null
                      //     ? Text(
                      //       '${task.startTime!.hour} - ${task.endTime!.hour}',
                      //     )
                      IconButton(
                        onPressed: () {
                        _deleteTask(isar, task);
                        }, icon: Icon(Icons.timer)),
                    ),
                  );
                },
          )
          ),
          ],
          ),
          )
           );
  },
);
});
}
}
        
    
