/// 用户设置数据模型
/// 用于存储和同步用户的所有偏好设置
import 'package:hive/hive.dart';

/// 主题模式枚举
enum ThemeMode {
  /// 浅色
  light,

  /// 深色
  dark,

  /// 跟随系统
  system,
}

@HiveType(typeId: 3)
class UserSettingsModel extends HiveObject {
  @HiveField(0)
  int focusDuration;

  @HiveField(1)
  int shortBreakDuration;

  @HiveField(2)
  int longBreakDuration;

  @HiveField(3)
  int longBreakInterval;

  @HiveField(4)
  ThemeMode themeMode;

  @HiveField(5)
  bool notificationsEnabled;

  @HiveField(6)
  bool soundEnabled;

  @HiveField(7)
  double soundVolume;

  @HiveField(8)
  String selectedSound;

  @HiveField(9)
  bool autoStartBreak;

  @HiveField(10)
  bool autoStartFocus;

  /// 创建默认用户设置
  UserSettingsModel({
    this.focusDuration = 25,
    this.shortBreakDuration = 5,
    this.longBreakDuration = 15,
    this.longBreakInterval = 4,
    this.themeMode = ThemeMode.system,
    this.notificationsEnabled = true,
    this.soundEnabled = false,
    this.soundVolume = 0.5,
    this.selectedSound = 'rain',
    this.autoStartBreak = false,
    this.autoStartFocus = false,
  });

  /// 从JSON创建设置对象
  factory UserSettingsModel.fromJson(Map<String, dynamic> json) {
    return UserSettingsModel(
      focusDuration: json['focusDuration'] as int? ?? 25,
      shortBreakDuration: json['shortBreakDuration'] as int? ?? 5,
      longBreakDuration: json['longBreakDuration'] as int? ?? 15,
      longBreakInterval: json['longBreakInterval'] as int? ?? 4,
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 2],
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? false,
      soundVolume: (json['soundVolume'] as num?)?.toDouble() ?? 0.5,
      selectedSound: json['selectedSound'] as String? ?? 'rain',
      autoStartBreak: json['autoStartBreak'] as bool? ?? false,
      autoStartFocus: json['autoStartFocus'] as bool? ?? false,
    );
  }

  /// 转为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'focusDuration': focusDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'longBreakInterval': longBreakInterval,
      'themeMode': themeMode.index,
      'notificationsEnabled': notificationsEnabled,
      'soundEnabled': soundEnabled,
      'soundVolume': soundVolume,
      'selectedSound': selectedSound,
      'autoStartBreak': autoStartBreak,
      'autoStartFocus': autoStartFocus,
    };
  }

  /// 复制并更新字段
  UserSettingsModel copyWith({
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? longBreakInterval,
    ThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? soundEnabled,
    double? soundVolume,
    String? selectedSound,
    bool? autoStartBreak,
    bool? autoStartFocus,
  }) {
    return UserSettingsModel(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      selectedSound: selectedSound ?? this.selectedSound,
      autoStartBreak: autoStartBreak ?? this.autoStartBreak,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
    );
  }
}
