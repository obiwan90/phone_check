import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeController extends GetxController {
  static const String themeBoxName = 'theme_box';
  static const String themeKey = 'is_dark_mode';

  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  Future<void> _loadThemeFromStorage() async {
    final box = await Hive.openBox(themeBoxName);
    final isDark = box.get(themeKey, defaultValue: false) as bool;
    _isDarkMode.value = isDark;
    _updateTheme();
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    final box = await Hive.openBox(themeBoxName);
    await box.put(themeKey, _isDarkMode.value);
    _updateTheme();
  }

  void _updateTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  ThemeData getLightTheme() {
    const primaryColor = Color(0xFF2196F3); // 明亮蓝色
    const secondaryColor = Color(0xFF8E24AA); // 紫色
    const backgroundColor = Color(0xFFF8F9FA); // 浅灰背景

    final colorScheme = ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: primaryColor.withOpacity(0.15),
      onPrimaryContainer: primaryColor.withOpacity(0.85),
      secondary: secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: secondaryColor.withOpacity(0.15),
      onSecondaryContainer: secondaryColor.withOpacity(0.85),
      tertiary: const Color(0xFF00BFA5), // 青绿色
      error: const Color(0xFFE53935),
      errorContainer: const Color(0xFFFFEBEE),
      onErrorContainer: const Color(0xFFB71C1C),
      background: backgroundColor,
      onBackground: const Color(0xFF1C1C1E),
      surface: Colors.white,
      onSurface: const Color(0xFF1C1C1E),
      surfaceVariant: const Color(0xFFF3F3F3),
      onSurfaceVariant: const Color(0xFF6B6B6B),
      surfaceTint: Colors.transparent,
      outline: const Color(0xFFE0E0E0),
      shadow: Colors.black.withOpacity(0.1),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        elevation: 0,
      ),
    );
  }

  ThemeData getDarkTheme() {
    const primaryColor = Color(0xFF64B5F6); // 柔和蓝色
    const secondaryColor = Color(0xFFAB47BC); // 紫色
    const backgroundColor = Color(0xFF121212); // 深色背景

    final colorScheme = ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.black,
      primaryContainer: primaryColor.withOpacity(0.15),
      onPrimaryContainer: primaryColor.withOpacity(0.85),
      secondary: secondaryColor,
      onSecondary: Colors.black,
      secondaryContainer: secondaryColor.withOpacity(0.15),
      onSecondaryContainer: secondaryColor.withOpacity(0.85),
      tertiary: const Color(0xFF26A69A), // 青绿色
      error: const Color(0xFFEF5350),
      errorContainer: const Color(0xFF442726),
      onErrorContainer: const Color(0xFFFFCDD2),
      background: backgroundColor,
      onBackground: Colors.white,
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
      surfaceVariant: const Color(0xFF2C2C2C),
      onSurfaceVariant: const Color(0xFFAAAAAA),
      surfaceTint: Colors.transparent,
      outline: const Color(0xFF3E3E3E),
      shadow: Colors.black.withOpacity(0.3),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        elevation: 0,
      ),
    );
  }
}
