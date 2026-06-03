/// 自定义标题栏组件
/// 基于 window_manager 的 Windows 自定义窗口标题栏，
/// 使用 AnimatedContainer 使主题切换时背景颜色平滑过渡。
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';

class CustomTitleBar extends StatelessWidget implements PreferredSizeWidget {
  /// 标题文字
  final String title;

  /// 是否显示标题
  final bool showTitle;

  const CustomTitleBar({
    super.key,
    this.title = '咸蛋时钟',
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onPanStart: (_) => windowManager.startDragging(),
      child: AnimatedContainer(
        duration: AppTheme.themeTransitionDuration,
        curve: AppTheme.themeTransitionCurve,
        height: 40,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.backgroundDark.withOpacity(0.95)
              : AppColors.backgroundLight.withOpacity(0.95),
          border: Border(
            bottom: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.05),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // 拖拽区域 - 左侧标题
            if (showTitle) ...[
              const SizedBox(width: 16),
              Row(
                children: [
                  Text(
                    '🥚',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],

            // 中间拖拽区
            const Expanded(child: SizedBox()),

            // 窗口控制按钮
            _WindowButton(
              icon: Icons.minimize_rounded,
              onTap: () => windowManager.minimize(),
              tooltip: '最小化',
            ),
            _WindowButton(
              icon: Icons.crop_square_rounded,
              onTap: () => windowManager.maximize(),
              tooltip: '最大化',
            ),
            _WindowButton(
              icon: Icons.close_rounded,
              onTap: () => windowManager.close(),
              tooltip: '关闭',
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

/// 窗口控制按钮
class _WindowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 46,
            height: 40,
            color: _isHovered
                ? (widget.isClose
                    ? AppColors.error.withOpacity(0.8)
                    : (isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.06)))
                : Colors.transparent,
            child: Icon(
              widget.icon,
              size: 16,
              color: _isHovered && widget.isClose
                  ? Colors.white
                  : (isDark ? Colors.white70 : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
