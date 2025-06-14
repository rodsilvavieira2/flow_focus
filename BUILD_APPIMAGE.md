# Building Flow Focus AppImage

This guide explains how to build Flow Focus as an AppImage package.

## Prerequisites

Make sure you have the following installed:

- Flutter SDK (version 3.32.1 or later)
- Build essentials and required libraries

You can install the required dependencies by running:

```bash
make install-deps
```

Or manually:

```bash
sudo apt-get install -y clang cmake libgtk-3-dev ninja-build libayatana-appindicator3-dev libnotify-dev wget file
```

## Building AppImage

### Option 1: Using the build script (Recommended)

```bash
./build_appimage.sh
```

### Option 2: Using Make

```bash
make appimage
```

### Option 3: Manual build

```bash
# Install dependencies
flutter pub get

# Build Flutter app
flutter build linux --release

# Run the AppImage build script
./build_appimage.sh
```

## Output

The build script will create an AppImage file named:

```
flow_focus-{version}-x86_64.AppImage
```

## Running the AppImage

Once built, you can run the AppImage directly:

```bash
./flow_focus-{version}-x86_64.AppImage
```

## What the build script does

1. **Checks dependencies** - Verifies that all required tools are installed
2. **Downloads appimagetool** - Gets the latest AppImage creation tool
3. **Builds Flutter app** - Compiles the Flutter app for Linux
4. **Creates AppDir structure** - Sets up the proper directory structure for AppImage
5. **Bundles libraries** - Includes necessary system libraries
6. **Creates AppImage** - Packages everything into a single executable file

## Troubleshooting

### Missing dependencies

If you get errors about missing dependencies, run:

```bash
make install-deps
```

### Flutter build fails

Make sure Flutter is properly installed and up to date:

```bash
flutter doctor
flutter upgrade
```

### AppImage doesn't run

Check if the AppImage has execute permissions:

```bash
chmod +x flow_focus-*.AppImage
```

## Other build targets

- `make linux` - Build a tar.gz bundle
- `make clean` - Clean all build artifacts
- `make test` - Run Flutter tests

## GitHub Actions

The project includes a GitHub Actions workflow (`.github/workflows/appimage.yml`) that automatically builds AppImages on every push and pull request.
