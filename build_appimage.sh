#!/bin/bash

# Flow Focus AppImage Build Script
# This script builds the Flutter app and packages it as an AppImage

set -e  # Exit on any error

# Configuration
APP_NAME="flow_focus"
APP_DISPLAY_NAME="Flow Focus"
APP_ID="com.rodrigo.flow_focus"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/appimage_build"
APPDIR="$BUILD_DIR/AppDir"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    # Check if flutter is installed
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    # Check if required tools are installed
    local missing_deps=()
    
    if ! command -v wget &> /dev/null; then
        missing_deps+=("wget")
    fi
    
    if ! command -v file &> /dev/null; then
        missing_deps+=("file")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_status "Please install them with: sudo apt-get install ${missing_deps[*]}"
        exit 1
    fi
    
    print_success "All dependencies are available"
}

# Download appimagetool if not present
download_appimagetool() {
    local appimagetool_path="$BUILD_DIR/appimagetool"
    
    if [ ! -f "$appimagetool_path" ]; then
        print_status "Downloading appimagetool..."
        mkdir -p "$BUILD_DIR"
        
        # Download the latest appimagetool
        wget -q "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" \
            -O "$appimagetool_path"
        
        chmod +x "$appimagetool_path"
        print_success "appimagetool downloaded"
    else
        print_status "appimagetool already available"
    fi
}

# Get version from pubspec.yaml
get_version() {
    local version=$(grep '^version:' "$SCRIPT_DIR/pubspec.yaml" | sed 's/version: *\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/')
    echo "$version"
}

# Clean previous builds
clean_build() {
    print_status "Cleaning previous builds..."
    rm -rf "$BUILD_DIR"
    flutter clean
    print_success "Build directory cleaned"
}

# Build Flutter app
build_flutter_app() {
    print_status "Building Flutter app for Linux..."
    
    # Get dependencies
    flutter pub get
    
    # Build for Linux
    flutter build linux --release
    
    if [ ! -d "build/linux/x64/release/bundle" ]; then
        print_error "Flutter build failed - bundle directory not found"
        exit 1
    fi
    
    print_success "Flutter app built successfully"
}

# Create AppDir structure
create_appdir() {
    print_status "Creating AppDir structure..."
    
    mkdir -p "$APPDIR"
    mkdir -p "$APPDIR/usr/bin"
    mkdir -p "$APPDIR/usr/lib"
    mkdir -p "$APPDIR/usr/share/applications"
    mkdir -p "$APPDIR/usr/share/icons/hicolor/256x256/apps"
    mkdir -p "$APPDIR/usr/share/metainfo"
    
    # Copy Flutter app bundle preserving structure
    cp -r build/linux/x64/release/bundle/* "$APPDIR/usr/"
    
    # Ensure the main executable is in the right place and has proper permissions
    if [ -f "$APPDIR/usr/$APP_NAME" ]; then
        chmod +x "$APPDIR/usr/$APP_NAME"
        # Create a symlink in bin directory
        mkdir -p "$APPDIR/usr/bin"
        ln -sf "../$APP_NAME" "$APPDIR/usr/bin/$APP_NAME"
    else
        print_error "Main executable not found in bundle"
        exit 1
    fi
    
    # Copy desktop file
    if [ -f "$APP_ID.desktop" ]; then
        cp "$APP_ID.desktop" "$APPDIR/usr/share/applications/"
        # Also copy to root for AppImage
        cp "$APP_ID.desktop" "$APPDIR/"
    else
        print_error "Desktop file $APP_ID.desktop not found"
        exit 1
    fi
    
    # Copy icon
    if [ -f "assets/icons/app_icon.png" ]; then
        cp "assets/icons/app_icon.png" "$APPDIR/usr/share/icons/hicolor/256x256/apps/$APP_ID.png"
        # Also copy to root for AppImage
        cp "assets/icons/app_icon.png" "$APPDIR/$APP_ID.png"
    else
        print_warning "App icon not found, AppImage will use default icon"
    fi
    
    # Copy metainfo if available
    if [ -f "$APP_ID.metainfo.xml" ]; then
        cp "$APP_ID.metainfo.xml" "$APPDIR/usr/share/metainfo/"
    fi
    
    # Create AppRun script
    cat > "$APPDIR/AppRun" << 'EOF'
#!/bin/bash

# Get the directory where this AppImage is located
HERE="$(dirname "$(readlink -f "${0}")")"

# Set up environment
export LD_LIBRARY_PATH="$HERE/usr/lib:$HERE/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

# Set APPDIR for desktop integration
export APPDIR="$HERE"

# Change to the app directory to ensure relative paths work
cd "$HERE/usr"

# Run the application with proper working directory
exec "$HERE/usr/flow_focus" "$@"
EOF
    
    chmod +x "$APPDIR/AppRun"
    
    print_success "AppDir structure created"
}

# Bundle system libraries
bundle_libraries() {
    print_status "Bundling system libraries..."
    
    # Find and copy required libraries
    local lib_dir="$APPDIR/usr/lib"
    local bin_path="$APPDIR/usr/$APP_NAME"
    
    # Create lib directory if it doesn't exist
    mkdir -p "$lib_dir"
    
    # Get list of required libraries
    local libs=$(ldd "$bin_path" | grep "=> /" | awk '{print $3}' | grep -v "^/lib64" | grep -v "^/usr/lib/x86_64-linux-gnu/ld-linux")
    
    for lib in $libs; do
        if [ -f "$lib" ]; then
            local lib_name=$(basename "$lib")
            # Skip system libraries that should be available everywhere
            case "$lib" in
                /lib/x86_64-linux-gnu/*|/usr/lib/x86_64-linux-gnu/*)
                    # Include some important libraries that might not be available
                    case "$lib_name" in
                        libgtk-3*|libglib-*|libgobject-*|libgio-*|libgdk-*|libpango-*|libcairo-*|libgdk_pixbuf-*|libatk-*|libharfbuzz*)
                            if [ ! -f "$lib_dir/$lib_name" ]; then
                                cp "$lib" "$lib_dir/"
                                print_status "Bundled: $lib_name"
                            fi
                            ;;
                    esac
                    ;;
                *)
                    # Copy non-system libraries
                    if [ ! -f "$lib_dir/$lib_name" ]; then
                        cp "$lib" "$lib_dir/"
                        print_status "Bundled: $lib_name"
                    fi
                    ;;
            esac
        fi
    done
    
    # Also copy any Flutter engine libraries that might be in the bundle
    if [ -d "build/linux/x64/release/bundle/lib" ]; then
        cp -r build/linux/x64/release/bundle/lib/* "$lib_dir/" 2>/dev/null || true
    fi
    
    print_success "System libraries bundled"
}

# Create AppImage
create_appimage() {
    print_status "Creating AppImage..."
    
    local version=$(get_version)
    local output_name="${APP_NAME}-${version}-x86_64.AppImage"
    
    cd "$BUILD_DIR"
    
    # Run appimagetool
    ARCH=x86_64 ./appimagetool AppDir "$output_name"
    
    if [ -f "$output_name" ]; then
        # Move to project root
        mv "$output_name" "$SCRIPT_DIR/"
        print_success "AppImage created: $output_name"
        
        # Make it executable
        chmod +x "$SCRIPT_DIR/$output_name"
        
        # Show file info
        print_status "AppImage details:"
        ls -lh "$SCRIPT_DIR/$output_name"
        file "$SCRIPT_DIR/$output_name"
    else
        print_error "Failed to create AppImage"
        exit 1
    fi
}

# Main build process
main() {
    print_status "Starting AppImage build for $APP_DISPLAY_NAME"
    print_status "Version: $(get_version)"
    
    check_dependencies
    clean_build
    download_appimagetool
    build_flutter_app
    create_appdir
    bundle_libraries
    create_appimage
    
    print_success "AppImage build completed successfully!"
    print_status "You can now run: ./${APP_NAME}-$(get_version)-x86_64.AppImage"
}

# Run main function
main "$@"
