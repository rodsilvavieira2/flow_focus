import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FocusFlow')),
      body: SettingsForm(),
    );
  }
}

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() {
    return _SettingsFormState();
  }
}

class _SettingsFormState extends State<SettingsForm> {
  int _workTime = 25;
  int _shortBreakTime = 5;
  int _longBreakTime = 15;
  int _sessionUntilLongBreak = 4;

  late TextEditingController _workTimeValueController;
  late TextEditingController _shortBreakTimeController;
  late TextEditingController _longBreakTimeController;
  late TextEditingController _sessionUntilLongBreakController;

  @override
  void initState() {
    super.initState();

    _workTimeValueController = TextEditingController(
      text: _workTime.toString(),
    );

    _sessionUntilLongBreakController = TextEditingController(
      text: _sessionUntilLongBreak.toString(),
    );

    _longBreakTimeController = TextEditingController(
      text: _longBreakTime.toString(),
    );

    _shortBreakTimeController = TextEditingController(
      text: _shortBreakTime.toString(),
    );
  }

  @override
  void dispose() {
    _workTimeValueController.dispose();
    _sessionUntilLongBreakController.dispose();
    _longBreakTimeController.dispose();
    _shortBreakTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.width * 0.20;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
      child: Column(
        children: [
          _buildNumberInput(
            label: "Tempo de trabalho (minutos)",
            controller: _workTimeValueController,
            onChanged: (value) {
              setState(() {
                _workTime = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildNumberInput(
            label: "Tempo de intervalo (minutos)",
            controller: _shortBreakTimeController,
            onChanged: (value) {
              setState(() {
                _shortBreakTime = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildNumberInput(
            label: "Tempo de longo de intervalo (minutos)",
            controller: _longBreakTimeController,
            onChanged: (value) {
              setState(() {
                _longBreakTime = value;
              });
            },
          ),

          const SizedBox(height: 12),

          _buildNumberInput(
            label: "Secessões ate  o intervalo longo",
            controller: _sessionUntilLongBreakController,
            onChanged: (value) {
              setState(() {
                _sessionUntilLongBreak = value;
              });
            },
          ),
        ],
      ),
    );
  }

  _buildNumberInput({
    required String label,
    required TextEditingController controller,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: (value) {
            final newValue = int.tryParse(value);

            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}
