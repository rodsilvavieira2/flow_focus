import 'package:flow_focus/widgets/progesss_bar.dart';
import 'package:flow_focus/widgets/timer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusFlow'), centerTitle: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Timer(duration: Duration(hours: 0, minutes: 25, seconds: 0)),
            const SizedBox(height: 22),
            ProgressBar(percent: 0.05),
          ],
        ),
      ),
    );
  }
}
