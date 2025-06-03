#!/bin/bash

# SHA256 Calculator for Flatpak Sources
# This script helps you calculate SHA256 checksums for your GitHub release files

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== SHA256 Calculator for Flow Focus Flatpak ===${NC}"
echo

# Configuration (UPDATE THESE)
GITHUB_USER="rodsilvavieira2"  # Your GitHub username
REPO_NAME="flow_focus"
RELEASE_TAG="linux-3"      # Your latest release tag

echo -e "${YELLOW}Configuration:${NC}"
echo "GitHub User: $GITHUB_USER"
echo "Repository: $REPO_NAME"
echo "Release Tag: $RELEASE_TAG"
echo

if [ "$GITHUB_USER" = "yourusername" ]; then
    echo -e "${YELLOW}⚠️  Please update the GITHUB_USER variable in this script with your actual username${NC}"
    echo
    read -p "Enter your GitHub username: " GITHUB_USER
    echo
fi

# URLs to check
RELEASE_URL="https://github.com/$GITHUB_USER/$REPO_NAME/releases/download/$RELEASE_TAG/flow_focus-linux-x64.tar.gz"
DESKTOP_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/master/com.rodrigo.flow_focus.desktop"
METAINFO_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/master/com.rodrigo.flow_focus.metainfo.xml"
ICON_URL="https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/master/assets/icons/app_icon.png"

# Function to calculate SHA256
calculate_sha256() {
    local url="$1"
    local name="$2"
    
    echo -e "${GREEN}Calculating SHA256 for $name...${NC}"
    echo "URL: $url"
    
    if curl -sL --fail "$url" >/dev/null 2>&1; then
        local sha256=$(curl -sL "$url" | sha256sum | cut -d' ' -f1)
        echo "SHA256: $sha256"
        echo
        return 0
    else
        echo "❌ Failed to download $name from $url"
        echo "   Please check if the URL is correct and the file exists."
        echo
        return 1
    fi
}

echo -e "${BLUE}Calculating SHA256 checksums...${NC}"
echo

# Calculate all checksums
calculate_sha256 "$RELEASE_URL" "Release Archive"
calculate_sha256 "$DESKTOP_URL" "Desktop File"
calculate_sha256 "$METAINFO_URL" "Metainfo File"
calculate_sha256 "$ICON_URL" "Icon File"

echo -e "${BLUE}Instructions:${NC}"
echo "1. Copy the SHA256 values above"
echo "2. Update com.rodrigo.flow_focus.manual.yml with:"
echo "   - Your GitHub username (replace 'yourusername')"
echo "   - The correct release tag (replace 'linux-1')"
echo "   - The SHA256 checksums (replace 'REPLACE_WITH_ACTUAL_SHA256_*')"
echo "3. Build the Flatpak with: flatpak-builder --repo=repo build com.rodrigo.flow_focus.manual.yml"
echo
echo -e "${GREEN}Done!${NC}"
