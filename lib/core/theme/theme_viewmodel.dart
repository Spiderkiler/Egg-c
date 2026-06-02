/// 主题状态管理 ViewModel
/// 控制整个应用的主题切换，提供响应式的主题变化
library;
import 'package:flutter/material.dart';
import '../../models/user_settings_model.dart' as model;
import '../../repositories/settings_repository.dart';
import 'app_theme.dart';

class ThemeViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;

  /// 当前主题模式
  ThemeMode _themeMode = ThemeMode.system;

  /// 当前是否为深色模式
  bool _isDark = false;

  ThemeViewModel({
    required SettingsRepository settingsRepository,
  }) : _settingsRepository = settingsRepository {
    _loadTheme();
  }

  /// 获取当前主题模式
  ThemeMode get themeMode => _themeMode;

  /// 主题模式显示文本
  String get themeModeLabel {
    switch (_themeMode) {
      case ThemeMode.light:
        return '浅色';
      case ThemeMode.dark:
        return '深色';
      case ThemeMode.system:
        return '跟随系统';
    }
  }

  /// 是否深色模式
  bool get isDark => _isDark;

  /// 获取当前主题数据
  ThemeData get themeData => AppTheme.getTheme(_themeMode, isDark: _isDark);

  /// 加载保存的主题设置
  void _loadTheme() {
    final settings = _settingsRepository.get();
    // 将模型层的 ThemeMode 转换为 Flutter 的 ThemeMode
    _themeMode = _toFlutterThemeMode(settings.themeMode);
    notifyListeners();
  }

  /// 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    // 同步更新 _isDark，确保外部能正确感知当前深色状态
    if (mode == ThemeMode.dark) {
      _isDark = true;
    } else if (mode == ThemeMode.light) {
      _isDark = false;
    }
    // ThemeMode.system 时保持平台亮度状态不变
    // 将 Flutter 的 ThemeMode 转换为模型层的 ThemeMode 进行存储
    await _settingsRepository.updateThemeMode(_toModelThemeMode(mode));
    notifyListeners();
  }

  /// 切换主题模式（循环）
  Future<void> cycleThemeMode() async {
    final next = ThemeMode
        .values[(_themeMode.index + 1) % ThemeMode.values.length];
    await setThemeMode(next);
  }

  /// 将模型层的 ThemeMode 转换为 Flutter 的 ThemeMode
  ThemeMode _toFlutterThemeMode(model.ThemeMode mode) {
    switch (mode) {
      case model.ThemeMode.light:
        return ThemeMode.light;
      case model.ThemeMode.dark:
        return ThemeMode.dark;
      case model.ThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// 将 Flutter 的 ThemeMode 转换为模型层的 ThemeMode
  model.ThemeMode _toModelThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return model.ThemeMode.light;
      case ThemeMode.dark:
        return model.ThemeMode.dark;
      case ThemeMode.system:
        return model.ThemeMode.system;
    }
  }

  /// 获取 Material 主题的亮度
  Brightness get brightness =>
      _isDark ? Brightness.dark : Brightness.light;

  /// 更新平台亮度状态（由外部调用）
  void updatePlatformBrightness(Brightness brightness) {
    final newIsDark = brightness == Brightness.dark;
    if (_isDark != newIsDark) {
      _isDark = newIsDark;
      notifyListeners();
    }
  }
}
