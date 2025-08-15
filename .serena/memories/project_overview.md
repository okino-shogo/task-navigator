# NaviNavi (Tasl) Project Overview

## Project Purpose
NaviNavi (タスクナビゲーター) is an iOS application specifically designed for ADHD users to manage tasks and schedules effectively. The app addresses three core challenges:
- Memory issues (forgetting tasks and schedules)
- Executive dysfunction (difficulty starting tasks)
- Complexity aversion (avoiding complicated interfaces)

## Core Features
- **Conversational Task Creation**: Natural language processing for intuitive task input
- **Voice-Guided Navigation**: Step-by-step audio guidance through tasks and subtasks
- **Smart Scheduling**: ADHD-friendly scheduling with time estimation and conflict detection
- **Subtask Decomposition**: Automatic task breakdown for better focus management
- **Adaptive Interface**: SwiftUI-based responsive design with accessibility support

## Tech Stack
- **Platform**: iOS 18.2+
- **Language**: Swift 6 with strict concurrency
- **UI Framework**: SwiftUI + Combine
- **Architecture**: MVVM with reactive data flow
- **Audio**: AVFoundation + MediaPlayer for voice navigation
- **Calendar**: CalendarKit for timeline visualization
- **Backend**: Supabase (currently using mock implementation)
- **NLP Service**: SerenaClient with offline fallback

## Project Structure
```
Tasl/
├── NaviNavi/                    # Main iOS app
│   ├── NaviNavi/               # Source code
│   │   ├── Core/               # Core utilities
│   │   │   └── Networking/     # Network layer
│   │   ├── Models/             # Data models
│   │   ├── Services/           # Business logic
│   │   ├── ViewModels/         # View models (MVVM)
│   │   ├── Views/              # SwiftUI views
│   │   └── Extensions/         # Swift extensions
│   ├── NaviNaviTests/          # Unit tests
│   └── NaviNaviUITests/        # UI tests
└── Documentation/              # Project documentation
```

## Development Philosophy
- **ADHD-First Design**: Every feature is designed with ADHD users in mind
- **Accessibility by Default**: Full VoiceOver support and WCAG compliance
- **Offline Capable**: Core functionality works without network connection
- **Minimal Cognitive Load**: Simple, clear interfaces with minimal decision points