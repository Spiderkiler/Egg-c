/// 任务数据仓库
/// 封装对任务存储的CRUD操作，作为 ViewModel 和 Storage 之间的中间层
import '../models/task_model.dart';
import '../services/storage_service.dart';
import '../utils/id_utils.dart';

class TaskRepository {
  /// 获取所有任务
  List<TaskModel> getAll() => StorageService.getAllTasks();

  /// 获取活跃任务（未完成）
  List<TaskModel> getActive() => StorageService.getActiveTasks();

  /// 获取已完成任务
  List<TaskModel> getCompleted() => StorageService.getCompletedTasks();

  /// 根据ID获取任务
  TaskModel? getById(String id) => StorageService.getTaskById(id);

  /// 创建新任务
  Future<TaskModel> create({
    required String title,
    String description = '',
    int expectedPomodoros = 1,
  }) async {
    final task = TaskModel(
      id: IdUtils.generateId(),
      title: title,
      description: description,
      expectedPomodoros: expectedPomodoros,
      createTime: DateTime.now(),
    );
    await StorageService.saveTask(task);
    return task;
  }

  /// 更新任务
  Future<void> update(TaskModel task) async {
    await StorageService.saveTask(task);
  }

  /// 完成/取消完成任务
  Future<void> toggleComplete(TaskModel task) async {
    final updated = task.copyWith(
      isCompleted: !task.isCompleted,
      completedTime: !task.isCompleted ? DateTime.now() : null,
    );
    await StorageService.saveTask(updated);
  }

  /// 给任务增加一个番茄钟
  Future<void> incrementPomodoro(TaskModel task) async {
    final updated = task.copyWith(
      completedPomodoros: task.completedPomodoros + 1,
      isCompleted: task.completedPomodoros + 1 >= task.expectedPomodoros,
      completedTime:
          task.completedPomodoros + 1 >= task.expectedPomodoros
              ? DateTime.now()
              : null,
    );
    await StorageService.saveTask(updated);
  }

  /// 删除任务
  Future<void> delete(String id) async {
    await StorageService.deleteTask(id);
  }
}
