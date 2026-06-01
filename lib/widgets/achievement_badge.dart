/// 成就徽章组件
/// 单个成就的展示组件，包含图标、进度条、名称等信息
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../models/achievement_model.dart';

class AchievementBadge extends StatelessWidget {
  /// 成就数据
  final AchievementModel achievement;

  /// 徽章尺寸
  final double size;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnlocked = achievement.isUnlocked;

    return Container(
      width: size,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.primary.withOpacity(0.08)
            : (isDark ? Colors.white.withOpacity(0.03) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUnlocked
              ? AppColors.primary.withOpacity(0.3)
              : (isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.black.withOpacity(0.04)),
          width: 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 成就图标
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? AppColors.primary.withOpacity(0.15)
                  : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.08)),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                achievement.icon,
                style: TextStyle(
                  fontSize: 28,
                ),
              ).animate(target: isUnlocked ? 1.0 : 0.0).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.1, 1.1),
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  ),
            ),
          ),

          const SizedBox(height: 12),

          // 成就名称
          Text(
            achievement.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isUnlocked
                  ? AppColors.primary
                  : (isDark ? Colors.white54 : AppColors.textSecondary),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // 成就描述
          Text(
            achievement.description,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white38 : AppColors.textDisabled,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // 进度条
          if (!isUnlocked)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: achievement.progress,
                minHeight: 4,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.06)
                    : AppColors.primary.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),

          if (isUnlocked)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '已获得',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ),

          // 进度文本
          if (!isUnlocked && achievement.targetCount > 1) ...[
            const SizedBox(height: 4),
            Text(
              '${achievement.currentCount}/${achievement.targetCount}',
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white30 : AppColors.textDisabled,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
