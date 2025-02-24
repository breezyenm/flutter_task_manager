import 'package:flutter/material.dart';
import 'package:flutter_task_manager/models/task.dart';
import 'package:flutter_task_manager/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/task_detail_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        minTileHeight: 0,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(
                task: task,
              ),
            ),
          );
        },
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) {
            provider.toggleTaskComplete(task);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description?.isNotEmpty ?? false)
              Text(
                task.description!,
                style: TextStyle(
                  decoration:
                      task.isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
            if (task.dueDate != null) ...[
              const SizedBox(height: 4),
              Builder(builder: (context) {
                final date = task.dueDate!;
                return Text(
                  'Due: ${DateFormat('MMM d, y').format(date)}',
                  style: TextStyle(
                    color: date.isBefore(DateTime.now()) && !task.isCompleted
                        ? Colors.red
                        : Colors.grey,
                  ),
                );
              }),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            provider.deleteTask(task.id);
          },
        ),
      ),
    );
  }
}
