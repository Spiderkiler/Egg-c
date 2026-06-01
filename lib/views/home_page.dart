/// 首页
/// 展示当前日期时间、今日专注概况、快捷统计卡片
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/welcome_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/glass_card.dart';
import '../utils/time_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 延迟加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 欢迎头部
              WelcomeHeader(
                date: viewModel.formattedDate,
                time: viewModel.formattedTime,
                greeting: viewModel.greeting,
              ),

              const SizedBox(height: 36),

              // 主要统计卡片
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildMainFocusCard(viewModel, isDark),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: _buildStatsColumn(viewModel, isDark),
                  ),
                ],
              ).animate().fadeIn(
                    duration: 500.ms,
                    delay: 300.ms,
                  ).slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 300.ms,
                    curve: Curves.easeOut,
                  ),

              const SizedBox(height: 28),

              // 专注等级卡片
              _buildLevelCard(viewModel, isDark)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 500.ms,
                    delay: 400.ms,
                    curve: Curves.easeOut,
                  ),
            ],
          ),
        );
      },
    );
  }

  /// 构建主专注卡片
  Widget _buildMainFocusCard(HomeViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '🍳',
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日专注',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '保持专注，持续成长',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? Colors.white38
                          : AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          // 今日专注时长
          Text(
            vm.formattedTodayFocus,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w200,
              color: isDark ? Colors.white : AppColors.textPrimary,
              fontFamily: 'monospace',
              letterSpacing: 2,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 4),
          Text(
            '专注时长',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : AppColors.textDisabled,
            ),
          ),

          const SizedBox(height: 24),

          // 快捷信息行
          Row(
            children: [
              _buildInfoChip('🍅', '${vm.todayFocusCount} 次专注', isDark),
              const SizedBox(width: 16),
              _buildInfoChip('📝', '${vm.todayCompletedTasks} 个任务', isDark),
              const SizedBox(width: 16),
              _buildInfoChip('🔥', '连续 ${vm.streakDays} 天', isDark),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建信息标签
  Widget _buildInfoChip(String icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建统计卡片列
  Widget _buildStatsColumn(HomeViewModel vm, bool isDark) {
    return Column(
      children: [
        StatCard(
          title: '完成任务',
          value: '${vm.todayCompletedTasks}',
          unit: '个',
          icon: '✅',
        ),
        const SizedBox(height: 20),
        StatCard(
          title: '连续打卡',
          value: '${vm.streakDays}',
          unit: '天',
          icon: '🔥',
        ),
      ],
    );
  }

  /// 构建专注等级卡片
  Widget _buildLevelCard(HomeViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // 等级徽章
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '🥚',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // 等级信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vm.focusLevelName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Lv.${vm.focusLevel}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 等级进度条
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: vm.focusLevel / 10.0,
                    minHeight: 8,
                    backgroundColor: isDark
                        ? Colors.white.withOpacity(0.06)
                        : AppColors.primary.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '距离下一级还需要更多专注时间',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white30
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
