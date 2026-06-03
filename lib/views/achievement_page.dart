/// 成就页面
/// 展示用户已解锁和未解锁的成就徽章，支持进度追踪
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/achievement_viewmodel.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/glass_card.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementViewModel>().loadAchievements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<AchievementViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题
              Text(
                '🏆 成就殿堂',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '记录你的每一次进步',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white38 : AppColors.textDisabled,
                ),
              ),

              const SizedBox(height: 28),

              // 总进度卡片
              _buildProgressCard(vm, isDark),

              const SizedBox(height: 32),

              // 已解锁成就
              if (vm.unlockedAchievements.isNotEmpty) ...[
                _buildSectionTitle(
                  '✨ 已解锁成就',
                  '${vm.unlockedAchievements.length}',
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildAchievementGrid(vm.unlockedAchievements),
                const SizedBox(height: 28),
              ],

              // 未解锁成就
              if (vm.lockedAchievements.isNotEmpty) ...[
                _buildSectionTitle(
                  '🔒 待解锁成就',
                  '${vm.lockedAchievements.length}',
                  isDark,
                ),
                const SizedBox(height: 16),
                _buildAchievementGrid(vm.lockedAchievements),
              ],

              // 空状态
              if (vm.achievements.isEmpty)
                _buildEmptyState(isDark),
            ],
          ),
        );
      },
    );
  }

  /// 构建总进度卡片
  Widget _buildProgressCard(AchievementViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // 进度环
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: vm.progress,
                  strokeWidth: 6,
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.06)
                      : AppColors.primary.withOpacity(0.08),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(vm.progress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // 进度详情
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '成就进度',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '已解锁 ${vm.unlockedCount} / ${vm.totalCount} 个成就',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isDark ? Colors.white54 : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '继续专注，解锁更多成就！',
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

  /// 构建分区标题
  Widget _buildSectionTitle(String title, String count, bool isDark) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建成就网格
  Widget _buildAchievementGrid(List achievements) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: achievements.map<Widget>((ach) {
        return AchievementBadge(achievement: ach);
      }).toList(),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          Text('🏆', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text(
            '还没有成就哦',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '开始专注，解锁你的第一个成就吧！',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white30 : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}
