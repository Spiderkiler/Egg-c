/// 统计页面 ViewModel
/// 管理专注数据的统计分析和图表数据
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/focus_record_model.dart';
import '../repositories/focus_repository.dart';
import '../utils/time_utils.dart';

class StatisticsViewModel extends ChangeNotifier {
  final FocusRepository _focusRepository;

  /// 今日专注秒数
  int todaySeconds = 0;

  /// 本周专注秒数
  int weekSeconds = 0;

  /// 本月专注秒数
  int monthSeconds = 0;

  /// 累计专注秒数
  int totalSeconds = 0;

  /// 完成专注次数
  int completedCount = 0;

  /// 连续打卡天数
  int streakDays = 0;

  /// 今日专注次数
  int todayCount = 0;

  StatisticsViewModel({
    required FocusRepository focusRepository,
  }) : _focusRepository = focusRepository;

  /// 格式化的今日时长
  String get formattedToday => TimeUtils.formatSeconds(todaySeconds);

  /// 格式化的本周时长
  String get formattedWeek => TimeUtils.formatSeconds(weekSeconds);

  /// 格式化的本月时长
  String get formattedMonth => TimeUtils.formatSeconds(monthSeconds);

  /// 格式化的累计时长
  String get formattedTotal => TimeUtils.formatSeconds(totalSeconds);

  /// 刷新所有统计数据
  void refresh() {
    todaySeconds = _focusRepository.getTodayTotalSeconds();

    final weekRecords = _focusRepository.getWeek();
    weekSeconds = weekRecords
        .where((r) => r.isCompleted)
        .fold(0, (sum, r) => sum + r.actualSeconds);

    final monthRecords = _focusRepository.getMonth();
    monthSeconds = monthRecords
        .where((r) => r.isCompleted)
        .fold(0, (sum, r) => sum + r.actualSeconds);

    totalSeconds = _focusRepository.getTotalSeconds();
    completedCount = _focusRepository.getCompletedCount();
    streakDays = _focusRepository.getStreakDays();
    todayCount = _focusRepository.getTodayFocusCount();

    notifyListeners();
  }

  /// 获取本周每日专注时长（用于柱状图）
  List<BarChartGroupData> getWeekBarData() {
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    return List.generate(7, (i) {
      final day = weekStart.add(Duration(days: i));
      final dayEnd = day.add(const Duration(days: 1));

      final daySeconds = _focusRepository
          .getAll()
          .where((r) =>
              r.isCompleted &&
              r.startTime.isAfter(day) &&
              r.startTime.isBefore(dayEnd))
          .fold(0, (sum, r) => sum + r.actualSeconds);

      final hours = daySeconds / 3600;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: hours,
            width: 16,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(6),
            ),
          ),
        ],
      );
    });
  }

  /// 获取最近30天专注趋势（用于折线图）
  List<FlSpot> getMonthTrendData() {
    final now = DateTime.now();
    final spots = <FlSpot>[];

    for (int i = 29; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i));
      final dayEnd = day.add(const Duration(days: 1));

      final daySeconds = _focusRepository
          .getAll()
          .where((r) =>
              r.isCompleted &&
              r.type == FocusType.focus &&
              r.startTime.isAfter(day) &&
              r.startTime.isBefore(dayEnd))
          .fold(0, (sum, r) => sum + r.actualSeconds);

      final hours = daySeconds / 3600;
      spots.add(FlSpot((29 - i).toDouble(), hours));
    }

    return spots;
  }

  /// 获取专注/休息比例（用于饼图）
  Map<String, double> getFocusBreakRatio() {
    final allRecords = _focusRepository.getAll()
        .where((r) => r.isCompleted);

    final focusSeconds = allRecords
        .where((r) => r.type == FocusType.focus)
        .fold(0, (sum, r) => sum + r.actualSeconds);

    final breakSeconds = allRecords
        .where((r) =>
            r.type == FocusType.shortBreak ||
            r.type == FocusType.longBreak)
        .fold(0, (sum, r) => sum + r.actualSeconds);

    return {
      '专注': focusSeconds.toDouble(),
      '休息': breakSeconds.toDouble(),
    };
  }
}
