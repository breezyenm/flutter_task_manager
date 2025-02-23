import 'package:flutter/material.dart';
import '../repositories/task_repository.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';
import 'tasks_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  final TaskRepository taskRepository;
  final NotificationService notificationService;

  const MainScreen({
    super.key,
    required this.taskRepository,
    required this.notificationService,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        taskRepository: widget.taskRepository,
        notificationService: widget.notificationService,
      ),
      TasksScreen(
        taskRepository: widget.taskRepository,
        notificationService: widget.notificationService,
      ),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Dashboard'
              : _selectedIndex == 1
                  ? 'Tasks'
                  : 'Settings',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
