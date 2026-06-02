/// 统计页面
/// 展示专注数据的多维度统计图表，包括柱状图、折线图和饼图
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/statistics_viewmodel.dart';
import '../widgets/stat_card.dart';
import '../widgets/glass_card.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatisticsViewModel>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<StatisticsViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题
              Text(
                '📊 数据统计',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '了解你的专注习惯',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white38 : AppColors.textDisabled,
                ),
              ),

              const SizedBox(height: 28),

              // 统计卡片网格
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: '今日专注',
                      value: vm.formattedToday,
                      icon: '🕐',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: '本周专注',
                      value: vm.formattedWeek,
                      icon: '📅',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: '本月专注',
                      value: vm.formattedMonth,
                      icon: '📆',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: '累计专注',
                      value: vm.formattedTotal,
                      icon: '🎯',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: '完成次数',
                      value: '${vm.completedCount}',
                      unit: '次',
                      icon: '🍅',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: '连续打卡',
                      value: '${vm.streakDays}',
                      unit: '天',
                      icon: '🔥',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 本周柱状图
              _buildBarChartCard(vm, isDark).animate().fadeIn(
                    duration: 500.ms,
                    delay: 200.ms,
                  ).slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 200.ms,
                  ),

              const SizedBox(height: 24),

              // 趋势折线图
              _buildLineChartCard(vm, isDark).animate().fadeIn(
                    duration: 500.ms,
                    delay: 350.ms,
                  ).slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 350.ms,
                  ),

              const SizedBox(height: 24),

              // 专注/休息比例饼图
              _buildPieChartCard(vm, isDark).animate().fadeIn(
                    duration: 500.ms,
                    delay: 500.ms,
                  ).slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 500.ms,
                  ),
            ],
          ),
        );
      },
    );
  }

  /// 构建柱状图卡片
  Widget _buildBarChartCard(StatisticsViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📊', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                '本周每日专注时长（小时）',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxBarValue(vm),
                barGroups: vm.getWeekBarData(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.04),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['一', '二', '三', '四', '五', '六', '日'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.white38
                                  : AppColors.textDisabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white30
                                : AppColors.textDisabled,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.toStringAsFixed(1)} 小时',
                        TextStyle(
                          color: isDark ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 获取柱状图最大值
  double _getMaxBarValue(StatisticsViewModel vm) {
    double maxVal = 2.0;
    for (final group in vm.getWeekBarData()) {
      if (group.barRods.isNotEmpty && group.barRods.first.toY > maxVal) {
        maxVal = group.barRods.first.toY;
      }
    }
    return maxVal + 1;
  }

  /// 构建折线图卡片
  Widget _buildLineChartCard(StatisticsViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📈', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                '近30天专注趋势（小时）',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.04),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 7,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${30 - value.toInt()}天前',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? Colors.white30
                                  : AppColors.textDisabled,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white30
                                : AppColors.textDisabled,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: vm.getMonthTrendData(),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withOpacity(0.08),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          '${spot.y.toStringAsFixed(1)} 小时',
                          TextStyle(
                            color:
                                isDark ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建饼图卡片
  Widget _buildPieChartCard(StatisticsViewModel vm, bool isDark) {
    final ratio = vm.getFocusBreakRatio();
    final totalSeconds = (ratio['专注'] ?? 0) + (ratio['休息'] ?? 0);

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🥧', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                '专注/休息时间分布',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: totalSeconds > 0
                ? Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: ratio['专注'] ?? 0,
                                color: AppColors.primary,
                                title:
                                    '${((ratio['专注']! / totalSeconds) * 100).toStringAsFixed(0)}%',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                radius: 60,
                              ),
                              PieChartSectionData(
                                value: ratio['休息'] ?? 0,
                                color: AppColors.success,
                                title:
                                    '${((ratio['休息']! / totalSeconds) * 100).toStringAsFixed(0)}%',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                radius: 60,
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 35,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegend(
                              '🍅 专注',
                              AppColors.primary,
                              _formatHours(
                                  (ratio['专注'] ?? 0) / 3600),
                              isDark),
                          const SizedBox(height: 12),
                          _buildLegend(
                              '☕ 休息',
                              AppColors.success,
                              _formatHours(
                                  (ratio['休息'] ?? 0) / 3600),
                              isDark),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      '暂无数据',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white30
                            : AppColors.textDisabled,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 构建图例
  Widget _buildLegend(String label, Color color, String value, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$label - $value',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// 格式化小时数
  String _formatHours(double hours) {
    if (hours >= 1) {
      return '${hours.toStringAsFixed(1)} 小时';
    }
    final minutes = hours * 60;
    return '${minutes.toStringAsFixed(0)} 分钟';
  }
}
