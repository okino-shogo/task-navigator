# Code Style and Conventions

## Swift 6 Standards
- **Concurrency**: Full adoption of Swift 6 strict concurrency with `@MainActor` and `nonisolated`
- **Type Safety**: Strong typing with explicit type declarations where beneficial
- **Error Handling**: Comprehensive error handling with typed throws

## Naming Conventions
- **Classes/Structs**: PascalCase (e.g., `TaskViewModel`, `SerenaClient`)
- **Properties/Methods**: camelCase (e.g., `isNavigating`, `updateTask()`)
- **Constants**: camelCase with descriptive names
- **Enums**: PascalCase with camelCase cases

## Architecture Patterns
- **MVVM Pattern**: Clear separation between Views and ViewModels
- **@MainActor**: Used for all UI-related ViewModels and managers
- **@Published**: For reactive properties in ObservableObject classes
- **@StateObject/@ObservedObject**: Proper SwiftUI state management

## Documentation
- **Doc Comments**: Comprehensive documentation using `///` for public APIs
- **MARK Comments**: Used to organize code sections (e.g., `// MARK: - Task Status`)
- **Purpose Documentation**: Clear explanations of ADHD-specific design decisions
- **Japanese Comments**: Some inline comments in Japanese for local context

## Code Organization
- **Single Responsibility**: Each file contains one primary type
- **Extensions**: Used for protocol conformance and logical grouping
- **Computed Properties**: Preferred over simple getter methods
- **Guard Statements**: Early returns for cleaner code flow

## SwiftUI Best Practices
- **View Composition**: Small, reusable view components
- **Environment Objects**: For app-wide state management
- **@State/@Binding**: Proper state ownership and delegation
- **Async/Await**: Modern concurrency for asynchronous operations

## Testing Conventions
- **Test Naming**: Descriptive test names explaining what is being tested
- **XCTest Framework**: Standard iOS testing framework
- **Async Testing**: Proper use of async test methods
- **Mock Services**: Using mock implementations for testing

## Constants and Magic Numbers
- **No Magic Numbers**: All numeric values should be named constants
- **Configuration**: Centralized configuration values
- **Time Constants**: Clear time interval definitions (e.g., `30 * 60` with comments)