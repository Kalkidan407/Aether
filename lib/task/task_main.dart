import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
// import 'package:kuraztest/notifi_service/noti_service.dart';
import 'draggable_sheet.dart';
import '../models/task.dart';
import '../services/isar_services.dart';
import 'package:intl/intl.dart';
import 'package:chrono_dart/chrono_dart.dart' show Chrono;
// import 'package:kuraztest/gemini_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


// TimeOfDay? startTime;
// TimeOfDay? endTime;
class TaskList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
   
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? 'ERROR ';
  String summaryMessage = "Loading...";
  bool _isDarkMode = true;
  late Future<Isar> _dbFuture;
  final IsarService isarService = IsarService();

  late final TextEditingController _controller = TextEditingController();
  ThemeMode themeMode = ThemeMode.system;
 Completer<String>? _summaryCompleter;


  @override
  void initState() {
    super.initState();
    _requestPermissions();
    tz.initializeTimeZones();
    // loadSummary();
    _dbFuture = _initDb();
    _triggerSummaryLoad();
  }
 
 
  void _triggerSummaryLoad() {
    
    _summaryCompleter?.completeError('Cancelled previous load'); 
    _summaryCompleter = Completer<String>();
    loadSummary().then((msg) {
      if (!_summaryCompleter!.isCompleted) { 
        _summaryCompleter!.complete(msg);
      }
    }).catchError((e) {
      if (!_summaryCompleter!.isCompleted) {
        _summaryCompleter!.completeError(e);
      }
    });
  }

  // final geminiService = GeminiService();
  
  // void _handleTaskInput(String userInput) async{
  //    final extracted = await geminiService.extractDeadline(userInput);
  //    print('Gemini says: $extracted');
  // }

  Future<Isar> _initDb() async{
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([TaskSchema], directory: dir.path);
  }


 
 Future<(int total, int completed )> getTodayTaskStatus() async {
   final now = DateTime.now();
   final start = DateTime(now.year, now.month, now.day);
   final end = start.add(Duration(days: 1));

  //  final isar = Isar.getInstance();
   final isar = await _dbFuture;
   final tasks =  await isar.tasks
   .filter()
   .deadlineBetween(start, end)
   .findAll();
   
   final completed = tasks.where((t) => t.isDone).length;
   return (tasks.length, completed);

 }

Future<String> getMotivationalMessage(int completed, int total) async {
 
  final String prompt = "The user has completed $completed out of $total tasks today. "
                 "Send a short, positive motivational message with aproprate emoji.";

  final url = Uri.parse(
    //'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey'
  'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey',
  );

  final requestBody = {
    "contents":[
      {
        "role":"user",
        "parts":[
           {"text": prompt}
        ]
      }
    ],
    "generationConfig":{
       "temperature": 0.7,
      //"max_output_tokens": 100
    }, 
  };

  try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('🔄 Status Code: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if ( data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty &&
            data['candidates'][0]['content']['parts'][0]['text'] != null) {
          final message = data['candidates'][0]['content']['parts'][0]['text'];
          return message;
        } else {
          print('Error: Unexpected Gemini API response format.');
          return "Couldn't get a message. Try again!";
        }
      } else {
        // Log the error for debugging
        print('Error response from Gemini API: ${response.statusCode} - ${response.body}');
        return "Error fetching message: ${response.statusCode}";
      }
    } catch (e) {
      print('Exception during API call: $e');
      return "Network error or API call failed: ${e.toString()}";
    }

}

  Future<String> loadSummary() async{
    final (total,completed) = await getTodayTaskStatus();
    final msg = await getMotivationalMessage(completed, total);
    print('mdg ${msg}');
   return msg;
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
      _controller.clear();
      
  } 

  Future<void> _toggleTask(Isar isar, Task task) async {
     task.isDone = !task.isDone;
     await isar.writeTxn(() => isar.tasks.put(task));
     _triggerSummaryLoad();
  }

  Future<void> _deleteTask(Isar isar, Task task) async {
    await isar.writeTxn(() => isar.tasks.delete(task.id));
    _triggerSummaryLoad();
  }


  @override
  void dispose() {
    _controller.dispose();
     _summaryCompleter?.completeError('Widget disposed');
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

   
        body: Column(
          children: [
 SizedBox(
    height: 17,
  ),

Container(
  width: 180,
margin: EdgeInsets.only(right: 120),
alignment: Alignment.centerLeft,
  child: FutureBuilder<String>(
                        future: _summaryCompleter?.future, // Use the completer's future
                        builder: (context, summarySnapshot) {
                          if (summarySnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator.adaptive(); // Show loading
                          } else if (summarySnapshot.hasError) {
                            print('Error loading summary: ${summarySnapshot.error}');
                            return Text(
                              'Error: ${summarySnapshot.error.toString().split(':')[0]}', // Display a simplified error
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.red),
                            );
                          } else if (summarySnapshot.hasData) {
                            return Text(
                              summarySnapshot.data!,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                            );
                          }
                          return const Text(
                            "Loading...", // Default state if no data/error yet
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                          );
                        },
                      ),

  
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
// _handleTaskInput(title);
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
  child: 
  Text('Added Tasks',   
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
                     },
                        activeColor: Colors.green,
                      ),
                      
                trailing: GestureDetector(
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
        
    
