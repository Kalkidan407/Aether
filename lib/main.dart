import 'package:flutter/material.dart';
import 'package:kuraztest/task/task_main.dart';
// import 'package:kuraztest/notifi_service/noti_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

Future<void> main() async {
     
  WidgetsFlutterBinding.ensureInitialized();
  // await NotiService().initNotifiaction;
  
//await dotenv.load(fileName: ".env");
await dotenv.load();




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return
       MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskList()
    
  );
 }
}
