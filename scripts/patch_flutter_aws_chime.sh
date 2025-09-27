#!/bin/bash

# Patch flutter_aws_chime plugin to fix namespace issue
echo "Patching flutter_aws_chime plugin..."

# Find the plugin directory
PLUGIN_DIR=$(find ~/.pub-cache/hosted/pub.dev -name "flutter_aws_chime-*" -type d | head -1)

if [ -z "$PLUGIN_DIR" ]; then
    echo "flutter_aws_chime plugin not found in pub cache"
    exit 1
fi

echo "Found plugin at: $PLUGIN_DIR"

# Find the Android build.gradle file
BUILD_GRADLE=$(find "$PLUGIN_DIR/android" -name "build.gradle" -o -name "build.gradle.kts" | head -1)

if [ -z "$BUILD_GRADLE" ]; then
    echo "build.gradle file not found in plugin"
    exit 1
fi

echo "Found build.gradle at: $BUILD_GRADLE"

# Add namespace to the build.gradle file
if ! grep -q "namespace" "$BUILD_GRADLE"; then
    echo "Adding namespace to build.gradle..."
    
    # Add namespace after android { line
    sed -i '/^android {/a\    namespace = "com.flutter_aws_chime"' "$BUILD_GRADLE"
    
    echo "Namespace added successfully"
else
    echo "Namespace already exists"
fi

echo "Patch completed successfully"
