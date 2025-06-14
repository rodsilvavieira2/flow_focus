import 'package:flutter/widgets.dart';

abstract class ITrayService {
  Future<void> initialize({required VoidCallback onShow, required VoidCallback onQuit});
  Future<void> destroy();
}
