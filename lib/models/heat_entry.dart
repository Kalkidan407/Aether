// import 'package:isar/isar.dart';

// part 'heat_entry.g.dart';

// @collection
// class HeatEntry {
//   Id id = Isar.autoIncrement;

//   @Index(unique: true)
//   late DateTime date;

//   late int count =1;
// }

import 'package:isar/isar.dart';

part 'heat_entry.g.dart';

@collection
class HeatEntry {
  Id id = Isar.autoIncrement;

  late DateTime date;
  int count = 1;
}
