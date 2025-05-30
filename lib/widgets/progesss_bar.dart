import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
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
            children: [Text("Tempo restando"), Text("0%")],
          ),
          SizedBox(height: 16),
          TweenAnimationBuilder<double>(
            duration: Duration(microseconds: 300),
            tween: Tween<double>(begin: 0, end: 0.1),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 16,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(8),
              );
            },
          ),
        ],
      ),
    );
  }
}
