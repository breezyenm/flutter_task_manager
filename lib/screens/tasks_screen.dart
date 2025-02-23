import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_manager/widgets/task_card.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../services/notification_service.dart';
import '../widgets/add_task_sheet.dart';

class TasksScreen extends StatefulWidget {
  final TaskRepository taskRepository;
  final NotificationService notificationService;

  const TasksScreen({
    super.key,
    required this.taskRepository,
    required this.notificationService,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late List<Task> _tasks;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _tasks = widget.taskRepository.getAllTasks();
  }

  _onSearchChanged() {
    setState(() {});
  }

  Future<void> _addTask() async {
    await AddTaskSheet.show(
      context,
      onTaskCreated: (task) async {
        await widget.taskRepository.addTask(task);
        await widget.notificationService.scheduleTaskReminder(
          task.id,
          task.title,
          task.dueDate,
        );
        setState(() {
          _tasks = widget.taskRepository.getAllTasks();
        });
      },
    );
  }

  Future<void> _deleteTask(String id) async {
    await widget.taskRepository.deleteTask(id);
    setState(() {
      _tasks = widget.taskRepository.getAllTasks();
    });
  }

  Future<void> _toggleTaskComplete(Task task) async {
    task.isCompleted = !task.isCompleted;
    await widget.taskRepository.updateTask(task);
    setState(() {
      _tasks = widget.taskRepository.getAllTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tasks = widget.taskRepository
        .getAllTasks()
        .where((task) =>
            task.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            task.description
                    ?.toLowerCase()
                    .contains(_searchController.text.toLowerCase()) ==
                true)
        .toList();
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CupertinoSearchTextField(
              controller: _searchController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskCard(
                  task: task,
                  toggleTaskComplete: _toggleTaskComplete,
                  deleteTask: _deleteTask,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
