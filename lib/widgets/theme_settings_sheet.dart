import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ThemeSettingsSheet extends StatelessWidget {
  const ThemeSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Theme Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ThemeOption(
                title: 'System',
                subtitle: 'Follow system settings',
                icon: Icons.brightness_auto,
                isSelected: themeProvider.themeMode == ThemeMode.system,
                onTap: () => themeProvider.setThemeMode(ThemeMode.system),
              ),
              _ThemeOption(
                title: 'Light',
                subtitle: 'Light theme',
                icon: Icons.light_mode,
                isSelected: themeProvider.themeMode == ThemeMode.light,
                onTap: () => themeProvider.setThemeMode(ThemeMode.light),
              ),
              _ThemeOption(
                title: 'Dark',
                subtitle: 'Dark theme',
                icon: Icons.dark_mode,
                isSelected: themeProvider.themeMode == ThemeMode.dark,
                onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : null,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: colorScheme.primary,
            )
          : null,
    );
  }
}
