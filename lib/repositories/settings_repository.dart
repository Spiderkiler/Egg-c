/// 设置数据仓库
/// 封装用户设置的读写操作
import '../models/user_settings_model.dart';
import '../services/storage_service.dart';

class SettingsRepository {
  /// 获取当前设置
  UserSettingsModel get() {
    return StorageService.getSettings();
  }

  /// 保存设置
  Future<void> save(UserSettingsModel settings) async {
    await StorageService.saveSettings(settings);
  }

  /// 更新专注时长
  Future<void> updateFocusDuration(int minutes) async {
    final settings = get();
    await save(settings.copyWith(focusDuration: minutes));
  }

  /// 更新休息时长
  Future<void> updateShortBreakDuration(int minutes) async {
    final settings = get();
    await save(settings.copyWith(shortBreakDuration: minutes));
  }

  /// 更新长休息时长
  Future<void> updateLongBreakDuration(int minutes) async {
    final settings = get();
    await save(settings.copyWith(longBreakDuration: minutes));
  }

  /// 更新主题模式
  Future<void> updateThemeMode(ThemeMode mode) async {
    final settings = get();
    await save(settings.copyWith(themeMode: mode));
  }

  /// 更新通知开关
  Future<void> updateNotifications(bool enabled) async {
    final settings = get();
    await save(settings.copyWith(notificationsEnabled: enabled));
  }

  /// 更新声音开关
  Future<void> updateSoundEnabled(bool enabled) async {
    final settings = get();
    await save(settings.copyWith(soundEnabled: enabled));
  }

  /// 更新声音音量
  Future<void> updateSoundVolume(double volume) async {
    final settings = get();
    await save(settings.copyWith(soundVolume: volume));
  }

  /// 更新选择的声音
  Future<void> updateSelectedSound(String soundId) async {
    final settings = get();
    await save(settings.copyWith(selectedSound: soundId));
  }
}
