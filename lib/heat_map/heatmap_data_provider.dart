import 'package:flutter/material.dart';

class HeatmapDataProvider with ChangeNotifier {
  Map<DateTime, int> _data = {};

  Map<DateTime, int> get data => _data;

  // void incrementForToday() {
  //   final today = _normalize(DateTime.now());
  //   _dataset[today] = (_dataset[today] ?? 0) + 1;
  //   notifyListeners();
  // }
  void markTaskDone(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    _data[day] = (_data[day] ?? 0) + 1;
    print('🟢 Task added: $_data'); // Add this line
    notifyListeners();
  }

  // void decrementForToday() {
  //   final today = _normalize(DateTime.now());
  //   if (_dataset.containsKey(today)) {
  //     _dataset[today] = _dataset[today]! - 1;
  //     if (_dataset[today]! <= 0) {
  //       _dataset.remove(today);
  //     }
  //     notifyListeners();
  //   }
  // }

  DateTime _normalize(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
