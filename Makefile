# Flow Focus Build System
# Makefile for building the Flutter app in various formats

.PHONY: help appimage linux clean install-deps test

# Default target
help:
	@echo "Flow Focus Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  appimage     - Build AppImage package"
	@echo "  linux        - Build Linux bundle (tar.gz)"
	@echo "  clean        - Clean build artifacts"
	@echo "  install-deps - Install required dependencies"
	@echo "  test         - Run Flutter tests"
	@echo "  help         - Show this help message"

# Build AppImage
appimage:
	@echo "Building AppImage..."
	./build_appimage.sh

# Build Linux bundle
linux:
	@echo "Building Linux bundle..."
	flutter pub get
	flutter build linux --release
	@echo "Creating tar.gz archive..."
	cd build/linux/x64/release/bundle && tar -czvf ../../../../../flow_focus-$$(grep '^version:' pubspec.yaml | sed 's/version: *\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')-linux-x86_64.tar.gz *
	@echo "Linux bundle created: flow_focus-$$(grep '^version:' pubspec.yaml | sed 's/version: *\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')-linux-x86_64.tar.gz"

# Clean build artifacts
clean:
	flutter clean
	rm -rf appimage_build
	rm -f *.AppImage
	rm -f *.tar.gz

# Install dependencies
install-deps:
	@echo "Installing dependencies..."
	sudo apt-get update
	sudo apt-get install -y clang cmake libgtk-3-dev ninja-build libayatana-appindicator3-dev libnotify-dev wget file
	@echo "Dependencies installed"

# Run tests
test:
	flutter test
