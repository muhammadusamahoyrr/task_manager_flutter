import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;

  const StatsCard({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      const Color(0xFF2C3E50),
                      const Color(0xFF1A2530),
                    ]
                  : [
                      // ignore: deprecated_member_use
                      theme.colorScheme.primary.withOpacity(0.8),
                      theme.colorScheme.primary,
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Statistics',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context: context,
                    icon: Icons.task_alt,
                    value: totalTasks,
                    label: 'Total',
                    color: Colors.white,
                  ),
                  _buildStatItem(
                    context: context,
                    icon: Icons.check_circle,
                    value: completedTasks,
                    label: 'Completed',
                    color: Colors.green.shade300,
                  ),
                  _buildStatItem(
                    context: context,
                    icon: Icons.pending_actions,
                    value: pendingTasks,
                    label: 'Pending',
                    color: Colors.orange.shade300,
                  ),
                ],
              ),
              if (totalTasks > 0) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                  // ignore: deprecated_member_use
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade300),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                Text(
                  '${((completedTasks / totalTasks) * 100).toStringAsFixed(0)}% completed',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}