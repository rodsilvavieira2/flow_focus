import 'package:flutter/material.dart';

class SesssionsCounter extends StatelessWidget {
  final int sessionsCount;
  final int completedSessions;

  const SesssionsCounter({
    super.key,
    required this.sessionsCount,
    required this.completedSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          'Sessions: $completedSessions /$sessionsCount',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
