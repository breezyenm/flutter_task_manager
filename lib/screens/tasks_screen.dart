import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/task_card.dart';
import '../services/notification_service.dart';
import '../widgets/add_task_sheet.dart';
import '../providers/task_provider.dart';

class TasksScreen extends StatefulWidget {
  final NotificationService notificationService;

  const TasksScreen({
    super.key,
    required this.notificationService,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    Provider.of<TaskProvider>(context, listen: false)
        .setSearchQuery(_searchController.text);
  }

  Future<void> _addTask() async {
    await AddTaskSheet.show(
      context,
      onTaskCreated: (task) async {
        await Provider.of<TaskProvider>(context, listen: false).addTask(task);
        await widget.notificationService.scheduleTaskReminder(
          task.id,
          task.title,
          task.dueDate,
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                final tasks = taskProvider.tasks;
                if (tasks.isEmpty) {
                  return Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'No tasks yet'
                          : 'No tasks found',
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                    );
                  },
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
