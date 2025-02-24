import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../widgets/styled_text_field.dart';
import '../providers/task_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime? _selectedDueDate;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');
    _selectedDueDate = widget.task.dueDate;
    _isCompleted = widget.task.isCompleted;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }

    final updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      createdAt: widget.task.createdAt,
      isCompleted: _isCompleted,
      dueDate: _selectedDueDate,
    );

    await Provider.of<TaskProvider>(context, listen: false)
        .updateTask(updatedTask);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledTextField(
              controller: _titleController,
              label: 'Title',
              hintText: 'Enter task title',
            ),
            const SizedBox(height: 16),
            StyledTextField(
              controller: _descriptionController,
              label: 'Description',
              hintText: 'Enter task description',
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Due Date: ${_selectedDueDate != null ? DateFormat('MMM dd, yyyy').format(_selectedDueDate!) : 'Not set'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => _selectedDueDate = date);
                    }
                  },
                  child: Text(_selectedDueDate == null ? 'Set Date' : 'Change'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Completed',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 16),
                Switch(
                  value: _isCompleted,
                  onChanged: (value) => setState(() => _isCompleted = value),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Created on ${DateFormat('MMM dd, yyyy HH:mm').format(widget.task.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
