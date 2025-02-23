// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_task_manager/main.dart';
import 'package:flutter_task_manager/repositories/task_repository.dart';
import 'package:flutter_task_manager/services/notification_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Initialize dependencies
    final taskRepository = TaskRepository();
    await taskRepository.initialize();
    final notificationService = NotificationService();
    await notificationService.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      taskRepository: taskRepository,
      notificationService: notificationService,
    ));

    // Verify that our app starts with an empty task list
    expect(find.text('Task Manager'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
