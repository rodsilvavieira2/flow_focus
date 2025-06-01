import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações'), elevation: 0),
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
  // Default Pomodoro values
  int _workTime = 25;
  int _shortBreakTime = 5;
  int _longBreakTime = 15;
  int _sessionUntilLongBreak = 4;

  // Controllers for text fields
  late TextEditingController _workTimeController;
  late TextEditingController _shortBreakTimeController;
  late TextEditingController _longBreakTimeController;
  late TextEditingController _sessionUntilLongBreakController;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Value constraints
  static const int _minTime = 1;
  static const int _maxTime = 999;
  static const int _minSessions = 1;
  static const int _maxSessions = 20;

  @override
  void initState() {
    super.initState();

    _workTimeController = TextEditingController(text: _workTime.toString());

    _shortBreakTimeController = TextEditingController(
      text: _shortBreakTime.toString(),
    );

    _longBreakTimeController = TextEditingController(
      text: _longBreakTime.toString(),
    );

    _sessionUntilLongBreakController = TextEditingController(
      text: _sessionUntilLongBreak.toString(),
    );
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configurações do Pomodoro',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 24),

                    _buildNumberInput(
                      label: "Tempo de trabalho (minutos)",
                      controller: _workTimeController,
                      icon: Icons.work_outline,
                      minValue: _minTime,
                      maxValue: _maxTime,
                      onChanged: (value) {
                        setState(() {
                          _workTime = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildNumberInput(
                      label: "Tempo de pausa curta (minutos)",
                      controller: _shortBreakTimeController,
                      icon: Icons.coffee_outlined,
                      minValue: _minTime,
                      maxValue: _maxTime,
                      onChanged: (value) {
                        setState(() {
                          _shortBreakTime = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildNumberInput(
                      label: "Tempo de pausa longa (minutos)",
                      controller: _longBreakTimeController,
                      icon: Icons.free_breakfast_outlined,
                      minValue: _minTime,
                      maxValue: _maxTime,
                      onChanged: (value) {
                        setState(() {
                          _longBreakTime = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildNumberInput(
                      label: "Sessões até a pausa longa",
                      controller: _sessionUntilLongBreakController,
                      icon: Icons.repeat_outlined,
                      minValue: _minSessions,
                      maxValue: _maxSessions,
                      onChanged: (value) {
                        setState(() {
                          _sessionUntilLongBreak = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetToDefaults,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Restaurar Padrões'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
            border: const OutlineInputBorder(),
            suffixText: label.contains('Sessões') ? 'sessões' : 'min',
            hintText: 'Digite um valor entre $minValue e $maxValue',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo é obrigatório';
            }
            final intValue = int.tryParse(value);
            if (intValue == null) {
              return 'Digite um número válido';
            }
            if (intValue < minValue || intValue > maxValue) {
              return 'Valor deve estar entre $minValue e $maxValue';
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
    );
  }

  void _resetToDefaults() {
    setState(() {
      _workTime = 25;
      _shortBreakTime = 5;
      _longBreakTime = 15;
      _sessionUntilLongBreak = 4;

      _workTimeController.text = _workTime.toString();
      _shortBreakTimeController.text = _shortBreakTime.toString();
      _longBreakTimeController.text = _longBreakTime.toString();
      _sessionUntilLongBreakController.text = _sessionUntilLongBreak.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configurações restauradas para os valores padrão'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      // Here you could save to SharedPreferences, database, etc.
      // For now, we'll just show a confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configurações salvas com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
