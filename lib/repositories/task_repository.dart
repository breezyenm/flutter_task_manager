import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class TaskRepository {
  static const String _boxName = 'tasks';
  late Box<Task> _taskBox;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    _taskBox = await Hive.openBox<Task>(_boxName);
  }

  Future<void> addTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }

  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  Task? getTask(String id) {
    return _taskBox.get(id);
  }
}
