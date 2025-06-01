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

  final double _iconSize = 32;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRunning
            ? IconButton.filled(
                onPressed: onPause,
                icon: Icon(Icons.pause),
                iconSize: _iconSize,
                tooltip: 'Pausar',
              )
            : IconButton.filled(
                onPressed: onStart,
                icon: Icon(Icons.play_arrow),
                iconSize: _iconSize,
                tooltip: 'Iniciar',
              ),

        const SizedBox(width: 12),

        IconButton.filled(
          onPressed: isRunning ? null : onSkip,
          icon: Icon(Icons.skip_next),
          iconSize: _iconSize,
          tooltip: isRunning ? 'Aguarde o término ou pause' : 'Pular etapa',
        ),

        const SizedBox(width: 12),

        IconButton.filled(
          onPressed: onRestart,
          icon: Icon(Icons.restart_alt),
          iconSize: _iconSize,
          tooltip: 'Reiniciar',
        ),
      ],
    );
  }
}
