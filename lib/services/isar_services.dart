import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = _initDb();
  }

  Future<Isar> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([TaskSchema], directory: dir.path);
  }

  Future<void> addTask(Task newTask) async {
    final isar = await db;
    await isar.writeTxn(() => isar.tasks.put(newTask));
  }

  Future<List<Task>> getAllTasks() async {
    final isar = await db;
    return await isar.tasks.where().findAll();
  }

  Future<void> deleteTask(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.tasks.delete(id));
  }

  Future<void> toggleTask(Task task) async {
    final isar = await db;
    task.isDone = !task.isDone;
    await isar.writeTxn(() => isar.tasks.put(task));
  }
 Stream<List<Task>> watchTasks() async* {
    final isar = await db;
    yield* isar.tasks.where().watch(fireImmediately: true);
  }

}
