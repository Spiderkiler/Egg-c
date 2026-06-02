/// 欢迎头部组件
/// 首页顶部展示当前日期、时间和欢迎语
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';

class WelcomeHeader extends StatelessWidget {
  /// 日期字符串
  final String date;

  /// 时间字符串
  final String time;

  /// 欢迎语
  final String greeting;

  const WelcomeHeader({
    super.key,
    required this.date,
    required this.time,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 日期和时间行
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 日期
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white70 : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),

            const Spacer(),

            // 时间
            Text(
              time,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: isDark ? Colors.white : AppColors.textPrimary,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(
                  duration: 500.ms,
                ),
          ],
        ),

        const SizedBox(height: 12),

        // 欢迎语
        Text(
          greeting,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
            letterSpacing: -0.5,
            height: 1.3,
          ),
        ).animate().fadeIn(
              duration: 600.ms,
              delay: 200.ms,
            ).slideX(
              begin: -0.05,
              end: 0,
              duration: 600.ms,
              delay: 200.ms,
              curve: Curves.easeOut,
            ),

        const SizedBox(height: 6),

        // 副标题
        Text(
          '专注每一分钟，像咸蛋一样沉淀自己',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white38 : AppColors.textDisabled,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
