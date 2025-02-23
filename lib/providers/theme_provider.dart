import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A provider class that manages the app's theme mode and persists the user's preference.
///
/// This provider handles switching between light, dark, and system themes, and saves
/// the user's preference using SharedPreferences. It extends [ChangeNotifier] to
/// notify widgets when the theme changes.
class ThemeProvider extends ChangeNotifier {
  /// Storage key for the theme mode preference
  static const String _themeKey = 'theme_mode';

  /// Instance of SharedPreferences used to persist theme selection
  final SharedPreferences _prefs;

  /// Current theme mode of the application
  ThemeMode _themeMode;

  /// Creates a new instance of [ThemeProvider].
  ///
  /// Initializes the theme mode from saved preferences, defaulting to system theme
  /// if no preference is found.
  ///
  /// Parameters:
  /// - [_prefs]: SharedPreferences instance for persistent storage
  ThemeProvider(this._prefs)
      : _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == _prefs.getString(_themeKey),
          orElse: () => ThemeMode.system,
        );

  /// Gets the current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Updates the theme mode and persists the change.
  ///
  /// Parameters:
  /// - [mode]: The new [ThemeMode] to set
  ///
  /// This method will:
  /// 1. Check if the new mode is different from the current mode
  /// 2. Update the theme mode if different
  /// 3. Save the preference to persistent storage
  /// 4. Notify listeners of the change
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  /// Determines if the app should use dark mode.
  ///
  /// Returns true if:
  /// - Theme mode is set to dark explicitly, or
  /// - Theme mode is set to system and the system is using dark mode
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
}
