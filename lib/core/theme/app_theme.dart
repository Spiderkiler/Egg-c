/// 应用主题管理
/// 根据用户设置切换浅色/深色/跟随系统主题
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  /// 根据主题模式获取对应的 ThemeData
  static ThemeData getTheme(ThemeMode mode, {bool isDark = false}) {
    if (mode == ThemeMode.dark || (mode == ThemeMode.system && isDark)) {
      return darkTheme;
    }
    return lightTheme;
  }

  /// 获取浅色渐变背景
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF8E1),
      Color(0xFFFFFDF6),
    ],
  );

  /// 获取深色渐变背景
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E1E1E),
      Color(0xFF1A1A1A),
    ],
  );

  /// 获取卡片渐变背景
  static LinearGradient getCardGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              Colors.white.withOpacity(0.06),
              Colors.white.withOpacity(0.02),
            ]
          : [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.7),
            ],
    );
  }
}
