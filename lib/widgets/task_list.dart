import 'package:demo/models1/task.dart';
import 'package:flutter/material.dart';
import 'task_card.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(String) onTaskToggle;
  final Function(Task) onTaskEdit;
  final Function(String) onTaskDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskToggle,
    required this.onTaskEdit,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TaskCard(
            task: task,
            onToggleComplete: () => onTaskToggle(task.id),
            onEdit: () => onTaskEdit(task),
            onDelete: () => _confirmDelete(context, task),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  onTaskDelete(task.id);
                },
                child: const Text('DELETE'),
              ),
            ],
          ),
    );
  }
}
