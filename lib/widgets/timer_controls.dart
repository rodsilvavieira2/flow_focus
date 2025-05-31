import 'package:flutter/material.dart';

class TimeControls extends StatelessWidget {
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onRestart;

  const TimeControls({
    super.key,
    required this.onPause,
    required this.onRestart,
    required this.onStart,
  });

  final double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          onPressed: onStart,
          icon: Icon(Icons.play_arrow),
          iconSize: _iconSize,
        ),

        const SizedBox(width: 12),

        IconButton.filled(
          onPressed: onStart,
          icon: Icon(Icons.pause),
          iconSize: _iconSize,
        ),

        const SizedBox(width: 12),

        IconButton.filled(
          onPressed: onStart,
          icon: Icon(Icons.restart_alt),
          iconSize: _iconSize,
        ),
      ],
    );
  }
}
