
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:kuraztest/task/task_main.dart';
import 'package:kuraztest/notifi_service/noti_service.dart';
import 'package:kuraztest/heat_map/heatmap_data_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotiService().initNotifiaction;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HeatmapDataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskList(),
      ),
    );
  }
}
