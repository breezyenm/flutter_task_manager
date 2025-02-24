import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  /// Instance of FlutterLocalNotificationsPlugin to manage notifications
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service with platform-specific settings.
  ///
  /// This method must be called before using any other notification features.
  /// It sets up:
  /// - Time zones for scheduled notifications
  /// - Android notification icon and channel
  /// - iOS notification permissions and settings
  Future<void> initialize() async {
    // Initialize timezone data for scheduled notifications
    tz.initializeTimeZones();

    // Configure platform-specific notification settings
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    await _notifications.initialize(initializationSettings);
  }

  /// Schedules a notification reminder for a task.
  ///
  /// Parameters:
  /// - [taskId]: Unique identifier for the task, used to manage the notification
  /// - [title]: Title of the task to display in the notification
  /// - [dueDate]: Optional due date for the task. If not provided, notification
  ///   will be scheduled for 5 minutes from now
  ///
  /// The notification will be scheduled with high priority and will wake the device
  /// if in doze mode (Android only).
  Future<void> scheduleTaskReminder(String taskId, String title,
      [DateTime? dueDate]) async {
    // Configure Android-specific notification details
    const androidDetails = AndroidNotificationDetails(
      'task_reminders', // Channel ID
      'Task Reminders', // Channel Name
      channelDescription: 'Notifications for task reminders',
      importance: Importance.max, // Show at the top of the notification list
      priority: Priority.high, // High priority notification
    );

    // Configure iOS-specific notification details
    const iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Combine platform-specific details
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // Calculate when to show the notification
    final now = DateTime.now();
    final scheduledDate = dueDate != null
        ? tz.TZDateTime(tz.local, dueDate.year, dueDate.month, dueDate.day,
            dueDate.hour, dueDate.minute, dueDate.second, dueDate.millisecond)
        : tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour,
                now.minute, now.second, now.millisecond)
            .add(const Duration(minutes: 5));

    // Schedule the notification
    await _notifications.zonedSchedule(
      taskId.hashCode, // Unique ID for the notification
      'Task Due', // Notification title
      dueDate != null
          ? 'Task due: $title' // Message for tasks with due date
          : 'Remember to complete your task: $title', // Message for tasks without due date
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // Allow notification in doze mode
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime, // Use absolute time for scheduling
    );
  }
}
