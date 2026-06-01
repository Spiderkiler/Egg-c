/// 应用颜色常量
/// 定义咸蛋时钟的所有配色方案，包含浅色和深色模式
import 'package:flutter/material.dart';

class AppColors {
  // ============ 品牌主色 ============

  /// 主色 - 咸蛋黄
  static const Color primary = Color(0xFFFFC93C);

  /// 辅助色 - 蛋壳白
  static const Color secondary = Color(0xFFFFF7D6);

  /// 强调色 - 深蛋黄
  static const Color accent = Color(0xFFFFB703);

  // ============ 功能色 ============

  /// 成功色 - 绿色
  static const Color success = Color(0xFF8BC34A);

  /// 警告色 - 橙色
  static const Color warning = Color(0xFFFF9800);

  /// 错误色 - 红色
  static const Color error = Color(0xFFF44336);

  // ============ 浅色主题 ============

  /// 浅色背景
  static const Color backgroundLight = Color(0xFFFFFDF6);

  /// 浅色表面
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// 浅色主要文本
  static const Color textPrimary = Color(0xFF2D2D2D);

  /// 浅色次要文本
  static const Color textSecondary = Color(0xFF6B6B6B);

  /// 浅色禁用文本
  static const Color textDisabled = Color(0xFFB0B0B0);

  /// 浅色阴影
  static const Color shadowLight = Color(0xFF000000);

  // ============ 深色主题 ============

  /// 深色背景
  static const Color backgroundDark = Color(0xFF1A1A1A);

  /// 深色表面
  static const Color surfaceDark = Color(0xFF252525);

  /// 深色卡片
  static const Color cardDark = Color(0xFF2D2D2D);

  // ============ 其他 ============

  /// 透明
  static const Color transparent = Colors.transparent;

  /// 渐变起始色（温暖阳光）
  static const Color gradientStart = Color(0xFFFFF8E1);

  /// 渐变结束色（柔和暖白）
  static const Color gradientEnd = Color(0xFFFFFDF6);
}

/// Material 浅色主题定义
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surfaceLight,
    error: AppColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: AppColors.surfaceLight,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),
  iconTheme: const IconThemeData(
    color: AppColors.textSecondary,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      color: AppColors.textDisabled,
    ),
  ),
);

/// Material 深色主题定义
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surfaceDark,
    error: AppColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: AppColors.surfaceDark,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white54,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      color: Colors.white70,
    ),
    labelSmall: TextStyle(
      color: Colors.white38,
    ),
  ),
);
