import 'package:flutter/material.dart';
import 'package:flutter_task_manager/models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(Task) toggleTaskComplete;
  final Function(String) deleteTask;

  const TaskCard({
    super.key,
    required this.task,
    required this.toggleTaskComplete,
    required this.deleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => toggleTaskComplete(task),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle:
          task.description?.isNotEmpty == true ? Text(task.description!) : null,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => deleteTask(task.id),
      ),
    );
  }
}
