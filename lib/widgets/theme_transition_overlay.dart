/// 主题切换过渡遮罩组件
/// 在深浅色模式切换时，显示一个短暂的半透明遮罩动画，
/// 让主题切换视觉过渡更加丝滑流畅。
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ThemeTransitionOverlay extends StatefulWidget {
  /// 当前是否为深色模式
  final bool isDark;

  /// 子组件（应用主体内容）
  final Widget child;

  const ThemeTransitionOverlay({
    super.key,
    required this.isDark,
    required this.child,
  });

  @override
  State<ThemeTransitionOverlay> createState() =>
      _ThemeTransitionOverlayState();
}

class _ThemeTransitionOverlayState extends State<ThemeTransitionOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppTheme.themeTransitionDuration * 1.1,
      vsync: this,
    );
    // 遮罩从12%透明度渐隐到0%，短暂遮盖颜色切换瞬间但不会遮挡文字
    _opacityAnimation = Tween<double>(begin: 0.12, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ThemeTransitionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDark != widget.isDark) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // 过渡遮罩层：在主题切换时短暂显示新主题的背景色
        FadeTransition(
          opacity: _opacityAnimation,
          child: IgnorePointer(
            child: Container(
              color: AppTheme.getTransitionOverlayColor(widget.isDark),
            ),
          ),
        ),
      ],
    );
  }
}
