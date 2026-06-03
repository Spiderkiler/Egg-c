/// 成就系统服务
/// 负责追踪用户进度并自动解锁成就
import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';
import '../models/focus_record_model.dart';
import 'storage_service.dart';
import 'notification_service.dart';

class AchievementService extends ChangeNotifier {
  final NotificationService _notificationService;

  /// 已解锁成就数量
  int _unlockedCount = 0;

  /// 总成就数量
  int _totalCount = 0;

  /// 获取已解锁成就数量
  int get unlockedCount => _unlockedCount;

  /// 获取总成就数量
  int get totalCount => _totalCount;

  /// 获取所有成就列表
  List<AchievementModel> get achievements =>
      StorageService.getAllAchievements();

  AchievementService({
    required NotificationService notificationService,
  })  : _notificationService = notificationService {
    _refreshCounts();
  }

  /// 刷新成就计数
  void _refreshCounts() {
    final all = achievements;
    _totalCount = all.length;
    _unlockedCount = all.where((a) => a.isUnlocked).length;
  }

  /// 检查并更新专注次数相关成就
  Future<void> checkFocusCountAchievements() async {
    final completedCount = StorageService.getCompletedFocusCount();
    final todayRecords = StorageService.getTodayFocusRecords()
        .where((r) => r.isCompleted && r.type == FocusType.focus)
        .length;

    // 按目标次数检查成就
    final countBasedAchievements = achievements
        .where((a) =>
            a.id == 'ach_1' ||
            a.id == 'ach_2' ||
            a.id == 'ach_3' ||
            a.id == 'ach_10');

    for (final ach in countBasedAchievements) {
      if (ach.isUnlocked) continue;

      int relevantCount = ach.id == 'ach_10' ? todayRecords : completedCount;

      ach.currentCount = relevantCount.clamp(0, ach.targetCount);

      if (ach.currentCount >= ach.targetCount) {
        ach.status = AchievementStatus.unlocked;
        ach.unlockedTime = DateTime.now();
        await StorageService.saveAchievement(ach);
        await _notificationService.showAchievementNotification(
            ach.name, ach.icon);
      } else {
        await StorageService.saveAchievement(ach);
      }
    }

    _refreshCounts();
    notifyListeners();
  }

  /// 检查并更新累计时长相关成就
  Future<void> checkTotalHoursAchievements() async {
    final totalMinutes =
        StorageService.getTotalFocusSeconds() / 60; // 转为分钟
    final totalHours = totalMinutes / 60;

    final hourBasedAchievements = achievements
        .where((a) => a.id == 'ach_4' || a.id == 'ach_5' || a.id == 'ach_6');

    for (final ach in hourBasedAchievements) {
      if (ach.isUnlocked) continue;

      ach.currentCount = totalHours.round().clamp(0, ach.targetCount);

      if (ach.currentCount >= ach.targetCount) {
        ach.status = AchievementStatus.unlocked;
        ach.unlockedTime = DateTime.now();
        await StorageService.saveAchievement(ach);
        await _notificationService.showAchievementNotification(
            ach.name, ach.icon);
      } else {
        await StorageService.saveAchievement(ach);
      }
    }

    _refreshCounts();
    notifyListeners();
  }

  /// 检查连续打卡天数相关成就
  Future<void> checkStreakAchievements() async {
    final streakDays = StorageService.getStreakDays();

    final streakAchievements = achievements
        .where((a) => a.id == 'ach_7' || a.id == 'ach_8');

    for (final ach in streakAchievements) {
      if (ach.isUnlocked) continue;

      ach.currentCount = streakDays.clamp(0, ach.targetCount);

      if (ach.currentCount >= ach.targetCount) {
        ach.status = AchievementStatus.unlocked;
        ach.unlockedTime = DateTime.now();
        await StorageService.saveAchievement(ach);
        await _notificationService.showAchievementNotification(
            ach.name, ach.icon);
      } else {
        await StorageService.saveAchievement(ach);
      }
    }

    _refreshCounts();
    notifyListeners();
  }

  /// 检查任务完成相关成就
  Future<void> checkTaskAchievements() async {
    final completedTasks = StorageService.getCompletedTasks().length;

    final taskAchievements =
        achievements.where((a) => a.id == 'ach_9');

    for (final ach in taskAchievements) {
      if (ach.isUnlocked) continue;

      ach.currentCount = completedTasks.clamp(0, ach.targetCount);

      if (ach.currentCount >= ach.targetCount) {
        ach.status = AchievementStatus.unlocked;
        ach.unlockedTime = DateTime.now();
        await StorageService.saveAchievement(ach);
        await _notificationService.showAchievementNotification(
            ach.name, ach.icon);
      } else {
        await StorageService.saveAchievement(ach);
      }
    }

    _refreshCounts();
    notifyListeners();
  }

  /// 全局成就检查（在所有操作后调用）
  Future<void> checkAll() async {
    await checkFocusCountAchievements();
    await checkTotalHoursAchievements();
    await checkStreakAchievements();
    await checkTaskAchievements();
  }
}
