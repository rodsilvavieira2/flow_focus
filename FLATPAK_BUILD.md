# Flatpak Build Instructions

This document explains how to build and distribute Flow Focus as a Flatpak package.

## Prerequisites

1. **Flatpak and flatpak-builder**: Install these on your system
   ```bash
   # On Ubuntu/Debian
   sudo apt install flatpak flatpak-builder
   
   # On Fedora
   sudo dnf install flatpak flatpak-builder
   
   # On Arch Linux
   sudo pacman -S flatpak flatpak-builder
   ```

2. **Flutter SDK**: Make sure Flutter is installed and configured for Linux desktop development

3. **Flathub repository** (for runtime dependencies):
   ```bash
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   ```

## Building the Flatpak

### Method 1: Using the build script (Recommended)

Simply run the provided build script:

```bash
./build_flatpak.sh
```

This script will:
1. Clean and rebuild the Flutter app for Linux
2. Install required Flatpak runtimes
3. Build the Flatpak package
4. Install it locally

### Method 2: Manual build

1. **Build the Flutter app first**:
   ```bash
   flutter clean
   flutter pub get
   flutter build linux --release
   ```

2. **Install required Flatpak runtimes**:
   ```bash
   flatpak install --user flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08
   ```

3. **Build the Flatpak**:
   ```bash
   flatpak-builder --user --install --force-clean build-dir com.rodrigo.flow_focus.yml
   ```

## Running the App

After building, you can run the app with:

```bash
flatpak run com.rodrigo.flow_focus
```

## Distribution

### Creating a repository for distribution

1. **Export to a repository**:
   ```bash
   flatpak build-export repo build-dir
   ```

2. **Create a bundle file for easy distribution**:
   ```bash
   flatpak build-bundle repo flow_focus.flatpak com.rodrigo.flow_focus
   ```

3. **Users can then install from the bundle**:
   ```bash
   flatpak install --user flow_focus.flatpak
   ```

### Publishing to Flathub

To publish on Flathub, you would need to:

1. Fork the [Flathub repository](https://github.com/flathub/flathub)
2. Add your manifest file
3. Submit a pull request

For more details, see the [Flathub submission guidelines](https://docs.flathub.org/docs/for-app-authors/submission/).

## Flatpak Manifest Explanation

The `com.rodrigo.flow_focus.yml` file is configured to:

- Use the precompiled Flutter Linux bundle from `build/linux/x64/release/bundle`
- Include necessary permissions for desktop integration, notifications, and system tray
- Install the desktop file, metadata, and icon properly
- Create a wrapper script for proper execution

## Troubleshooting

### Common Issues

1. **Permission denied errors**: Make sure the build script is executable with `chmod +x build_flatpak.sh`

2. **Missing Flutter bundle**: Ensure you've built the Flutter app with `flutter build linux --release` before building the Flatpak

3. **Runtime not found**: Install the required runtime with:
   ```bash
   flatpak install flathub org.freedesktop.Platform//23.08
   ```

4. **App doesn't start**: Check the logs with:
   ```bash
   flatpak run --log-session-bus com.rodrigo.flow_focus
   ```

### Debugging

To debug issues, you can run the Flatpak in a more verbose mode:

```bash
flatpak run --verbose com.rodrigo.flow_focus
```

Or access the sandboxed environment:

```bash
flatpak run --command=bash com.rodrigo.flow_focus
```
