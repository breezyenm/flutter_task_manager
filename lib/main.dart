import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'repositories/task_repository.dart';
import 'services/notification_service.dart';
import 'screens/main_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskRepository = TaskRepository();
  await taskRepository.initialize();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final themeProvider = ThemeProvider(prefs);

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: MyApp(
        taskRepository: taskRepository,
        notificationService: notificationService,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;
  final NotificationService notificationService;

  const MyApp({
    super.key,
    required this.taskRepository,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Task Manager',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: themeProvider.themeMode,
          home: MainScreen(
            taskRepository: taskRepository,
            notificationService: notificationService,
          ),
        );
      },
    );
  }
}
