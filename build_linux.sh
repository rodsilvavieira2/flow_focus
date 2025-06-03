#!/bin/bash

# Exit on error
set -e

echo "🔨 Building Flow Focus for Linux..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/linux

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for Linux
echo "🐧 Building Linux application..."
flutter build linux --release

# Create the tar archive
echo "📦 Creating tar archive..."
VERSION=$(grep 'version:' pubspec.yaml | awk '{print $2}' | tr -d "'")
TAR_NAME="flow_focus_${VERSION}_linux_x64.tar.gz"

# Create a temporary directory for the package
TEMP_DIR="flow_focus_${VERSION}"
mkdir -p "$TEMP_DIR"

# Copy necessary files
cp -r build/linux/x64/release/bundle/* "$TEMP_DIR/"

# Create the tar archive
tar -czf "$TAR_NAME" "$TEMP_DIR"

# Clean up
rm -rf "$TEMP_DIR"

echo "✨ Build completed!"
echo "📝 Archive created: $TAR_NAME"
