// void markTaskDone(DateTime date) {
//   final day = DateTime(date.year, date.month, date.day);
//   _data[day] = (_data[day] ?? 0) + 1;
//   print('🟢 Task added: $_data'); // Add this line
//   notifyListeners();
// }

// onChanged: (value) {
//   setState(() {
//     task.isDone = value!;
//   });

//   if (value) {
//     Provider.of<HeatmapDataProvider>(context, listen: false)
//         .markTaskDone(DateTime.now());
//   }
// }

import 'package:flutter/material.dart';

class HeatmapDataProvider extends ChangeNotifier {
  Map<DateTime, int> _data = {};

  Map<DateTime, int> get datasets => _data;

  void markTaskDone(DateTime date) {
    final day = DateTime(date.year, date.month, date.day); // remove time
    _data[day] = (_data[day] ?? 0) + 1;
    notifyListeners();
  }
}

  // bool? showColorTip = true,
  // List<Widget?>? colorTipHelper,
  // int? colorTipCount,
  // double? colorTipSize
