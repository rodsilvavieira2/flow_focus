import 'package:flow_focus/config/theme.dart';
import 'package:flow_focus/screens/home.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: FocusFlowCupertinoTheme.dark,
      home: const HomeScreen(),
    );
  }
}
