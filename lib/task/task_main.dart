import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
//import 'package:kuraztest/notifi_service/noti_service.dart';
import 'draggable_sheet.dart';

import '../models/task.dart';

import '../services/isar_services.dart';
import 'package:intl/intl.dart';
import 'package:chrono_dart/chrono_dart.dart' show Chrono;
import 'package:kuraztest/gemini_service.dart';

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

  final geminiService = GeminiService();
  void _handleTaskInput(String userInput) async{
     final extracted = await geminiService.extractDeadline(userInput);
     print('Gemini says: $extracted');
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
    DateTime? deadline = Chrono.parseDate(title);
   // DateTime deadline = DateTime.now();

if(deadline == null) {
  deadline = await showDatePicker(
    context: context,
     firstDate: DateTime.now().subtract(const Duration(days: 1)), 
     lastDate: DateTime.now().add(const Duration(days: 365)),
     
     );

  // final parsed = result.first;
  if( deadline == null) return;
}

    final task = Task()
      ..title = title
      ..deadline = deadline;
      await isar.writeTxn(() => isar.tasks.put(task));
      
  } 

  Future<void> _toggleTask(Isar isar, Task task) async {
     task.isDone = !task.isDone;
     await isar.writeTxn(() => isar.tasks.put(task));
     
  }

  Future<void> _deleteTask(Isar isar, Task task) async {
    await isar.writeTxn(() => isar.tasks.delete(task.id));
  }

  Future<void> _isOverDue(Isar isar, Task task) async {
  //  final delete = await isar.writeTxn(() => isar.tasks.delete(task.id));
DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
    final isar = Isar.getInstance(); // or use your isar service
    final completedTasks = await isar!.tasks
        .filter()
        .isDoneEqualTo(true)
        .findAll();
  final date = _normalizeDate(task.startTime ?? task.deadline ?? DateTime.now()); 
     if (date.isBefore(DateTime.now()) || date.isAtSameMomentAs(DateTime.now())) {
      isar.tasks;
}


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
          

           IconButton(
            // backgroundColor: Color.fromARGB(255, 53, 7, 127),
            onPressed: () => showDraggableSheet(context),
            icon:  Icon(Icons.analytics_outlined, size: 22, ),
          ),
          ],
        ),

        // floatingActionButton: SizedBox(
        //   height: 60,
        //   width: 60,
        //   child: FloatingActionButton(
        //     backgroundColor: Color.fromARGB(255, 53, 7, 127),
        //     onPressed: () => showDraggableSheet(context),
        //     child: Icon(Icons.grid_view, size: 30, color: Colors.white),
        //   ),
        // ),

        body: Column(
          children: [
 SizedBox(
    height: 7,
  ),

Container(
  width: 180,
margin: EdgeInsets.only(right: 120),
alignment: Alignment.centerLeft,
  child: Text('You have ${tasks.length} tasks this  week 👍',   
   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900 )
  )
  
  ),

 

            Padding(
              padding: EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(
                    child: 
                   Row( 
                    children: [
                
                   Expanded( 
                     
                     child:  TextField (
                      textAlign: TextAlign.start,
                      controller: _controller,
                      decoration: const InputDecoration (
                        labelText: ' e.g. Finish report this Friday',
                        border: OutlineInputBorder(),
                      ),
                     onSubmitted: (_) {
                       final title = _controller.text.trim();
_handleTaskInput(title);
                             if (title.isNotEmpty) {

                        _addTask(title);
                        _controller.clear();
                        
                      }
                     }
                      
                    ),
                    
                    
                    )
                ])
                  ),
                
                ],
              ),
            ),

            SizedBox(height: 2,),


 SizedBox(height: 16,),

  Container(
  width: 180,
margin: EdgeInsets.only(right: 120),
alignment: Alignment.centerLeft,
  child: Text('Added Tasks',   
   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900 )
  )
  
  ),
  SizedBox(height: 3),

          Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {

                  final task = tasks[index];

                  return Dismissible (
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

                    child: 
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8,horizontal: 25),
                      decoration: BoxDecoration(
                   
    shape: BoxShape.rectangle, // similar to CircleAvatar
    border: Border.all(color: const Color.fromARGB(168, 86, 87, 86)),
  
                      ),
                   child:  ListTile(
                     selectedColor: Colors.green,
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
                        
                        onChanged: (value)  async{

                        
                        await   _toggleTask( isar, task);
                          
                        // final heatmapDataProvider =
                        //       Provider.of<HeatmapDataProvider>(
                        //         context,
                        //         listen: false,
                        //       );
                        //  heatmapDataProvider;
                          },
                        activeColor: Colors.green,
                      ),


                      
                trailing: 
                
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context, 
                    firstDate: DateTime.now().subtract(Duration(days: 365)), 
                    lastDate: DateTime.now().add(Duration(days: 365*5)),
                    );
                    if(picked != null && picked != task.deadline){
                      final Isar = await _dbFuture;
                      task.deadline = picked;
                      await isar.writeTxn(() => isar.tasks.put(task));
                      setState(() {
                        
                      });

                    }
                  },
                  child: Text(
        ' ${DateFormat('EEE, MMM d').format(task.deadline)}',
        style: const TextStyle(fontSize: 13),
      ),
                )
           

                    ),
                  ));
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
        
    
