import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kuraztest/task/task.dart';
import 'package:kuraztest/notifi_service/noti_service.dart';
import 'package:kuraztest/heat_map/heatmap_data_provider.dart'; // 👈 import your provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotiService().initNotifiaction;

  runApp(
    ChangeNotifierProvider(
      create: (_) => HeatmapDataProvider(), // 👈 your provider here
      child: MaterialApp(debugShowCheckedModeBanner: false, home: TaskList()),
    ),
  );
}
