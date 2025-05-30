import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        padding: const EdgeInsetsDirectional.only(start: 16, end: 16, top: 12),
        leading: Text(
          "FlowFocus",
          style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
        ),
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to FlowFocus!",
                style: CupertinoTheme.of(
                  context,
                ).textTheme.navLargeTitleTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
