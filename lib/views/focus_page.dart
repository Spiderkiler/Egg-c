/// 专注页面
/// 核心番茄时钟页面，包含计时器、模式切换和控制按钮
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/focus_viewmodel.dart';
import '../services/timer_service.dart';
import '../widgets/circular_timer.dart';
import '../widgets/glass_card.dart';

class FocusPage extends StatefulWidget {
  const FocusPage({super.key});

  @override
  State<FocusPage> createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  late final FocusViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<FocusViewModel>();
    // 延迟调用 refreshSettings，避免在构建阶段触发 notifyListeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.refreshSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<FocusViewModel>(
      builder: (context, vm, child) {
        return Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            final result = vm.handleKeyEvent(event);
            if (result == KeyEventResult.handled) {
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                // 模式选择器
                _buildModeSelector(vm, isDark),

                const SizedBox(height: 40),

                // 圆形计时器
                Center(
                  child: CircularTimer(
                    progress: vm.progress,
                    timeText: vm.formattedRemaining,
                    totalText: vm.formattedTotal,
                    isRunning: vm.isRunning,
                    isBreakMode: vm.isBreakMode,
                    modeLabel: _getModeLabel(vm.mode),
                  ).animate().scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),
                ),

                const SizedBox(height: 36),

                // 核心控制按钮
                _buildControlButtons(vm, isDark),

                const SizedBox(height: 32),

                // 次要控制按钮
                _buildSecondaryButtons(vm, isDark),

                const SizedBox(height: 28),

                // 关联任务选择器
                _buildTaskSelector(vm, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 获取模式标签
  String _getModeLabel(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        return '专注';
      case TimerMode.shortBreak:
        return '短休息';
      case TimerMode.longBreak:
        return '长休息';
    }
  }

  /// 构建模式选择器
  Widget _buildModeSelector(FocusViewModel vm, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildModeChip(
          vm,
          isDark,
          TimerMode.focus,
          '🍅 专注',
          vm.settings.focusDuration,
        ),
        const SizedBox(width: 10),
        _buildModeChip(
          vm,
          isDark,
          TimerMode.shortBreak,
          '☕ 短休',
          vm.settings.shortBreakDuration,
        ),
        const SizedBox(width: 10),
        _buildModeChip(
          vm,
          isDark,
          TimerMode.longBreak,
          '🍵 长休',
          vm.settings.longBreakDuration,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: -0.05,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }

  /// 构建单个模式标签
  Widget _buildModeChip(
    FocusViewModel vm,
    bool isDark,
    TimerMode mode,
    String label,
    int minutes,
  ) {
    final isSelected = vm.mode == mode;
    final color = mode == TimerMode.focus
        ? AppColors.primary
        : (mode == TimerMode.shortBreak
            ? AppColors.success
            : AppColors.warning);

    return GestureDetector(
      onTap: vm.isRunning ? null : () => vm.selectMode(mode),
      child: AnimatedContainer(
        duration: 300.ms,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.12)
              : (isDark ? Colors.white.withOpacity(0.04) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.4)
                : (isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.04)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? color
                    : (isDark ? Colors.white54 : AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${minutes}分钟',
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? color.withOpacity(0.7)
                    : (isDark ? Colors.white30 : AppColors.textDisabled),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建主控制按钮
  Widget _buildControlButtons(FocusViewModel vm, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 跳过按钮（仅在运行或暂停时显示）
        if (vm.isRunning || vm.isPaused)
          _buildButton(
            icon: Icons.skip_next_rounded,
            label: '跳过',
            onTap: vm.skip,
            isDark: isDark,
            isSecondary: true,
          ),

        // 重置按钮（仅在非空闲时显示）
        if (!vm.isIdle) ...[
          const SizedBox(width: 20),
          _buildButton(
            icon: Icons.refresh_rounded,
            label: '重置',
            onTap: vm.reset,
            isDark: isDark,
            isSecondary: true,
          ),
        ],

        const SizedBox(width: 24),

        // 主按钮（开始/暂停/继续）
        _buildMainButton(vm, isDark),
      ],
    );
  }

  /// 构建主操作按钮（大圆形）
  Widget _buildMainButton(FocusViewModel vm, bool isDark) {
    IconData icon;
    VoidCallback onTap;

    if (vm.isRunning) {
      icon = Icons.pause_rounded;
      onTap = vm.pause;
    } else if (vm.isPaused) {
      icon = Icons.play_arrow_rounded;
      onTap = vm.resume;
    } else {
      icon = Icons.play_arrow_rounded;
      onTap = vm.start;
    }

    final color = vm.isBreakMode ? AppColors.success : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 300.ms,
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 36),
        ),
      ),
    ).animate(target: vm.isRunning ? 1.0 : 0.0).scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
          duration: 1200.ms,
        );
  }

  /// 构建次要按钮
  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    bool isSecondary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Tooltip(
          message: label,
          child: Icon(
            icon,
            size: 24,
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// 构建次要控制按钮
  Widget _buildSecondaryButtons(FocusViewModel vm, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '快捷键:',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white24 : AppColors.textDisabled,
          ),
        ),
        const SizedBox(width: 8),
        _buildKeyBadge('Space', '开始/暂停', isDark),
        const SizedBox(width: 8),
        _buildKeyBadge('R', '重置', isDark),
      ],
    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
  }

  /// 构建快捷键提示
  Widget _buildKeyBadge(String key, String action, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.08)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            key,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            action,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white38 : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建任务选择器
  Widget _buildTaskSelector(FocusViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📝', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                '关联任务',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: vm.toggleTaskPicker,
                child: Text(
                  vm.selectedTask != null ? '更换' : '选择任务',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          if (vm.selectedTask != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.03)
                    : AppColors.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.task_alt_rounded,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      vm.selectedTask!.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:
                            isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${vm.selectedTask!.completedPomodoros}/${vm.selectedTask!.expectedPomodoros} 🍅',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white38
                          : AppColors.textDisabled,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              '选择一个任务，让专注更有目标感',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white30 : AppColors.textDisabled,
              ),
            ),
          ],

          // 任务选择器展开面板
          if (vm.showTaskPicker) ...[
            const SizedBox(height: 12),
            _buildTaskPickerPanel(vm, isDark),
          ],
        ],
      ),
    );
  }

  /// 构建任务选择面板
  Widget _buildTaskPickerPanel(FocusViewModel vm, bool isDark) {
    final tasks = vm.activeTasks;

    if (tasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '暂无未完成任务，先去创建任务吧～',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white38 : AppColors.textDisabled,
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: tasks.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          if (index == 0) {
            // 取消选择选项
            return _buildTaskPickerItem(
              title: '不关联任务',
              isSelected: vm.selectedTask == null,
              onTap: () => vm.selectTask(null),
              isDark: isDark,
            );
          }
          final task = tasks[index - 1];
          return _buildTaskPickerItem(
            title: task.title,
            subtitle:
                '${task.completedPomodoros}/${task.expectedPomodoros} 🍅',
            isSelected: vm.selectedTask?.id == task.id,
            onTap: () => vm.selectTask(task),
            isDark: isDark,
          );
        },
      ),
    ).animate().slideY(
          begin: -0.1,
          end: 0,
          duration: 250.ms,
          curve: Curves.easeOut,
        ).fadeIn(duration: 200.ms);
  }

  /// 构建单个任务选择项
  Widget _buildTaskPickerItem({
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  size: 18, color: AppColors.primary),
            if (!isSelected)
              Icon(Icons.circle_outlined,
                  size: 18,
                  color: isDark ? Colors.white24 : AppColors.textDisabled),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            if (subtitle != null)
              Flexible(
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        isDark ? Colors.white30 : AppColors.textDisabled,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
