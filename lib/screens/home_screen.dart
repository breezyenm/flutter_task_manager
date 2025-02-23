import 'package:flutter/material.dart';
import 'package:flutter_task_manager/widgets/task_card.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../services/notification_service.dart';
import '../widgets/add_task_sheet.dart';

class HomeScreen extends StatefulWidget {
  final TaskRepository taskRepository;
  final NotificationService notificationService;

  const HomeScreen({
    super.key,
    required this.taskRepository,
    required this.notificationService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = widget.taskRepository.getAllTasks();
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
  Widget build(BuildContext context) {
    final completedTasks = _tasks.where((task) => task.isCompleted).length;
    final pendingTasks = _tasks.length - completedTasks;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _tasks = widget.taskRepository.getAllTasks();
          });
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text(
              'Task Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Pending',
                    value: pendingTasks.toString(),
                    color: Colors.orange,
                    // icon: Icons.pending_actions,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Completed',
                    value: completedTasks.toString(),
                    color: Colors.green,
                    // icon: Icons.task_alt,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length > 5 ? 5 : _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskCard(
                  task: task,
                  toggleTaskComplete: _toggleTaskComplete,
                  deleteTask: _deleteTask,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  // final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    // required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Icon(
            //   icon,
            //   color: color,
            //   size: 32,
            // ),
            // const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
