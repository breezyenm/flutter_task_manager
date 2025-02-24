import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;
  List<Task> _tasks = [];
  String _searchQuery = '';

  TaskProvider(this._repository) {
    _loadTasks();
  }

  List<Task> get tasks => _searchQuery.isEmpty
      ? _tasks
      : _tasks.where((task) =>
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true).toList();

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void _loadTasks() {
    _tasks = _repository.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);
    _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);
    _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    _loadTasks();
  }

  Future<void> toggleTaskComplete(Task task) async {
    task.isCompleted = !task.isCompleted;
    await updateTask(task);
  }

  Task? getTask(String id) {
    return _repository.getTask(id);
  }
}
