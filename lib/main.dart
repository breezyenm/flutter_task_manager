import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/tasks_screen.dart';
import 'repositories/task_repository.dart';
import 'services/notification_service.dart';
import 'providers/task_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskRepository = TaskRepository();
  await taskRepository.initialize();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    taskRepository: taskRepository,
    notificationService: notificationService,
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;
  final NotificationService notificationService;
  final SharedPreferences prefs;

  const MyApp({
    super.key,
    required this.taskRepository,
    required this.notificationService,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider(taskRepository)),
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: 'Task Manager',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
          themeMode: themeProvider.themeMode,
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                leading: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      'assets/logo/logo.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                titleSpacing: 0,
                centerTitle: false,
                title: const Text('Task Manager'),
                actions: [
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) => IconButton(
                      icon: Container(
                        width: 64,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(
                                alpha: 0.2,
                              ),
                        ),
                        child: Row(
                          mainAxisAlignment: themeProvider.isDarkMode
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 32,
                              width: 32,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  themeProvider.themeMode == ThemeMode.dark
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        final newMode =
                            themeProvider.themeMode == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark;
                        themeProvider.setThemeMode(newMode);
                      },
                    ),
                  ),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Tasks'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  HomeScreen(notificationService: notificationService),
                  TasksScreen(notificationService: notificationService),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
