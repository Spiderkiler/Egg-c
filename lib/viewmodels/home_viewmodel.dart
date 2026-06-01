/// 首页 ViewModel
/// 管理首页的数据展示，包括今日专注时间、任务统计、打卡天数等
import 'package:flutter/foundation.dart';
import '../repositories/focus_repository.dart';
import '../repositories/task_repository.dart';
import '../utils/time_utils.dart';

class HomeViewModel extends ChangeNotifier {
  final FocusRepository _focusRepository;
  final TaskRepository _taskRepository;

  /// 今日专注秒数
  int todayFocusSeconds = 0;

  /// 今日完成任务数
  int todayCompletedTasks = 0;

  /// 连续打卡天数
  int streakDays = 0;

  /// 今日专注次数
  int todayFocusCount = 0;

  /// 专注等级（1-10）
  int focusLevel = 1;

  /// 专注等级名称
  String focusLevelName = '初级专注者';

  HomeViewModel({
    required FocusRepository focusRepository,
    required TaskRepository taskRepository,
  })  : _focusRepository = focusRepository,
        _taskRepository = taskRepository;

  /// 获取当前日期字符串
  String get formattedDate => TimeUtils.getFormattedDate();

  /// 获取当前时间字符串
  String get formattedTime => TimeUtils.getFormattedTime();

  /// 获取欢迎语
  String get greeting => TimeUtils.getGreeting();

  /// 获取格式化后的今日专注时长
  String get formattedTodayFocus =>
      TimeUtils.formatSeconds(todayFocusSeconds);

  /// 刷新所有首页数据
  void refresh() {
    todayFocusSeconds = _focusRepository.getTodayTotalSeconds();
    todayCompletedTasks =
        _taskRepository
            .getCompleted()
            .where((t) {
              if (t.completedTime == null) return false;
              return TimeUtils.isSameDay(t.completedTime!, DateTime.now());
            })
            .length;
    streakDays = _focusRepository.getStreakDays();
    todayFocusCount = _focusRepository.getTodayFocusCount();
    _updateFocusLevel();
    notifyListeners();
  }

  /// 根据累计专注时长更新专注等级
  void _updateFocusLevel() {
    final totalHours = _focusRepository.getTotalSeconds() / 3600;

    if (totalHours >= 500) {
      focusLevel = 10;
      focusLevelName = '咸蛋大师';
    } else if (totalHours >= 250) {
      focusLevel = 9;
      focusLevelName = '黄金蛋黄';
    } else if (totalHours >= 100) {
      focusLevel = 8;
      focusLevelName = '专注达人';
    } else if (totalHours >= 50) {
      focusLevel = 7;
      focusLevelName = '效率高手';
    } else if (totalHours >= 25) {
      focusLevel = 6;
      focusLevelName = '专注新星';
    } else if (totalHours >= 10) {
      focusLevel = 5;
      focusLevelName = '成长小鸡';
    } else if (totalHours >= 5) {
      focusLevel = 4;
      focusLevelName = '初具雏形';
    } else if (totalHours >= 2) {
      focusLevel = 3;
      focusLevelName = '温暖孵化';
    } else if (totalHours >= 1) {
      focusLevel = 2;
      focusLevelName = '破壳而出';
    } else {
      focusLevel = 1;
      focusLevelName = '初出蛋壳';
    }
  }
}
