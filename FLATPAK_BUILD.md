# Flow Focus Flatpak Build Guide

This guide explains how to build a Flatpak package for Flow Focus using GitHub releases.

## Prerequisites

1. Install Flatpak and flatpak-builder:
   ```bash
   sudo apt install flatpak flatpak-builder
   ```

2. Add Flathub repository:
   ```bash
   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
   ```

3. Install GNOME runtime and SDK:
   ```bash
   flatpak install flathub org.gnome.Platform//47 org.gnome.Sdk//47
   ```

## Quick Build

The simplest way to build the Flatpak is using the automated build script:

```bash
# Make sure the script is executable
chmod +x build_flatpak_github.sh

# Run the build script
./build_flatpak_github.sh
```

This script will:
- Check all prerequisites
- Download sources from GitHub (release `linux-3`)
- Build the Flatpak
- Install it locally
- Optionally export it for distribution

## Manual Build Process

If you prefer to build manually:

1. **Build the Flatpak:**
   ```bash
   flatpak-builder --repo=repo --force-clean build com.rodrigo.flow_focus.github.yml
   ```

2. **Install locally:**
   ```bash
   flatpak --user remote-add --no-gpg-verify flow-focus-repo repo
   flatpak --user install flow-focus-repo com.rodrigo.flow_focus
   ```

3. **Run the application:**
   ```bash
   flatpak run com.rodrigo.flow_focus
   ```

## Files Overview

- `com.rodrigo.flow_focus.github.yml` - Main Flatpak manifest that downloads from GitHub
- `build_flatpak_github.sh` - Automated build script
- `calculate_sha256.sh` - Helper script to calculate checksums for new releases

## Updating for New Releases

When you publish a new GitHub release:

1. Update the release tag in `calculate_sha256.sh`:
   ```bash
   RELEASE_TAG="linux-X"  # Replace X with your new release number
   ```

2. Run the checksum calculator:
   ```bash
   ./calculate_sha256.sh
   ```

3. Update `com.rodrigo.flow_focus.github.yml` with:
   - New release URL
   - New SHA256 checksums

4. Rebuild the Flatpak:
   ```bash
   ./build_flatpak_github.sh
   ```

## Distribution

### Creating a Bundle

To create a single-file bundle for distribution:

```bash
flatpak build-bundle repo flow_focus.flatpak com.rodrigo.flow_focus
```

Users can then install it with:
```bash
flatpak install flow_focus.flatpak
```

### Publishing to Flathub

To publish on Flathub:

1. Fork the [flathub/flathub](https://github.com/flathub/flathub) repository
2. Create a new repository named `com.rodrigo.flow_focus`
3. Submit your manifest file
4. Follow the Flathub submission process

## Current Configuration

- **Repository**: https://github.com/rodsilvavieira2/flow_focus
- **Current Release**: linux-3
- **Release Archive**: flow_focus-linux-x64.tar.gz
- **Runtime**: org.gnome.Platform 47
- **SDK**: org.gnome.Sdk 47

## Troubleshooting

### Build Fails with "Source not found"

- Check that the GitHub release exists
- Verify the release tag in the URL
- Ensure the release contains `flow_focus-linux-x64.tar.gz`

### SHA256 Mismatch

- Run `./calculate_sha256.sh` to get current checksums
- Update the manifest with new SHA256 values

### Permission Issues

- Ensure you have permission to write to the build directory
- Try running with `--user` flag for flatpak commands

### Runtime Not Found

- Install the required runtime:
  ```bash
  flatpak install flathub org.gnome.Platform//47 org.gnome.Sdk//47
  ```

## Testing

After installation, test the application:

```bash
# Run normally
flatpak run com.rodrigo.flow_focus

# Run with debug output
flatpak run --command=sh com.rodrigo.flow_focus
# Then inside the sandbox:
/app/bin/flow_focus
```

## File Permissions

The application has these permissions:
- Desktop access (X11/Wayland)
- Desktop notifications
- Audio access (for notification sounds)
- Configuration file access
- System tray access
- Network access
- Graphics acceleration

These are defined in the `finish-args` section of the manifest.
