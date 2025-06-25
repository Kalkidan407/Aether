import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/heat_entry.dart';

class HeatmapDataProvider with ChangeNotifier {
  late Future<Isar> _dbFuture;
  Map<DateTime, int> _data = {};

  Map<DateTime, int> get data => _data;

  HeatmapDataProvider() {
    _dbFuture = _initDb();
    _loadFromDb();
  }

  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([HeatEntrySchema], directory: dir.path);
  }

  Future<void> _loadFromDb() async {
    final isar = await _dbFuture;
    final entries = await isar.heatEntrys.where().findAll();

    _data = {
      for (var e in entries)
        DateTime(e.date.year, e.date.month, e.date.day): e.count,
    };

    notifyListeners();
  }

  Future<void> markTaskDone(DateTime date) async {
    final isar = await _dbFuture;
    final normalized = DateTime(date.year, date.month, date.day);

    final existing = await isar.heatEntrys.filter().dateEqualTo(normalized).findFirst();

    await isar.writeTxn(() async {
      if (existing != null) {
        existing.count += 1;
        await isar.heatEntrys.put(existing);
      } else {
        await isar.heatEntrys.put(
          HeatEntry()
            ..date = normalized
            ..count = 1,
        );
      }
    });

    _data[normalized] = (_data[normalized] ?? 0) + 1;
    notifyListeners();
  }
}
