#!/usr/bin/env bash
set -euo pipefail

# Script to update NoteCraft to the latest version

# Get the latest release tag from GitHub
echo "Fetching latest release from GitHub..."
LATEST_VERSION=$(curl -s "https://api.github.com/repos/AlienTechSoftware/notecraft/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch latest version"
    exit 1
fi

# Remove 'v' prefix if present
VERSION=${LATEST_VERSION#v}

echo "Latest version: $VERSION"

# Construct the AppImage URL
APPIMAGE_URL="https://github.com/AlienTechSoftware/notecraft/releases/download/${LATEST_VERSION}/notecraft-${VERSION}-linux-x86_64.AppImage"

echo "Fetching hash for AppImage..."
HASH=$(nix-prefetch-url --type sha256 "$APPIMAGE_URL")

# Convert to SRI format
SRI_HASH=$(nix hash convert --hash-algo sha256 --to sri "$HASH")

echo "Updating package.nix..."

# Update version
sed -i "s/version = \".*\";/version = \"$VERSION\";/" package.nix

# Update hash
sed -i "s|hash = \".*\";|hash = \"$SRI_HASH\";|" package.nix

echo "Updated to version $VERSION"
echo "Hash: $SRI_HASH"
