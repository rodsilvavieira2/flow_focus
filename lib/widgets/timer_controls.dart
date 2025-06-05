import 'package:flutter/material.dart';

class TimeControls extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onRestart;
  final VoidCallback onSkip;
  final bool isRunning;

  const TimeControls({
    super.key,
    required this.onPause,
    required this.onRestart,
    required this.onStart,
    required this.isRunning,
    required this.onSkip,
  });

  final double _iconSize = 38;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRunning
            ? IconButton.filledTonal(
                onPressed: onPause,
                icon: Icon(Icons.pause),
                iconSize: _iconSize,
                tooltip: 'Pause',
              )
            : IconButton.filledTonal(
                onPressed: onStart,
                icon: Icon(Icons.play_arrow),
                iconSize: _iconSize,
                tooltip: 'Start',
              ),

        const SizedBox(width: 12),

        IconButton.filledTonal(
          onPressed: isRunning ? null : onSkip,
          icon: Icon(Icons.skip_next),
          iconSize: _iconSize,
          tooltip: isRunning ? 'Wait for completion or pause' : 'Skip step',
        ),

        const SizedBox(width: 12),

        IconButton.filledTonal(
          onPressed: onRestart,
          icon: Icon(Icons.restart_alt),
          iconSize: _iconSize,
          tooltip: 'Restart',
        ),
      ],
    );
  }
}
