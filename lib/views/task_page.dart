/// 任务页面
/// 完整的任务管理界面，支持增删改查和番茄钟进度追踪
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../viewmodels/task_viewmodel.dart';
import '../widgets/task_tile.dart';
import '../widgets/glass_card.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  /// 任务标题输入控制器
  final TextEditingController _titleController = TextEditingController();

  /// 任务描述输入控制器
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().loadTasks();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<TaskViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题
              _buildPageHeader(vm, isDark),

              const SizedBox(height: 28),

              // 新增任务表单
              if (vm.showAddForm || vm.editingTaskId != null) ...[
                _buildTaskForm(vm, isDark),
                const SizedBox(height: 24),
              ],

              // 活跃任务列表
              _buildSectionHeader(
                '进行中',
                vm.activeCount,
                isDark,
              ),
              const SizedBox(height: 12),

              if (vm.activeTasks.isEmpty)
                _buildEmptyState(
                  '还没有任务哦 🍳',
                  '点击上方按钮创建第一个任务吧',
                  isDark,
                ),
              if (vm.activeTasks.isNotEmpty)
                ...vm.activeTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskTile(
                      task: task,
                      onToggleComplete: () => vm.toggleTaskComplete(task),
                      onEdit: () => vm.startEdit(task),
                      onDelete: () => vm.deleteTask(task.id),
                    ).animate().fadeIn(
                          duration: 300.ms,
                        ).slideX(
                          begin: -0.03,
                          end: 0,
                          duration: 300.ms,
                        ),
                  ),
                ).toList(),

              // 已完成任务列表
              if (vm.completedTasks.isNotEmpty) ...[
                const SizedBox(height: 28),
                _buildSectionHeader(
                  '已完成',
                  vm.completedCount,
                  isDark,
                ),
                const SizedBox(height: 12),
                ...vm.completedTasks.map(
                  (task) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TaskTile(
                      task: task,
                      onToggleComplete: () => vm.toggleTaskComplete(task),
                      onDelete: () => vm.deleteTask(task.id),
                    ).animate().fadeIn(
                          duration: 300.ms,
                        ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// 构建页面头部
  Widget _buildPageHeader(TaskViewModel vm, bool isDark) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📝 任务管理',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '规划你的每一项任务',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white38 : AppColors.textDisabled,
              ),
            ),
          ],
        ),
        const Spacer(),

        // 新增任务按钮
        if (!vm.showAddForm && vm.editingTaskId == null)
          GestureDetector(
            onTap: vm.toggleAddForm,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text(
                    '新增任务',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// 构建分区标题
  Widget _buildSectionHeader(String title, int count, bool isDark) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(String title, String subtitle, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text('🥚', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white30 : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建新增/编辑任务表单
  Widget _buildTaskForm(TaskViewModel vm, bool isDark) {
    final isEditing = vm.editingTaskId != null;

    // 同步控制器的文本值
    if (_titleController.text != vm.newTaskTitle) {
      _titleController.text = vm.newTaskTitle;
    }
    if (_descController.text != vm.newTaskDescription) {
      _descController.text = vm.newTaskDescription;
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 表单标题
          Row(
            children: [
              Text(
                isEditing ? '✏️ 编辑任务' : '➕ 新增任务',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (isEditing) {
                    vm.cancelEdit();
                  } else {
                    vm.toggleAddForm();
                  }
                },
                child: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color:
                      isDark ? Colors.white38 : AppColors.textDisabled,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 任务标题输入
          _buildTextField(
            label: '任务名称',
            hint: '输入任务名称...',
            value: vm.newTaskTitle,
            onChanged: vm.setTitle,
            isDark: isDark,
            controller: _titleController,
          ),

          const SizedBox(height: 12),

          // 任务描述输入
          _buildTextField(
            label: '任务描述（选填）',
            hint: '添加一些描述信息...',
            value: vm.newTaskDescription,
            onChanged: vm.setDescription,
            isDark: isDark,
            maxLines: 2,
            controller: _descController,
          ),

          const SizedBox(height: 12),

          // 番茄钟数量选择
          Row(
            children: [
              Text(
                '预估番茄钟',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              _buildNumberControl(vm, isDark),
            ],
          ),

          const SizedBox(height: 16),

          // 操作按钮
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: isEditing ? '保存修改' : '创建任务',
                  onTap: () {
                    if (isEditing) {
                      vm.saveEdit();
                    } else {
                      vm.addTask();
                    }
                  },
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  label: '取消',
                  onTap: () {
                    if (isEditing) {
                      vm.cancelEdit();
                    } else {
                      vm.toggleAddForm();
                    }
                  },
                  isPrimary: false,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(
          begin: -0.08,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        ).fadeIn(duration: 250.ms);
  }

  /// 构建文本输入框
  Widget _buildTextField({
    required String label,
    required String hint,
    required String value,
    required ValueChanged<String> onChanged,
    required bool isDark,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white24 : AppColors.textDisabled,
            ),
            filled: true,
            fillColor:
                isDark ? Colors.white.withOpacity(0.03) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.06),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.black.withOpacity(0.06),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
      ],
    );
  }

  /// 构建数量控制器
  Widget _buildNumberControl(TaskViewModel vm, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => vm.setPomodoros(vm.newTaskPomodoros - 1),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.02),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  bottomLeft: Radius.circular(11),
                ),
              ),
              child: const Icon(Icons.remove_rounded,
                  size: 18, color: AppColors.textSecondary),
            ),
          ),
          Container(
            width: 48,
            height: 38,
            alignment: Alignment.center,
            child: Text(
              '${vm.newTaskPomodoros} 🍅',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => vm.setPomodoros(vm.newTaskPomodoros + 1),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : Colors.black.withOpacity(0.02),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: const Icon(Icons.add_rounded,
                  size: 18, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
    bool isDark = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary
              : (isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isPrimary
                ? Colors.white
                : (isDark ? Colors.white54 : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
