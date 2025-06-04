# Flow Focus 🍅

A modern, minimalist Pomodoro timer application built with Flutter for Linux desktop. Flow Focus helps you maintain productivity and focus using the proven Pomodoro Technique, breaking work into focused intervals separated by short breaks.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

## ✨ Features

- **🍅 Pomodoro Timer**: Classic 25/5/15 minute work/short break/long break intervals
- **⚙️ Customizable Sessions**: Adjust work time, break time, and sessions until long break
- **🌓 Theme Support**: Beautiful dark and light themes with smooth transitions
- **🔔 Desktop Notifications**: Native Linux notifications for session transitions
- **💾 Persistent Settings**: Your preferences are automatically saved
- **🎯 Progress Tracking**: Visual progress bar showing current session completion
- **⏯️ Timer Controls**: Start, pause, restart, and skip functionality
- **📊 Session Management**: Automatic cycling between work and break periods

## 🖼️ Screenshots

_Main Timer Interface_

- Clean, distraction-free design
- Large, easy-to-read timer display
- Intuitive control buttons
- Progress indicator

_Settings Panel_

- Customizable work duration (1-60 minutes)
- Adjustable short break time (1-60 minutes)
- Configurable long break duration (1-60 minutes)
- Sessions until long break (1-20 sessions)

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (3.8.1 or later)
- Linux development environment
- CMake and build essentials

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/flow_focus.git
   cd flow_focus
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Build and run**
   ```bash
   flutter run -d linux
   ```

### Building for Distribution

Use the included build script to create a distributable archive:

```bash
chmod +x build_linux.sh
./build_linux.sh
```

This will create a `flow_focus_1.0.0+1_linux_x64.tar.gz` file containing the application bundle.

## 🛠️ Development

### Project Structure

```
lib/
├── main.dart                 # Application entry point
├── config/
│   └── theme.dart           # Light and dark theme definitions
├── interface/              # Abstract interfaces for clean architecture
│   ├── config_provider.dart
│   ├── notification_service.dart
│   ├── settings_service.dart
│   ├── theme_provider.dart
│   └── timer_provider.dart
├── providers/              # State management with Provider pattern
│   ├── config_provider.dart
│   ├── theme_provider.dart
│   └── timer_provider.dart
├── screens/               # UI screens
│   ├── home.dart         # Main timer interface
│   └── settings.dart     # Configuration panel
├── services/             # Business logic and external integrations
│   ├── notification_service.dart
│   └── settings_service.dart
└── widgets/              # Reusable UI components
    ├── progress_bar.dart
    ├── step_type.dart
    ├── theme_switch.dart
    ├── timer_controls.dart
    └── timer.dart
```

### Key Dependencies

- **provider**: State management
- **shared_preferences**: Settings persistence
- **local_notifier**: Desktop notifications
- **window_manager**: Window control and positioning
- **google_fonts**: Typography

### Architecture

Flow Focus follows clean architecture principles with clear separation of concerns:

- **Interfaces**: Abstract contracts for services and providers
- **Providers**: State management using the Provider pattern
- **Services**: Business logic and external system integrations
- **Widgets**: Reusable UI components

## ⚙️ Configuration

### Default Settings

- **Work Time**: 25 minutes
- **Short Break**: 5 minutes
- **Long Break**: 15 minutes
- **Sessions Until Long Break**: 4

### Customization

All settings can be adjusted through the settings panel accessible via the gear icon in the main interface. Settings are automatically persisted using SharedPreferences.

## 🔔 Notifications

Flow Focus provides native desktop notifications for:

- Break time start
- Work session resumption
- Pomodoro completion
- Session completion

Notifications include action buttons for quick timer control without switching windows.

## 🎨 Themes

### Light Theme

- Clean, minimal design with soft gray backgrounds
- High contrast for excellent readability
- Modern rounded buttons and cards

### Dark Theme

- Eye-friendly dark backgrounds
- Vibrant accent colors
- Perfect for low-light environments

Toggle between themes using the sun/moon icon in the top-right corner.

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Dart/Flutter conventions and best practices
- Maintain the existing architecture patterns
- Add tests for new functionality
- Update documentation as needed

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Pomodoro Technique**: Developed by Francesco Cirillo
- **Flutter Team**: For the amazing cross-platform framework
- **Community**: For the open-source packages that make this possible

## 📞 Support

If you encounter any issues or have suggestions:

1. Check the [Issues](https://github.com/yourusername/flow_focus/issues) page
2. Create a new issue with detailed information
3. For questions, use the [Discussions](https://github.com/yourusername/flow_focus/discussions) tab

---

**Stay focused, stay productive! 🍅✨**
