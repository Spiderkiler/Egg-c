/// 毛玻璃卡片组件
/// 实现 Glassmorphism 风格的通用卡片容器
import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/constants/app_colors.dart';

class GlassCard extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 内边距
  final EdgeInsetsGeometry padding;

  /// 外边距
  final EdgeInsetsGeometry margin;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 圆角大小
  final double borderRadius;

  /// 模糊强度
  final double blurStrength;

  /// 透明度
  final double opacity;

  /// 阴影颜色
  final Color? shadowColor;

  /// 背景色
  final Color? backgroundColor;

  /// 点击回调
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.blurStrength = 20,
    this.opacity = 0.85,
    this.shadowColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = backgroundColor ??
        (isDark
            ? AppColors.surfaceDark.withOpacity(opacity)
            : AppColors.surfaceLight.withOpacity(opacity));

    final shadowCol = shadowColor ??
        (isDark ? Colors.black26 : AppColors.shadowLight);

    final card = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.white.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowCol.withOpacity(0.08),
            blurRadius: blurStrength,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: shadowCol.withOpacity(0.04),
            blurRadius: blurStrength / 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    // 添加毛玻璃后效
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurStrength / 10,
          sigmaY: blurStrength / 10,
        ),
        child: card,
      ),
    );
  }
}
