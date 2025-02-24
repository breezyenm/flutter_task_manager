import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import 'styled_text_field.dart';
import 'styled_button.dart';

class AddTaskSheet extends StatefulWidget {
  final Function(Task) onTaskCreated;

  const AddTaskSheet({
    super.key,
    required this.onTaskCreated,
  });

  static Future<void> show(BuildContext context,
      {required Function(Task) onTaskCreated}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddTaskSheet(
        onTaskCreated: onTaskCreated,
      ),
    );
  }

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  DateTime? selectedDueDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          const Text(
            'Add New Task',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          StyledTextField(
            controller: titleController,
            label: 'Title',
            hintText: 'Enter task title',
            autofocus: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a task title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          StyledTextField(
            controller: descriptionController,
            label: 'Description',
            hintText: 'Enter task description',
            maxLines: 3,
            contentPadding: const EdgeInsets.all(12),
          ),
          const SizedBox(height: 16),
          StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Due Date',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => selectedDueDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: ShapeDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDueDate != null
                                ? DateFormat('MMM dd, yyyy')
                                    .format(selectedDueDate!)
                                : 'Select due date',
                            style: TextStyle(
                              color: selectedDueDate != null
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(
                                        alpha: 0.36,
                                      ),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(
                                alpha: 0.36,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          SafeArea(
            minimum: MediaQuery.of(context).viewInsets,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StyledButton(
                  text: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  text: 'Save',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final task = Task(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim(),
                          createdAt: DateTime.now(),
                          dueDate: selectedDueDate
                          // uncomment below to automatically set due date to 5 minutes if not set
                          // ?? DateTime.now().add(Duration(minutes: 5)),
                          );

                      widget.onTaskCreated(task);
                      Navigator.pop(context);
                    }
                  },
                  isPrimary: true,
                  formKey: formKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
