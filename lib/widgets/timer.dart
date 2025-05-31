import 'package:flutter/material.dart';

class Timer extends StatelessWidget {
  final Duration duration;
  const Timer({super.key, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(duration),
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 74,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
