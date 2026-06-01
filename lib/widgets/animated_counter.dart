/// 数字滚动动画组件
/// 实现数字从旧值到新值的渐变滚动效果
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedCounter extends StatelessWidget {
  /// 显示数值
  final double value;

  /// 是否整数显示
  final bool isInteger;

  /// 小数位数
  final int decimalPlaces;

  /// 数值样式
  final TextStyle? style;

  /// 持续时间
  final Duration duration;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.isInteger = true,
    this.decimalPlaces = 1,
    this.style,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  Widget build(BuildContext context) {
    final text = isInteger
        ? value.toInt().toString()
        : value.toStringAsFixed(decimalPlaces);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        final displayText = isInteger
            ? animatedValue.toInt().toString()
            : animatedValue.toStringAsFixed(decimalPlaces);
        return Text(displayText, style: style);
      },
    );
  }
}
