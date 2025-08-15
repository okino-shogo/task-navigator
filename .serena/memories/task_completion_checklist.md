# Task Completion Checklist

When completing any development task in the NaviNavi project, follow this checklist:

## 1. Code Quality Checks
- [ ] Code follows Swift 6 concurrency patterns (@MainActor, nonisolated)
- [ ] Proper error handling implemented
- [ ] No compiler warnings
- [ ] Documentation added for public APIs (///)
- [ ] MARK comments added for code organization

## 2. Testing
```bash
# Run unit tests
xcodebuild test -scheme NaviNavi -destination 'platform=iOS Simulator,name=iPhone 15'
```
- [ ] Unit tests pass
- [ ] New features have corresponding tests
- [ ] Edge cases covered
- [ ] Async operations properly tested

## 3. ADHD Considerations
- [ ] Feature is simple and intuitive
- [ ] Minimal cognitive load
- [ ] Clear visual/audio feedback
- [ ] Accessibility (VoiceOver) support verified
- [ ] No unnecessary complexity

## 4. Build Verification
```bash
# Clean build to ensure no issues
xcodebuild -scheme NaviNavi clean build
```
- [ ] Project builds without errors
- [ ] No new warnings introduced

## 5. Documentation
- [ ] README updated if new features added
- [ ] API documentation complete
- [ ] Japanese comments translated if needed for clarity
- [ ] CONTRIBUTING.md followed

## 6. Version Control
```bash
# Check what changed
git status
git diff

# Stage and commit
git add .
git commit -m "type: description"
```
- [ ] Changes reviewed before commit
- [ ] Commit message follows convention (feat:, fix:, docs:, etc.)
- [ ] No sensitive information in commits

## 7. Manual Testing
- [ ] Feature works on iPhone simulator
- [ ] Voice navigation tested (if applicable)
- [ ] UI responsive and accessible
- [ ] No memory leaks or performance issues

## Important Notes
- Currently no automated linting or formatting tools configured
- Use Xcode's built-in formatting (Editor > Structure > Re-Indent)
- Consider adding SwiftLint in future for automated style checking
- Supabase integration is currently mocked - ensure mock services work correctly