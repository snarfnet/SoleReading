#!/bin/bash
# Run this script on Mac Mini to generate and build the project
# Usage: bash build_mac.sh

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "=== SoleReading Build Script ==="

# Install xcodegen if not present
if ! command -v xcodegen &> /dev/null; then
    echo "Installing XcodeGen..."
    brew install xcodegen
fi

# Generate Xcode project
echo "Generating Xcode project..."
xcodegen generate

# Build archive
echo "Building archive..."
xcodebuild archive \
    -scheme SoleReading \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "$PROJECT_DIR/build/SoleReading.xcarchive" \
    CODE_SIGN_STYLE=Automatic \
    DEVELOPMENT_TEAM="${TEAM_ID:-}" \
    | xcpretty || true

echo "=== Done ==="
echo "Archive: $PROJECT_DIR/build/SoleReading.xcarchive"
