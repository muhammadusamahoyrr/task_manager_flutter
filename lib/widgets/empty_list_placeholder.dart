import 'package:flutter/material.dart';

class EmptyListPlaceholder extends StatelessWidget {
  final IconData icon;
  final String message;
  final String subMessage;

  const EmptyListPlaceholder({
    super.key,
    required this.icon,
    required this.message,
    required this.subMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            // ignore: deprecated_member_use
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.titleLarge?.copyWith(
              // ignore: deprecated_member_use
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              // ignore: deprecated_member_use
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}