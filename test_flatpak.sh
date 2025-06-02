#!/bin/bash

# Test script for Flow Focus Flatpak

echo "Flow Focus Flatpak Test Script"
echo "================================"

# Check if Flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "❌ Error: Flatpak is not installed"
    echo "Please install flatpak first"
    exit 1
fi

echo "✅ Flatpak is installed"

# Check if the app is installed
if flatpak list --user | grep -q "com.rodrigo.flow_focus"; then
    echo "✅ Flow Focus Flatpak is installed"
    
    echo ""
    echo "Testing the application..."
    echo "🚀 Starting Flow Focus..."
    
    # Run the app
    flatpak run com.rodrigo.flow_focus &
    APP_PID=$!
    
    echo "App started with PID: $APP_PID"
    echo "Press Enter to stop the app, or Ctrl+C to exit this script"
    read
    
    # Kill the app
    kill $APP_PID 2>/dev/null
    echo "✅ Test completed"
    
else
    echo "❌ Flow Focus Flatpak is not installed"
    echo "Please run './build_flatpak.sh' first to build and install the app"
    exit 1
fi
