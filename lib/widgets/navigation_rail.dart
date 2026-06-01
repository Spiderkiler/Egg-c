/// 侧边导航栏组件
/// 实现App的主要导航功能，支持图标动画切换
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';

/// 导航项数据模型
class NavItem {
  /// 导航图标
  final IconData icon;

  /// 导航emoji图标（备用）
  final String emoji;

  /// 导航标题
  final String label;

  /// 页面索引
  final int index;

  const NavItem({
    required this.icon,
    required this.emoji,
    required this.label,
    required this.index,
  });
}

/// 所有导航项定义
const List<NavItem> navItems = [
  NavItem(icon: Icons.home_rounded, emoji: '🏠', label: '首页', index: 0),
  NavItem(icon: Icons.timer_rounded, emoji: '🍅', label: '专注', index: 1),
  NavItem(
      icon: Icons.checklist_rounded, emoji: '📝', label: '任务', index: 2),
  NavItem(
      icon: Icons.bar_chart_rounded, emoji: '📊', label: '统计', index: 3),
  NavItem(icon: Icons.emoji_events_rounded, emoji: '🏆', label: '成就', index: 4),
  NavItem(icon: Icons.settings_rounded, emoji: '⚙', label: '设置', index: 5),
];

class AppNavigationRail extends StatelessWidget {
  /// 当前选中的索引
  final int selectedIndex;

  /// 切换回调
  final ValueChanged<int> onDestinationSelected;

  const AppNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 88,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceDark.withOpacity(0.6)
            : AppColors.surfaceLight.withOpacity(0.6),
        border: Border(
          right: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Logo区域
          _buildLogo(isDark),

          const SizedBox(height: 32),

          // 导航项列表
          ...navItems.map(
            (item) => _buildNavItem(context, item, isDark),
          ),

          const Spacer(),

          // 底部版本信息
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white24 : AppColors.textDisabled,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建Logo
  Widget _buildLogo(bool isDark) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '🥚',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ).animate().scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),
      ],
    );
  }

  /// 构建单个导航项
  Widget _buildNavItem(BuildContext context, NavItem item, bool isDark) {
    final isSelected = selectedIndex == item.index;

    return GestureDetector(
      onTap: () => onDestinationSelected(item.index),
      child: Container(
        width: 72,
        height: 64,
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.emoji,
              style: TextStyle(
                fontSize: 22,
              ),
            ).animate(target: isSelected ? 1.0 : 0.0).scale(
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1.0, 1.0),
                  duration: 200.ms,
                ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.white54 : AppColors.textSecondary),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
