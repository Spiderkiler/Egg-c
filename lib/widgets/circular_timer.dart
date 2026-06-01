/// 圆形进度计时器组件
/// 核心计时器展示组件，利用 CustomPainter 绘制平滑进度环和中心时间
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';

class CircularTimer extends StatelessWidget {
  /// 进度值（0.0 - 1.0）
  final double progress;

  /// 剩余时间格式化字符串
  final String timeText;

  /// 计时器总时长文本
  final String? totalText;

  /// 是否正在运行
  final bool isRunning;

  /// 是否是休息模式
  final bool isBreakMode;

  /// 计时器圆环尺寸
  final double size;

  /// 圆环描边宽度
  final double strokeWidth;

  /// 模式标签文本
  final String modeLabel;

  const CircularTimer({
    super.key,
    required this.progress,
    required this.timeText,
    this.totalText,
    this.isRunning = false,
    this.isBreakMode = false,
    this.size = 320,
    this.strokeWidth = 14,
    this.modeLabel = '专注',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 根据模式选择颜色
    final progressColor = isBreakMode ? AppColors.success : AppColors.primary;
    final trackColor = isDark
        ? Colors.white.withOpacity(0.08)
        : AppColors.primary.withOpacity(0.1);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景轨道圆环
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: 1.0,
              color: trackColor,
              strokeWidth: strokeWidth,
              isBackground: true,
            ),
          ),

          // 进度圆环
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: progress,
              color: progressColor,
              strokeWidth: strokeWidth,
            ),
          ),

          // 中心时间显示
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 模式标签
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isBreakMode
                      ? (modeLabel == '短休息' ? '☕ 短休息' : '🍵 长休息')
                      : '🍅 专注中',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: progressColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 时间数字
              Text(
                timeText,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w200,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  fontFamily: 'monospace',
                  letterSpacing: 4,
                  height: 1.1,
                ),
              ).animate(target: isRunning ? 1.0 : 0.0).scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.02, 1.02),
                    duration: 800.ms,
                  ),

              // 总时长
              if (totalText != null) ...[
                const SizedBox(height: 8),
                Text(
                  '目标 $totalText',
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        isDark ? Colors.white38 : AppColors.textDisabled,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 圆形进度绘制器
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final bool isBackground;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.isBackground = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 绘制弧线（从顶部开始，顺时针）
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // 从12点方向开始
      2 * pi * progress,
      false,
      paint,
    );

    // 绘制起始点圆点
    if (!isBackground && progress > 0) {
      final startAngle = -pi / 2;
      final dotPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          center.dx + radius * cos(startAngle),
          center.dy + radius * sin(startAngle),
        ),
        strokeWidth / 2.5,
        dotPaint,
      );

      // 绘制结束点圆点
      if (progress > 0.01) {
        final endAngle = -pi / 2 + 2 * pi * progress;
        canvas.drawCircle(
          Offset(
            center.dx + radius * cos(endAngle),
            center.dy + radius * sin(endAngle),
          ),
          strokeWidth / 2,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
