/// 统计卡片组件
/// 用于展示单个统计指标的数值卡片
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  /// 卡片标题
  final String title;

  /// 数值
  final String value;

  /// 单位
  final String? unit;

  /// 图标（Emoji）
  final String icon;

  /// 背景色
  final Color? color;

  /// 点击回调
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        color ?? (isDark ? Colors.white.withOpacity(0.06) : Colors.white);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.themeTransitionDuration,
        curve: AppTheme.themeTransitionCurve,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.04),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black26
                  : Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图标
            Text(icon, style: const TextStyle(fontSize: 28)),

            const SizedBox(height: 12),

            // 数值
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
                letterSpacing: -1,
                height: 1.1,
              ),
            ),

            if (unit != null) ...[
              const SizedBox(height: 2),
              Text(
                unit!,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      isDark ? Colors.white38 : AppColors.textDisabled,
                  letterSpacing: 0.5,
                ),
              ),
            ],

            const SizedBox(height: 8),

            // 标题
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color:
                    isDark ? Colors.white54 : AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
