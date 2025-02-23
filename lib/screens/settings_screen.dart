import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/theme_settings_sheet.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showThemeSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const ThemeSettingsSheet(),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Theme'),
                subtitle: Text(
                  themeProvider.themeMode == ThemeMode.system
                      ? 'System default'
                      : themeProvider.themeMode == ThemeMode.light
                          ? 'Light theme'
                          : 'Dark theme',
                ),
                onTap: () => _showThemeSettings(context),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                subtitle: const Text('App information and help'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
