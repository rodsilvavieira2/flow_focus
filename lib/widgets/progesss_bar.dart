import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double percent;

  const ProgressBar({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.width * 0.20;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Tempo restando"), Text(_getPercentText())],
          ),
          SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300),
            tween: Tween<double>(begin: 0, end: percent),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 16,
                borderRadius: BorderRadius.circular(8),
              );
            },
          ),
        ],
      ),
    );
  }

  _getPercentText() {
    if (percent == 0) return "0%";
    var percentText = (percent * 100).toStringAsFixed(0);

    return "$percentText%";
  }
}
