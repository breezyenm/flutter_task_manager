# Flutter Task Manager

A simple Flutter task management application that demonstrates task creation, local storage, and push notifications.

## Features

- Create, edit, and delete tasks
- Mark tasks as completed
- Local data storage using Hive
- Push notifications at selected due date or 5 minutes after task creation

## Technical Implementation

- **State Management**: Provider for state management
- **Local Storage**: Hive for efficient local data storage
- **Notifications**: flutter_local_notifications for push notifications
- **Architecture**: Repository pattern for data management

## Getting Started

1. Ensure you have Flutter installed on your machine
2. Clone this repository
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Generate Hive adapters:
   ```bash
   flutter pub run build_runner build
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- hive_flutter: ^1.1.0
- flutter_local_notifications: ^16.3.0
- provider: ^6.1.2
- shared_preferences: ^2.5.2
- intl: ^0.20.2
- timezone: ^0.9.4
