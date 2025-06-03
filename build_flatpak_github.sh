#!/bin/bash

# Flatpak Build Script for Flow Focus (GitHub Release Version)
# This script builds a Flatpak package using the latest GitHub release

set -e  # Exit on any error

# Configuration
APP_ID="com.rodrigo.flow_focus"
GITHUB_USER="rodsilvavieira2"  # Your GitHub username
REPO_NAME="flow_focus"
RELEASE_TAG="linux-3"  # Current release tag
MANIFEST_FILE="com.rodrigo.flow_focus.github.yml"
BUILD_DIR="flatpak-build"
REPO_DIR="flatpak-repo"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Flow Focus Flatpak Builder (GitHub Release) ===${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v flatpak-builder &> /dev/null; then
        print_error "flatpak-builder is not installed. Please install it first:"
        print_error "  Ubuntu/Debian: sudo apt install flatpak-builder"
        print_error "  Fedora: sudo dnf install flatpak-builder"
        print_error "  Arch: sudo pacman -S flatpak-builder"
        exit 1
    fi
    
    if ! command -v curl &> /dev/null; then
        print_error "curl is not installed. Please install it first."
        exit 1
    fi
    
    print_status "All dependencies found!"
}

# Function to get SHA256 of a URL
get_url_sha256() {
    local url="$1"
    print_status "Calculating SHA256 for: $url"
    curl -sL "$url" | sha256sum | cut -d' ' -f1
}

# Function to update SHA256 checksums in the manifest
update_checksums() {
    print_status "Updating SHA256 checksums in manifest..."
    
    # Check if GitHub username is still placeholder
    if grep -q "yourusername" "$MANIFEST_FILE"; then
        print_error "Please update the GitHub username in $MANIFEST_FILE"
        print_error "Replace 'yourusername' with your actual GitHub username"
        exit 1
    fi
    
    # Get the latest release URL
    local release_url="https://github.com/$GITHUB_USER/$REPO_NAME/releases/latest/download/flow_focus-linux-x64.tar.gz"
    local desktop_url="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/master/com.rodrigo.flow_focus.desktop"
    local metainfo_url="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/master/com.rodrigo.flow_focus.metainfo.xml"
    local icon_url="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/master/assets/icons/app_icon.png"
    
    # Calculate checksums
    print_status "Downloading files to calculate checksums..."
    local release_sha256=$(get_url_sha256 "$release_url")
    local desktop_sha256=$(get_url_sha256 "$desktop_url")
    local metainfo_sha256=$(get_url_sha256 "$metainfo_url")
    local icon_sha256=$(get_url_sha256 "$icon_url")
    
    print_status "Checksums calculated:"
    echo "  Release archive: $release_sha256"
    echo "  Desktop file: $desktop_sha256"
    echo "  Metainfo file: $metainfo_sha256"
    echo "  Icon file: $icon_sha256"
    
    # Create a temporary manifest with updated checksums
    local temp_manifest="$MANIFEST_FILE.tmp"
    cp "$MANIFEST_FILE" "$temp_manifest"
    
    # Replace placeholder SHA256s with actual values
    sed -i "s|url: https://github.com/yourusername|url: https://github.com/$GITHUB_USER|g" "$temp_manifest"
    
    # This is a bit complex because we need to replace specific SHA256 placeholders
    # We'll use a more targeted approach
    
    # For now, let's create a version-specific manifest
    cat > "$temp_manifest" << EOF
# Flatpak manifest for Flow Focus - Downloads from GitHub Releases
app-id: com.rodrigo.flow_focus
runtime: org.gnome.Platform
runtime-version: '47'
sdk: org.gnome.Sdk
command: flow_focus

finish-args:
  # Allow access to the desktop
  - --share=ipc
  - --socket=x11
  - --socket=wayland
  
  # Allow desktop notifications
  - --talk-name=org.freedesktop.Notifications
  
  # Allow access to sound for notification sounds
  - --socket=pulseaudio
  
  # Allow access to settings/preferences
  - --filesystem=xdg-config/flow_focus:create
  
  # Allow system tray access
  - --talk-name=org.kde.StatusNotifierWatcher
  - --talk-name=org.freedesktop.StatusNotifierWatcher
  
  # Additional system permissions for proper library access
  - --share=network
  - --device=dri

modules:
  - name: flow_focus
    buildsystem: simple
    build-commands:
      # Create the application directory structure
      - mkdir -p /app/bin
      - mkdir -p /app/share/applications
      - mkdir -p /app/share/metainfo
      - mkdir -p /app/share/icons/hicolor/256x256/apps
      
      # Extract the downloaded release archive
      - tar -xzf flow_focus-linux-x64.tar.gz
      
      # Copy the precompiled Flutter app from extracted bundle
      - cp -r bundle/* /app/
      
      # Make the executable... executable
      - chmod +x /app/flow_focus
      
      # Create a wrapper script for proper execution
      - |
        cat > /app/bin/flow_focus << 'EOF'
        #!/bin/bash
        export FLUTTER_ROOT=/app
        export LD_LIBRARY_PATH=/app/lib:\$LD_LIBRARY_PATH
        # Ensure runtime libraries are available
        export PATH=/app/bin:\$PATH
        exec /app/flow_focus "\$@"
        EOF
      - chmod +x /app/bin/flow_focus
      
      # Install desktop file and metadata
      - install -Dm644 com.rodrigo.flow_focus.desktop /app/share/applications/
      - install -Dm644 com.rodrigo.flow_focus.metainfo.xml /app/share/metainfo/
      
      # Install icon
      - install -Dm644 app_icon.png /app/share/icons/hicolor/256x256/apps/com.rodrigo.flow_focus.png
      
    sources:
      # Download the latest release from GitHub
      - type: archive
        url: $release_url
        sha256: $release_sha256
        
      # Include the desktop file and metadata from the repository
      - type: file
        url: $desktop_url
        sha256: $desktop_sha256
        
      - type: file
        url: $metainfo_url
        sha256: $metainfo_sha256
        
      # Include the app icon from the repository
      - type: file
        url: $icon_url
        sha256: $icon_sha256
        dest-filename: app_icon.png
EOF

    mv "$temp_manifest" "$MANIFEST_FILE.ready"
    print_status "Updated manifest saved as: $MANIFEST_FILE.ready"
}

# Function to build the Flatpak
build_flatpak() {
    print_status "Building Flatpak package..."
    
    # Clean previous builds
    if [ -d "$BUILD_DIR" ]; then
        print_status "Cleaning previous build directory..."
        rm -rf "$BUILD_DIR"
    fi
    
    if [ -d "$REPO_DIR" ]; then
        print_status "Cleaning previous repository directory..."
        rm -rf "$REPO_DIR"
    fi
    
    # Build the Flatpak
    print_status "Running flatpak-builder..."
    flatpak-builder --force-clean --repo="$REPO_DIR" "$BUILD_DIR" "$MANIFEST_FILE.ready"
    
    if [ $? -eq 0 ]; then
        print_status "Build completed successfully!"
        print_status "Flatpak repository created in: $REPO_DIR"
    else
        print_error "Build failed!"
        exit 1
    fi
}

# Function to install the built Flatpak
install_flatpak() {
    print_status "Installing Flatpak locally..."
    
    # Add local repository
    flatpak remote-add --user --no-gpg-verify flow-focus-local "$REPO_DIR" 2>/dev/null || true
    
    # Install the application
    flatpak install --user flow-focus-local "$APP_ID" -y
    
    if [ $? -eq 0 ]; then
        print_status "Installation completed successfully!"
        print_status "You can now run the app with: flatpak run $APP_ID"
    else
        print_error "Installation failed!"
        exit 1
    fi
}

# Function to create a distributable Flatpak bundle
create_bundle() {
    print_status "Creating distributable bundle..."
    
    local bundle_name="${APP_ID}.flatpak"
    flatpak build-bundle "$REPO_DIR" "$bundle_name" "$APP_ID"
    
    if [ $? -eq 0 ]; then
        print_status "Bundle created: $bundle_name"
        print_status "You can distribute this file to users"
        print_status "Users can install it with: flatpak install $bundle_name"
    else
        print_error "Bundle creation failed!"
        exit 1
    fi
}

# Main execution
main() {
    print_status "Starting Flatpak build process..."
    
    # Check if manifest file exists
    if [ ! -f "$MANIFEST_FILE" ]; then
        print_error "Manifest file $MANIFEST_FILE not found!"
        exit 1
    fi
    
    check_dependencies
    update_checksums
    build_flatpak
    
    # Ask user if they want to install locally
    echo
    read -p "Do you want to install the Flatpak locally for testing? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_flatpak
    fi
    
    # Ask user if they want to create a distributable bundle
    echo
    read -p "Do you want to create a distributable bundle? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        create_bundle
    fi
    
    print_status "All done! 🎉"
    print_warning "Remember to:"
    print_warning "1. Update the GitHub username in $MANIFEST_FILE if not done already"
    print_warning "2. Make sure your repository is public or provide authentication"
    print_warning "3. Test the Flatpak thoroughly before distribution"
}

# Run main function
main "$@"
