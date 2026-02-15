#!/bin/bash

# Build script for LeetCode Reminder

echo "🚀 Building LeetCode Reminder..."

# Navigate to project directory
cd "$(dirname "$0")"

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: Xcode is not installed"
    exit 1
fi

# Build the project
xcodebuild \
    -project LeetCodeReminder.xcodeproj \
    -scheme LeetCodeReminder \
    -configuration Release \
    -derivedDataPath ./build \
    clean build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📱 App located at: ./build/Build/Products/Release/LeetCodeReminder.app"
    echo ""
    echo "To install:"
    echo "  cp -r ./build/Build/Products/Release/LeetCodeReminder.app /Applications/"
else
    echo "❌ Build failed"
    exit 1
fi
