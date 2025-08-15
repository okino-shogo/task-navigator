#!/bin/bash

# SwiftLint Script for NaviNavi Project
# This script runs SwiftLint with proper configuration

# Set the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Check if SwiftLint is available
if which swiftlint >/dev/null; then
    echo "🧹 Running SwiftLint..."
    swiftlint lint --config .swiftlint.yml
    SWIFTLINT_EXIT_CODE=$?
    
    if [ $SWIFTLINT_EXIT_CODE -eq 0 ]; then
        echo "✅ SwiftLint passed"
    else
        echo "❌ SwiftLint found issues (exit code: $SWIFTLINT_EXIT_CODE)"
        exit $SWIFTLINT_EXIT_CODE
    fi
else
    echo "⚠️  SwiftLint not found. Please install SwiftLint:"
    echo "   brew install swiftlint"
    echo "   or download from: https://github.com/realm/SwiftLint"
    exit 1
fi