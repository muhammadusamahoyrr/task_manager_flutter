import 'package:demo/models1/task.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

// import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: task.isCompleted ? Colors.grey.shade300 : task.priority.color,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox for marking task as complete
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => onToggleComplete(),
                    activeColor: task.priority.color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Task title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: textTheme.titleLarge?.copyWith(
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: textTheme.bodyMedium?.copyWith(
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted ? Colors.grey : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Priority indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: task.priority.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.flag,
                        color: task.priority.color,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.priority.name,
                        style: TextStyle(
                          color: task.priority.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            const Divider(height: 8),
            
            // Bottom section with dates and action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Created and due dates
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Created date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Created: ${DateFormat('MMM d, yyyy').format(task.createdAt)}',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    
                    // Due date (if set)
                    if (task.dueDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.alarm,
                            size: 14,
                            color: _isDueDatePassed() ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Due: ${DateFormat('MMM d, yyyy').format(task.dueDate!)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: _isDueDatePassed() ? Colors.red : Colors.grey,
                              fontWeight: _isDueDatePassed() ? FontWeight.bold : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                
                // Action buttons
                Row(
                  children: [
                    // Edit button
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit',
                      iconSize: 20,
                      color: Colors.blue,
                    ),
                    
                    // Delete button
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete',
                      iconSize: 20,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _isDueDatePassed() {
    if (task.dueDate == null) return false;
    final now = DateTime.now();
    return task.dueDate!.isBefore(DateTime(now.year, now.month, now.day)) && !task.isCompleted;
  }
}