/// 任务数据模型
/// 用于存储和管理用户的待办任务信息
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  int expectedPomodoros;

  @HiveField(4)
  int completedPomodoros;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  final DateTime createTime;

  @HiveField(7)
  DateTime? completedTime;

  /// 创建任务
  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    this.expectedPomodoros = 1,
    this.completedPomodoros = 0,
    this.isCompleted = false,
    required this.createTime,
    this.completedTime,
  });

  /// 从JSON创建任务对象
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      expectedPomodoros: json['expectedPomodoros'] as int? ?? 1,
      completedPomodoros: json['completedPomodoros'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createTime: DateTime.parse(json['createTime'] as String),
      completedTime: json['completedTime'] != null
          ? DateTime.parse(json['completedTime'] as String)
          : null,
    );
  }

  /// 转为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'expectedPomodoros': expectedPomodoros,
      'completedPomodoros': completedPomodoros,
      'isCompleted': isCompleted,
      'createTime': createTime.toIso8601String(),
      'completedTime': completedTime?.toIso8601String(),
    };
  }

  /// 计算任务完成进度（百分比）
  double get progress {
    if (expectedPomodoros <= 0) return 0.0;
    return (completedPomodoros / expectedPomodoros).clamp(0.0, 1.0);
  }

  /// 复制并更新字段
  TaskModel copyWith({
    String? title,
    String? description,
    int? expectedPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
    DateTime? completedTime,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      expectedPomodoros: expectedPomodoros ?? this.expectedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
      createTime: createTime,
      completedTime: completedTime ?? this.completedTime,
    );
  }
}
