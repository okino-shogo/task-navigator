# Suggested Commands for NaviNavi Development

## Build and Run Commands

### Xcode Build
```bash
# Build the project
xcodebuild -scheme NaviNavi -configuration Debug build

# Build for release
xcodebuild -scheme NaviNavi -configuration Release build

# Build and run on simulator
xcodebuild -scheme NaviNavi -destination 'platform=iOS Simulator,name=iPhone 15' build

# Clean build
xcodebuild -scheme NaviNavi clean
```

### Testing
```bash
# Run unit tests
xcodebuild test -scheme NaviNavi -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test class
xcodebuild test -scheme NaviNavi -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:NaviNaviTests/TaskModelTests

# Run UI tests
xcodebuild test -scheme NaviNaviUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Package Management
```bash
# Resolve Swift Package Manager dependencies
xcodebuild -resolvePackageDependencies

# Update packages
swift package update
```

## Git Commands
```bash
# Check status
git status

# Stage changes
git add .

# Commit with message
git commit -m "feat: Add feature description"

# Push to remote
git push origin main

# Create feature branch
git checkout -b feature/feature-name
```

## System Commands (Darwin/macOS)
```bash
# List files
ls -la

# Find Swift files
find . -name "*.swift"

# Search in files (using ripgrep if available)
rg "pattern" --type swift

# Or using grep
grep -r "pattern" --include="*.swift" .

# Open in Xcode
open NaviNavi/NaviNavi.xcodeproj
```

## Development Workflow
```bash
# 1. Before starting work
git pull origin main

# 2. Create feature branch
git checkout -b feature/your-feature

# 3. Open in Xcode
open NaviNavi/NaviNavi.xcodeproj

# 4. After making changes, run tests
xcodebuild test -scheme NaviNavi -destination 'platform=iOS Simulator,name=iPhone 15'

# 5. Commit changes
git add .
git commit -m "feat: Description of changes"

# 6. Push changes
git push origin feature/your-feature
```

## Debugging
```bash
# View build logs
xcodebuild -scheme NaviNavi build | xcpretty

# Check for Swift syntax errors
swiftc -parse NaviNavi/NaviNavi/*.swift

# Analyze code (if SwiftLint installed)
swiftlint --path NaviNavi/
```

## Notes
- No linting or formatting tools are currently configured
- Tests should be run before committing changes
- The project uses Xcode's built-in formatting (Editor > Structure > Re-Indent)
- Consider adding SwiftLint for consistent code style enforcement