import 'package:flow_focus/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: const SettingsForm(),
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
  late TextEditingController _workTimeController;
  late TextEditingController _shortBreakTimeController;
  late TextEditingController _longBreakTimeController;
  late TextEditingController _sessionUntilLongBreakController;

  final _formKey = GlobalKey<FormState>();

  static const int _minTime = 1;
  static const int _maxTime = 60;
  static const int _minSessions = 1;
  static const int _maxSessions = 20;

  @override
  void initState() {
    super.initState();
    _workTimeController = TextEditingController();

    _shortBreakTimeController = TextEditingController();

    _longBreakTimeController = TextEditingController();

    _sessionUntilLongBreakController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormsFromProvider();
    });
  }

  void _updateFormsFromProvider() {
    final config = Provider.of<ConfigModelProvider>(context, listen: false);

    _workTimeController.text = config.workTime.toString();
    _shortBreakTimeController.text = config.shortBreakTime.toString();
    _longBreakTimeController.text = config.longBreakTime.toString();
    _sessionUntilLongBreakController.text = config.sessionUntilLongBreak
        .toString();
  }

  @override
  void dispose() {
    _workTimeController.dispose();
    _shortBreakTimeController.dispose();
    _longBreakTimeController.dispose();
    _sessionUntilLongBreakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigModelProvider>(
      builder: (context, provider, child) {
        var padding = MediaQuery.of(context).size.width * 0.20;

        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNumberInput(
                  label: "Work time (minutes)",
                  controller: _workTimeController,
                  icon: Icons.work_outline,
                  minValue: _minTime,
                  maxValue: _maxTime,
                  onChanged: (value) {
                    provider.onChangeWorkTime(value);
                  },
                ),

                const SizedBox(height: 20),

                _buildNumberInput(
                  label: "Short break time (minutes)",
                  controller: _shortBreakTimeController,
                  icon: Icons.coffee_outlined,
                  minValue: _minTime,
                  maxValue: _maxTime,
                  onChanged: (value) {
                    provider.onChangeShortBreakTime(value);
                  },
                ),

                const SizedBox(height: 20),

                _buildNumberInput(
                  label: "Long break time (minutes)",
                  controller: _longBreakTimeController,
                  icon: Icons.free_breakfast_outlined,
                  minValue: _minTime,
                  maxValue: _maxTime,
                  onChanged: (value) {
                    provider.onChangeLongBreakTime(value);
                  },
                ),

                const SizedBox(height: 20),

                _buildNumberInput(
                  label: "Sessions until long break",
                  controller: _sessionUntilLongBreakController,
                  icon: Icons.repeat_outlined,
                  minValue: _minSessions,
                  maxValue: _maxSessions,
                  onChanged: (value) {
                    provider.onChangeSessionUntilLongBreak(value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberInput({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required int minValue,
    required int maxValue,
    required ValueChanged<int> onChanged,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF252B44),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                suffixText: label.contains('Sessions') ? 'sessions' : 'min',
                suffixStyle: Theme.of(context).textTheme.bodyMedium,
                hintText: 'Enter a value between $minValue and $maxValue',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                final intValue = int.tryParse(value);
                if (intValue == null) {
                  return 'Enter a valid number';
                }
                if (intValue < minValue || intValue > maxValue) {
                  return 'Value must be between $minValue and $maxValue';
                }
                return null;
              },
              onChanged: (value) {
                final newValue = int.tryParse(value);
                if (newValue != null &&
                    newValue >= minValue &&
                    newValue <= maxValue) {
                  onChanged(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Color lighten(Color color, [double amount = 0.1]) {
  // Convert the color to HSL
  final hsl = HSLColor.fromColor(color);
  // Increase the lightness, clamping it between 0.0 and 1.0
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
  // Convert back to Color
  return hslLight.toColor();
}
