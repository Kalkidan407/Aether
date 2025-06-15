import 'package:flutter/material.dart';

import 'package:kuraztest/task/task.dart';

import 'package:kuraztest/notifi_service/noti_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotiService().initNotifiaction;
  //   await NotiService().initNotifiaction();
  // tz.initializeTimeZones();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskList(), // or whatever your main widget is
    ),
  );
}
