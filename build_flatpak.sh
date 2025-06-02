#!/bin/bash

set -e

echo "Building Flutter app for Linux..."

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build the Linux release
flutter build linux --release

echo "Flutter build completed successfully!"

# Check if the bundle directory exists
if [ ! -d "build/linux/x64/release/bundle" ]; then
    echo "Error: Flutter bundle not found at build/linux/x64/release/bundle"
    exit 1
fi

echo "Building Flatpak..."

# Install Flatpak dependencies if needed
flatpak install --user -y flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08

# Build the Flatpak
flatpak-builder --user --install --force-clean build-dir com.rodrigo.flow_focus.yml

echo "Flatpak build completed successfully!"
echo "You can now run your app with: flatpak run com.rodrigo.flow_focus"
echo "Or export it with: flatpak build-export repo build-dir"
