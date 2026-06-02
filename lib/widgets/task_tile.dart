/// 任务列表项组件
/// 单个任务的展示卡片，支持完成切换、编辑、删除等功能
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  /// 任务数据
  final TaskModel task;

  /// 完成切换回调
  final VoidCallback? onToggleComplete;

  /// 编辑回调
  final VoidCallback? onEdit;

  /// 删除回调
  final VoidCallback? onDelete;

  const TaskTile({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: GestureDetector(
        onTap: onToggleComplete,
        child: AnimatedContainer(
          duration: AppTheme.themeTransitionDuration,
          curve: AppTheme.themeTransitionCurve,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: task.isCompleted
                ? (isDark
                    ? Colors.white.withOpacity(0.03)
                    : AppColors.primary.withOpacity(0.04))
                : (isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: task.isCompleted
                  ? AppColors.success.withOpacity(0.3)
                  : (isDark
                      ? Colors.white.withOpacity(0.06)
                      : Colors.black.withOpacity(0.04)),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // 完成状态勾选框
              GestureDetector(
                onTap: onToggleComplete,
                child: AnimatedContainer(
                  duration: 300.ms,
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.isCompleted
                        ? AppColors.success
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: task.isCompleted
                          ? AppColors.success
                          : (isDark
                              ? Colors.white30
                              : AppColors.textDisabled),
                      width: 2,
                    ),
                  ),
                  child: task.isCompleted
                      ? const Icon(Icons.check_rounded,
                          size: 16, color: Colors.white)
                      : null,
                ),
              ),

              const SizedBox(width: 14),

              // 任务信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: task.isCompleted
                            ? (isDark
                                ? Colors.white38
                                : AppColors.textDisabled)
                            : (isDark
                                ? Colors.white
                                : AppColors.textPrimary),
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? Colors.white38
                              : AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),

                    // 番茄钟进度
                    Row(
                      children: [
                        ...List.generate(task.expectedPomodoros, (i) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i < task.completedPomodoros
                                  ? AppColors.primary
                                  : (isDark
                                      ? Colors.white12
                                      : AppColors.primary.withOpacity(0.15)),
                            ),
                          );
                        }),
                        const SizedBox(width: 6),
                        Text(
                          '${task.completedPomodoros}/${task.expectedPomodoros}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white30
                                : AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 编辑按钮
              if (!task.isCompleted)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_rounded,
                    size: 18,
                    color: isDark ? Colors.white30 : AppColors.textDisabled,
                  ),
                  splashRadius: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
