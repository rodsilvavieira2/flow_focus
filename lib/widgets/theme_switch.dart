import 'package:flow_focus/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModelProvider>(
      builder: (context, themeProvider, child) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            _getThemeIcon(themeProvider.currentTheme),
            color: Theme.of(context).iconTheme.color,
          ),
          onSelected: (ThemeMode themeMode) {
            themeProvider.onChangeThemeMode(themeMode);
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: themeProvider.isLightMode
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Light',
                    style: TextStyle(
                      color: themeProvider.isLightMode
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: themeProvider.isLightMode
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: themeProvider.isDarkMode
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dark',
                    style: TextStyle(
                      color: themeProvider.isDarkMode
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: themeProvider.isDarkMode
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(
                    Icons.auto_mode,
                    color: themeProvider.isSystemMode
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'System',
                    style: TextStyle(
                      color: themeProvider.isSystemMode
                          ? Theme.of(context).colorScheme.primary
                          : null,
                      fontWeight: themeProvider.isSystemMode
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.auto_mode;
    }
  }
}

class ThemeProvider {}
