/// 任务页面 ViewModel
/// 管理任务的增删改查、完成/取消状态等操作
import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import '../services/achievement_service.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final AchievementService _achievementService;

  /// 所有任务列表
  List<TaskModel> _allTasks = [];

  /// 新任务标题输入
  String newTaskTitle = '';

  /// 新任务描述输入
  String newTaskDescription = '';

  /// 新任务预估番茄钟
  int newTaskPomodoros = 1;

  /// 是否显示新增任务表单
  bool showAddForm = false;

  /// 当前编辑的任务ID
  String? editingTaskId;

  TaskViewModel({
    required TaskRepository taskRepository,
    required AchievementService achievementService,
  })  : _taskRepository = taskRepository,
        _achievementService = achievementService;

  /// 获取所有任务
  List<TaskModel> get allTasks => _allTasks;

  /// 获取活跃任务（未完成）
  List<TaskModel> get activeTasks =>
      _allTasks.where((t) => !t.isCompleted).toList();

  /// 获取已完成任务
  List<TaskModel> get completedTasks =>
      _allTasks.where((t) => t.isCompleted).toList();

  /// 是否有任务
  bool get hasTasks => _allTasks.isNotEmpty;

  /// 活跃任务数量
  int get activeCount => activeTasks.length;

  /// 已完成任务数量
  int get completedCount => completedTasks.length;

  /// 加载所有任务
  void loadTasks() {
    _allTasks = _taskRepository.getAll();
    notifyListeners();
  }

  /// 显示/隐藏新增表单
  void toggleAddForm() {
    showAddForm = !showAddForm;
    if (!showAddForm) {
      newTaskTitle = '';
      newTaskDescription = '';
      newTaskPomodoros = 1;
    }
    notifyListeners();
  }

  /// 开始编辑任务
  void startEdit(TaskModel task) {
    editingTaskId = task.id;
    newTaskTitle = task.title;
    newTaskDescription = task.description;
    newTaskPomodoros = task.expectedPomodoros;
    notifyListeners();
  }

  /// 取消编辑
  void cancelEdit() {
    editingTaskId = null;
    newTaskTitle = '';
    newTaskDescription = '';
    newTaskPomodoros = 1;
    notifyListeners();
  }

  /// 保存编辑
  Future<void> saveEdit() async {
    if (newTaskTitle.trim().isEmpty) return;

    if (editingTaskId != null) {
      final task = _taskRepository.getById(editingTaskId!);
      if (task != null) {
        final updated = task.copyWith(
          title: newTaskTitle.trim(),
          description: newTaskDescription.trim(),
          expectedPomodoros: newTaskPomodoros,
        );
        await _taskRepository.update(updated);
      }
      cancelEdit();
    }
    loadTasks();
  }

  /// 新增任务
  Future<void> addTask() async {
    if (newTaskTitle.trim().isEmpty) return;

    await _taskRepository.create(
      title: newTaskTitle.trim(),
      description: newTaskDescription.trim(),
      expectedPomodoros: newTaskPomodoros,
    );

    newTaskTitle = '';
    newTaskDescription = '';
    newTaskPomodoros = 1;
    showAddForm = false;

    loadTasks();
  }

  /// 切换任务完成状态
  Future<void> toggleTaskComplete(TaskModel task) async {
    await _taskRepository.toggleComplete(task);
    loadTasks();
    await _achievementService.checkTaskAchievements();
  }

  /// 删除任务
  Future<void> deleteTask(String id) async {
    await _taskRepository.delete(id);
    if (editingTaskId == id) {
      cancelEdit();
    }
    loadTasks();
  }

  /// 更新预估番茄钟数量
  void setPomodoros(int count) {
    newTaskPomodoros = count.clamp(1, 20);
    notifyListeners();
  }

  /// 更新任务标题
  void setTitle(String title) {
    newTaskTitle = title;
    notifyListeners();
  }

  /// 更新任务描述
  void setDescription(String desc) {
    newTaskDescription = desc;
    notifyListeners();
  }
}
