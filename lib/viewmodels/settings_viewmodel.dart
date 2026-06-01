
/// 设置页面 ViewModel
/// 管理用户的所有偏好设置
library;
import 'package:flutter/foundation.dart';
import '../models/user_settings_model.dart';
import '../models/sound_model.dart';
import '../repositories/settings_repository.dart';
import '../services/sound_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _settingsRepository;
  final SoundService _soundService;

  /// 当前用户设置
  late UserSettingsModel _settings;

  /// 可用的白噪音列表
  List<SoundModel> get availableSounds => SoundModel.builtInSounds;

  SettingsViewModel({
    required SettingsRepository settingsRepository,
    required SoundService soundService,
  })  : _settingsRepository = settingsRepository,
        _soundService = soundService {
    _settings = _settingsRepository.get();
  }

  // ============ Getters ============

  UserSettingsModel get settings => _settings;

  int get focusDuration => _settings.focusDuration;
  int get shortBreakDuration => _settings.shortBreakDuration;
  int get longBreakDuration => _settings.longBreakDuration;
  int get longBreakInterval => _settings.longBreakInterval;
  ThemeMode get themeMode => _settings.themeMode;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get soundEnabled => _settings.soundEnabled;
  double get soundVolume => _settings.soundVolume;
  String get selectedSound => _settings.selectedSound;
  bool get autoStartBreak => _settings.autoStartBreak;
  bool get autoStartFocus => _settings.autoStartFocus;

  // ============ 设置操作 ============

  /// 更新专注时长
  Future<void> setFocusDuration(int minutes) async {
    _settings = _settings.copyWith(focusDuration: minutes);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  /// 更新短休息时长
  Future<void> setShortBreakDuration(int minutes) async {
    _settings = _settings.copyWith(shortBreakDuration: minutes);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  /// 更新长休息时长
  Future<void> setLongBreakDuration(int minutes) async {
    _settings = _settings.copyWith(longBreakDuration: minutes);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  /// 更新长休息间隔
  Future<void> setLongBreakInterval(int interval) async {
    _settings = _settings.copyWith(longBreakInterval: interval);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  /// 更新通知开关
  Future<void> setNotificationsEnabled(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  /// 更新声音开关
  Future<void> setSoundEnabled(bool enabled) async {
    _settings = _settings.copyWith(soundEnabled: enabled);
    await _settingsRepository.save(_settings);

    if (!enabled) {
      await _soundService.stop();
    }
    notifyListeners();
  }

  /// 更新声音音量
  Future<void> setSoundVolume(double volume) async {
    _settings = _settings.copyWith(soundVolume: volume);
    await _settingsRepository.save(_settings);
    await _soundService.setVolume(volume);
    notifyListeners();
  }

  /// 选择白噪音
  Future<void> selectSound(String soundId) async {
    _settings = _settings.copyWith(selectedSound: soundId);
    await _settingsRepository.save(_settings);

    final sound = availableSounds.firstWhere((s) => s.id == soundId);
    await _soundService.play(soundId, sound.assetPath);
    notifyListeners();
  }

  /// 更新自动开始休息
  Future<void> setAutoStartBreak(bool enabled) async {
    _settings = _settings.copyWith(autoStartBreak: enabled);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  /// 更新自动开始专注
  Future<void> setAutoStartFocus(bool enabled) async {
    _settings = _settings.copyWith(autoStartFocus: enabled);
    await _settingsRepository.save(_settings);
    notifyListeners();
  }

  /// 重新加载设置
  void reload() {
    _settings = _settingsRepository.get();
    notifyListeners();
  }
}
