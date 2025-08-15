# Architecture Patterns and Design Decisions

## Overall Architecture: MVVM + Reactive

### Layer Separation
```
Views (SwiftUI) → ViewModels (@MainActor) → Services → Models
```

## Key Architectural Components

### 1. Models Layer
- **Purpose**: Data structures and business entities
- **Key Classes**:
  - `Task`: Core task model with hierarchical subtask support
  - `TaskStatus`, `TaskPriority`: Enums for task state management
  - `SupabaseModels`: Database entity models
  - `TaskDurationLearning`: Machine learning for task duration

### 2. Services Layer
- **Purpose**: Business logic and external integrations
- **Key Services**:
  - `SupabaseService`: Backend integration (currently mocked)
  - `VoiceNavigationManager`: Audio guidance system
  - `CalendarService`: Calendar and scheduling logic
  - `TaskLearningIntegration`: ML-based task suggestions
  - `SerenaClient`: NLP service with offline fallback

### 3. ViewModels Layer
- **Purpose**: View state management and business logic orchestration
- **Patterns**:
  - All ViewModels are `@MainActor` for thread safety
  - Use `@Published` for reactive updates
  - ObservableObject protocol for SwiftUI integration
- **Key ViewModels**:
  - `ChatViewModel`: Conversational interface logic
  - `CalendarIntegrationViewModel`: Timeline and scheduling

### 4. Views Layer
- **Purpose**: SwiftUI user interface components
- **Organization**:
  - Small, composable view components
  - Separate files for major views
  - Custom modifiers and extensions

## Design Patterns

### Singleton Pattern
```swift
static let shared = SupabaseService()
```
Used for app-wide services like authentication and database

### Observer Pattern
- SwiftUI's `@Published` and `@ObservedObject`
- Combine framework for reactive programming

### Strategy Pattern
- NLP parsing with fallback strategies (Serena → Local)
- Different execution modes for tasks

### Factory Pattern
- Task creation from natural language input
- Smart suggestion generation

## Concurrency Model

### Swift 6 Strict Concurrency
- `@MainActor` for all UI-related code
- `async/await` for asynchronous operations
- `nonisolated` for thread-safe operations
- Task isolation for background work

### Actor Isolation
```swift
@MainActor
class ViewModel: ObservableObject {
    // UI updates guaranteed on main thread
}
```

## Data Flow

### Unidirectional Data Flow
1. User Action → View
2. View → ViewModel (via methods)
3. ViewModel → Service (business logic)
4. Service → Model (data update)
5. Model → ViewModel (via @Published)
6. ViewModel → View (reactive update)

### State Management
- **@StateObject**: Owner of ObservableObject
- **@ObservedObject**: Observer of ObservableObject
- **@EnvironmentObject**: App-wide shared state
- **@State/@Binding**: Local view state

## Dependency Injection

### Environment Object Pattern
```swift
ContentView()
    .environmentObject(supabaseService)
    .environmentObject(learningService)
```

## Error Handling Strategy

### Typed Errors
- Custom error types for different failure modes
- Graceful degradation (e.g., NLP fallback)
- User-friendly error messages

### Recovery Mechanisms
- Offline mode with local storage
- Retry logic for network operations
- Fallback UI for error states

## Testing Architecture

### Unit Testing
- Test models and business logic
- Mock services for isolation
- Async test support

### Integration Testing
- Service integration tests
- ViewModel behavior tests
- Calendar integration tests

## Performance Considerations

### Lazy Loading
- Views loaded on demand
- Task lists paginated
- Images and resources optimized

### Caching Strategy
- In-memory caching for frequently accessed data
- Learning data persistence
- User preferences storage

## Security Considerations

### Data Protection
- Keychain for sensitive data (when implemented)
- No hardcoded credentials
- Mock mode for development

### Privacy
- User data isolation
- No tracking without consent
- ADHD-sensitive data handling

## Future Architecture Considerations

### Planned Enhancements
- Supabase real-time sync
- Apple Watch app with shared models
- Widget support with App Groups
- CloudKit backup integration
- Siri Shortcuts with App Intents