import 'package:flutter/material.dart';
import 'package:flutter_task_manager/widgets/task_card.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../widgets/add_task_sheet.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatelessWidget {
  final NotificationService notificationService;

  const HomeScreen({
    super.key,
    required this.notificationService,
  });

  Future<void> _addTask(BuildContext context) async {
    await AddTaskSheet.show(
      context,
      onTaskCreated: (task) async {
        await Provider.of<TaskProvider>(context, listen: false).addTask(task);
        await notificationService.scheduleTaskReminder(
          task.id,
          task.title,
          task.dueDate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // No need to manually refresh as Provider will handle updates
        },
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            final tasks = taskProvider.tasks;
            final completedTasks =
                tasks.where((task) => task.isCompleted).length;
            final pendingTasks = tasks.length - completedTasks;

            return ListView(
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
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'Completed',
                        value: completedTasks.toString(),
                        color: Colors.green,
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
                const SizedBox(height: 16),
                if (tasks.isEmpty)
                  const Center(
                    child: Text('No tasks yet'),
                  )
                else
                  ...tasks.take(5).map((task) => TaskCard(
                        task: task,
                      )),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(
            alpha: 0.5,
          ),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
