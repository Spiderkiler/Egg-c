/// 本地存储服务
/// 基于 Hive 的本地数据持久化服务，管理所有 App 数据的读写
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../models/focus_record_model.dart';
import '../models/achievement_model.dart';
import '../models/user_settings_model.dart';

class StorageService {
  /// 任务数据 Box 名称
  static const String _tasksBoxName = 'tasks';

  /// 专注记录 Box 名称
  static const String _focusRecordsBoxName = 'focus_records';

  /// 成就数据 Box 名称
  static const String _achievementsBoxName = 'achievements';

  /// 用户设置 Box 名称
  static const String _settingsBoxName = 'settings';

  /// 初始化存储服务
  static Future<void> init() async {
    await Hive.initFlutter();

    // 注册所有 Hive 适配器（使用自定义序列化，无需代码生成）
    _registerAdapters();

    // 打开所有 Box
    await Future.wait([
      Hive.openBox<TaskModel>(_tasksBoxName),
      Hive.openBox<FocusRecordModel>(_focusRecordsBoxName),
      Hive.openBox<AchievementModel>(_achievementsBoxName),
      Hive.openBox<UserSettingsModel>(_settingsBoxName),
    ]);
  }

  /// 注册 Hive 适配器
  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FocusRecordModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AchievementModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(UserSettingsModelAdapter());
    }
  }

  // ==================== 任务相关操作 ====================

  /// 获取任务 Box
  static Box<TaskModel> get tasksBox => Hive.box<TaskModel>(_tasksBoxName);

  /// 获取所有任务列表（未完成的在前）
  static List<TaskModel> getAllTasks() {
    final tasks = tasksBox.values.toList();
    tasks.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createTime.compareTo(a.createTime);
    });
    return tasks;
  }

  /// 获取未完成任务列表
  static List<TaskModel> getActiveTasks() {
    return getAllTasks().where((t) => !t.isCompleted).toList();
  }

  /// 获取已完成任务列表
  static List<TaskModel> getCompletedTasks() {
    return getAllTasks().where((t) => t.isCompleted).toList();
  }

  /// 根据ID获取任务
  static TaskModel? getTaskById(String id) {
    return tasksBox.get(id);
  }

  /// 保存任务（新增或更新）
  static Future<void> saveTask(TaskModel task) async {
    await tasksBox.put(task.id, task);
  }

  /// 删除任务
  static Future<void> deleteTask(String id) async {
    await tasksBox.delete(id);
  }

  /// 删除所有任务
  static Future<void> deleteAllTasks() async {
    await tasksBox.clear();
  }

  // ==================== 专注记录相关操作 ====================

  /// 获取专注记录 Box
  static Box<FocusRecordModel> get focusRecordsBox =>
      Hive.box<FocusRecordModel>(_focusRecordsBoxName);

  /// 获取所有专注记录
  static List<FocusRecordModel> getAllFocusRecords() {
    final records = focusRecordsBox.values.toList();
    records.sort((a, b) => b.startTime.compareTo(a.startTime));
    return records;
  }

  /// 获取指定日期范围的专注记录
  static List<FocusRecordModel> getFocusRecordsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    return getAllFocusRecords().where((r) {
      return r.startTime.isAfter(start) && r.startTime.isBefore(end);
    }).toList();
  }

  /// 获取今日专注记录
  static List<FocusRecordModel> getTodayFocusRecords() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    return getFocusRecordsByDateRange(todayStart, todayEnd);
  }

  /// 获取本周专注记录
  static List<FocusRecordModel> getWeekFocusRecords() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final weekEnd = weekStartDay.add(const Duration(days: 7));
    return getFocusRecordsByDateRange(weekStartDay, weekEnd);
  }

  /// 获取本月专注记录
  static List<FocusRecordModel> getMonthFocusRecords() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 1);
    return getFocusRecordsByDateRange(monthStart, monthEnd);
  }

  /// 保存专注记录
  static Future<void> saveFocusRecord(FocusRecordModel record) async {
    await focusRecordsBox.put(record.id, record);
  }

  /// 获取今日总专注秒数
  static int getTodayTotalFocusSeconds() {
    return getTodayFocusRecords()
        .where((r) => r.isCompleted)
        .fold(0, (sum, r) => sum + r.actualSeconds);
  }

  /// 获取累计总专注秒数
  static int getTotalFocusSeconds() {
    return getAllFocusRecords()
        .where((r) => r.isCompleted)
        .fold(0, (sum, r) => sum + r.actualSeconds);
  }

  /// 获取已完成专注次数
  static int getCompletedFocusCount() {
    return getAllFocusRecords()
        .where((r) => r.isCompleted && r.type == FocusType.focus)
        .length;
  }

  /// 获取连续打卡天数
  static int getStreakDays() {
    final records = getAllFocusRecords()
        .where((r) => r.isCompleted && r.type == FocusType.focus)
        .toList();

    if (records.isEmpty) return 0;

    // 获取所有有专注记录的日期集合
    final focusDates = <DateTime>{};
    for (final record in records) {
      final date = DateTime(
        record.startTime.year,
        record.startTime.month,
        record.startTime.day,
      );
      focusDates.add(date);
    }

    // 从今天开始计算连续天数
    int streak = 0;
    final today = DateTime.now();
    var checkDate = DateTime(today.year, today.month, today.day);

    while (focusDates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // 如果今天还没有记录，检查昨天
    if (streak == 0) {
      checkDate = DateTime(today.year, today.month, today.day)
          .subtract(const Duration(days: 1));
      while (focusDates.contains(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }

    return streak;
  }

  // ==================== 成就相关操作 ====================

  /// 获取成就 Box
  static Box<AchievementModel> get achievementsBox =>
      Hive.box<AchievementModel>(_achievementsBoxName);

  /// 获取所有成就
  static List<AchievementModel> getAllAchievements() {
    return achievementsBox.values.toList();
  }

  /// 根据ID获取成就
  static AchievementModel? getAchievementById(String id) {
    return achievementsBox.get(id);
  }

  /// 保存成就
  static Future<void> saveAchievement(AchievementModel achievement) async {
    await achievementsBox.put(achievement.id, achievement);
  }

  /// 初始化默认成就列表
  static Future<void> initDefaultAchievements() async {
    if (achievementsBox.isNotEmpty) return;

    final defaults = [
      AchievementModel(
        id: 'ach_1',
        name: '初出蛋壳',
        description: '完成1次专注',
        icon: '🥚',
        targetCount: 1,
      ),
      AchievementModel(
        id: 'ach_2',
        name: '小鸡成长',
        description: '完成10次专注',
        icon: '🐣',
        targetCount: 10,
      ),
      AchievementModel(
        id: 'ach_3',
        name: '破壳而出',
        description: '完成25次专注',
        icon: '🐥',
        targetCount: 25,
      ),
      AchievementModel(
        id: 'ach_4',
        name: '阳光沐浴',
        description: '累计专注10小时',
        icon: '☀️',
        targetCount: 10,
      ),
      AchievementModel(
        id: 'ach_5',
        name: '黄金蛋黄',
        description: '累计专注100小时',
        icon: '🌞',
        targetCount: 100,
      ),
      AchievementModel(
        id: 'ach_6',
        name: '咸蛋大师',
        description: '累计专注500小时',
        icon: '🏆',
        targetCount: 500,
      ),
      AchievementModel(
        id: 'ach_7',
        name: '七天连续',
        description: '连续打卡7天',
        icon: '🔥',
        targetCount: 7,
      ),
      AchievementModel(
        id: 'ach_8',
        name: '一月坚持',
        description: '连续打卡30天',
        icon: '💪',
        targetCount: 30,
      ),
      AchievementModel(
        id: 'ach_9',
        name: '任务收割者',
        description: '完成10个任务',
        icon: '✅',
        targetCount: 10,
      ),
      AchievementModel(
        id: 'ach_10',
        name: '效率超人',
        description: '单日完成8次专注',
        icon: '⚡',
        targetCount: 8,
      ),
    ];

    for (final achievement in defaults) {
      await saveAchievement(achievement);
    }
  }

  // ==================== 设置相关操作 ====================

  /// 获取设置 Box
  static Box<UserSettingsModel> get settingsBox =>
      Hive.box<UserSettingsModel>(_settingsBoxName);

  /// 获取用户设置
  static UserSettingsModel getSettings() {
    if (settingsBox.isEmpty) {
      final defaultSettings = UserSettingsModel();
      settingsBox.put('user_settings', defaultSettings);
      return defaultSettings;
    }
    return settingsBox.get('user_settings')!;
  }

  /// 保存用户设置
  static Future<void> saveSettings(UserSettingsModel settings) async {
    await settingsBox.put('user_settings', settings);
  }
}

// ==========================================
// Hive 自定义适配器（手动序列化，无需 build_runner）
// ==========================================

/// TaskModel 适配器
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      expectedPomodoros: reader.readInt32(),
      completedPomodoros: reader.readInt32(),
      isCompleted: reader.readBool(),
      createTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt32()),
      completedTime: reader.readBool()
          ? DateTime.fromMillisecondsSinceEpoch(reader.readInt32())
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeInt32(obj.expectedPomodoros);
    writer.writeInt32(obj.completedPomodoros);
    writer.writeBool(obj.isCompleted);
    writer.writeInt32(obj.createTime.millisecondsSinceEpoch);
    writer.writeBool(obj.completedTime != null);
    if (obj.completedTime != null) {
      writer.writeInt32(obj.completedTime!.millisecondsSinceEpoch);
    }
  }
}

/// FocusRecordModel 适配器
class FocusRecordModelAdapter extends TypeAdapter<FocusRecordModel> {
  @override
  final int typeId = 1;

  @override
  FocusRecordModel read(BinaryReader reader) {
    return FocusRecordModel(
      id: reader.readString(),
      type: FocusType.values[reader.readInt32()],
      durationMinutes: reader.readInt32(),
      actualSeconds: reader.readInt32(),
      startTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt32()),
      endTime: reader.readBool()
          ? DateTime.fromMillisecondsSinceEpoch(reader.readInt32())
          : null,
      isCompleted: reader.readBool(),
      taskId: reader.readBool() ? reader.readString() : null,
    );
  }

  @override
  void write(BinaryWriter writer, FocusRecordModel obj) {
    writer.writeString(obj.id);
    writer.writeInt32(obj.type.index);
    writer.writeInt32(obj.durationMinutes);
    writer.writeInt32(obj.actualSeconds);
    writer.writeInt32(obj.startTime.millisecondsSinceEpoch);
    writer.writeBool(obj.endTime != null);
    if (obj.endTime != null) {
      writer.writeInt32(obj.endTime!.millisecondsSinceEpoch);
    }
    writer.writeBool(obj.isCompleted);
    writer.writeBool(obj.taskId != null);
    if (obj.taskId != null) {
      writer.writeString(obj.taskId!);
    }
  }
}

/// AchievementModel 适配器
class AchievementModelAdapter extends TypeAdapter<AchievementModel> {
  @override
  final int typeId = 2;

  @override
  AchievementModel read(BinaryReader reader) {
    return AchievementModel(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString(),
      icon: reader.readString(),
      targetCount: reader.readInt32(),
      currentCount: reader.readInt32(),
      status: AchievementStatus.values[reader.readInt32()],
      unlockedTime: reader.readBool()
          ? DateTime.fromMillisecondsSinceEpoch(reader.readInt32())
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, AchievementModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.icon);
    writer.writeInt32(obj.targetCount);
    writer.writeInt32(obj.currentCount);
    writer.writeInt32(obj.status.index);
    writer.writeBool(obj.unlockedTime != null);
    if (obj.unlockedTime != null) {
      writer.writeInt32(obj.unlockedTime!.millisecondsSinceEpoch);
    }
  }
}

/// UserSettingsModel 适配器
class UserSettingsModelAdapter extends TypeAdapter<UserSettingsModel> {
  @override
  final int typeId = 3;

  @override
  UserSettingsModel read(BinaryReader reader) {
    return UserSettingsModel(
      focusDuration: reader.readInt32(),
      shortBreakDuration: reader.readInt32(),
      longBreakDuration: reader.readInt32(),
      longBreakInterval: reader.readInt32(),
      themeMode: ThemeMode.values[reader.readInt32()],
      notificationsEnabled: reader.readBool(),
      soundEnabled: reader.readBool(),
      soundVolume: reader.readDouble(),
      selectedSound: reader.readString(),
      autoStartBreak: reader.readBool(),
      autoStartFocus: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingsModel obj) {
    writer.writeInt32(obj.focusDuration);
    writer.writeInt32(obj.shortBreakDuration);
    writer.writeInt32(obj.longBreakDuration);
    writer.writeInt32(obj.longBreakInterval);
    writer.writeInt32(obj.themeMode.index);
    writer.writeBool(obj.notificationsEnabled);
    writer.writeBool(obj.soundEnabled);
    writer.writeDouble(obj.soundVolume);
    writer.writeString(obj.selectedSound);
    writer.writeBool(obj.autoStartBreak);
    writer.writeBool(obj.autoStartFocus);
  }
}
