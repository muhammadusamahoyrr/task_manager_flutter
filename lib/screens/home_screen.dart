import 'package:demo/models1/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/empty_list_placeholder.dart';
import '../widgets/task_list.dart';
import '../widgets/stats_card.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              const SizedBox(height: 8),
              StatsCard(
                totalTasks: taskProvider.totalTasks,
                completedTasks: taskProvider.completedTasksCount,
                pendingTasks: taskProvider.pendingTasksCount,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Pending tasks
                    taskProvider.pendingTasks.isEmpty
                        ? const EmptyListPlaceholder(
                            icon: Icons.task_alt,
                            message: 'No pending tasks',
                            subMessage: 'Add a new task to get started',
                          )
                        : TaskList(
                            tasks: taskProvider.pendingTasks,
                            onTaskToggle: taskProvider.toggleTaskCompletion,
                            onTaskEdit: (task) => _navigateToTaskForm(context, task),
                            onTaskDelete: taskProvider.deleteTask,
                          ),
                    // Completed tasks
                    taskProvider.completedTasks.isEmpty
                        ? const EmptyListPlaceholder(
                            icon: Icons.done_all,
                            message: 'No completed tasks',
                            subMessage: 'Complete a task to see it here',
                          )
                        : TaskList(
                            tasks: taskProvider.completedTasks,
                            onTaskToggle: taskProvider.toggleTaskCompletion,
                            onTaskEdit: (task) => _navigateToTaskForm(context, task),
                            onTaskDelete: taskProvider.deleteTask,
                          ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToTaskForm(BuildContext context, [Task? task]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete all tasks'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, 'all');
                },
              ),
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Delete completed tasks'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, 'completed');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${type == 'all' ? 'all' : 'completed'} tasks?'),
        content: Text(
          'Are you sure you want to delete ${type == 'all' ? 'all' : 'completed'} tasks? This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (type == 'all') {
                Provider.of<TaskProvider>(context, listen: false).deleteAllTasks();
              } else {
                Provider.of<TaskProvider>(context, listen: false).deleteCompletedTasks();
              }
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
}