import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const _AppHeader(),
              const SizedBox(height: 24),
              _buildInfoSection(
                context,
                title: 'Version',
                content: snapshot.hasData
                    ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                    : 'Loading...',
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                context,
                title: 'Features',
                content: '''
• Create, edit, and delete tasks
• Mark tasks as completed
• Receive reminder notifications
• Dark mode support
• Local data storage
• System theme integration''',
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                context,
                title: 'Technologies Used',
                content: '''
• Flutter & Dart
• Hive Database
• Local Notifications
• Material Design 3
• Provider State Management''',
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                context,
                title: 'Developer',
                content: 'Created by Ladee',
              ),
              const SizedBox(height: 24),
              _buildInfoSection(
                context,
                title: 'Support',
                content:
                    'For support or feedback, please contact:\nuchegbuudochi@gmail.com',
              ),
              const SafeArea(
                child: SizedBox(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.task_alt,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Task Manager',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Organize your tasks efficiently',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
      ],
    );
  }
}
