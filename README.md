# Flutter Task Manager

A simple Flutter task management application that demonstrates task creation, local storage, and push notifications.

## Features

- Create, edit, and delete tasks
- Mark tasks as completed
- Local data storage using Hive
- Push notifications 5 minutes after task creation

## Technical Implementation

- **State Management**: Simple setState for this demo app & provider for theme management
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

- hive: ^2.2.3
- hive_flutter: ^1.1.0
- flutter_local_notifications: ^16.3.0
- path_provider: ^2.1.2
- intl: ^0.19.0
