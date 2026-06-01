/// 专注记录数据模型
/// 用于存储每次专注会话的完整记录
import 'package:hive/hive.dart';

/// 专注类型枚举
enum FocusType {
  /// 专注
  focus,

  /// 短休息
  shortBreak,

  /// 长休息
  longBreak,
}

@HiveType(typeId: 1)
class FocusRecordModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final FocusType type;

  @HiveField(2)
  final int durationMinutes;

  @HiveField(3)
  int actualSeconds;

  @HiveField(4)
  final DateTime startTime;

  @HiveField(5)
  DateTime? endTime;

  @HiveField(6)
  bool isCompleted;

  @HiveField(7)
  String? taskId;

  /// 创建专注记录
  FocusRecordModel({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.actualSeconds,
    required this.startTime,
    this.endTime,
    this.isCompleted = false,
    this.taskId,
  });

  /// 从JSON创建专注记录对象
  factory FocusRecordModel.fromJson(Map<String, dynamic> json) {
    return FocusRecordModel(
      id: json['id'] as String,
      type: FocusType.values[json['type'] as int? ?? 0],
      durationMinutes: json['durationMinutes'] as int? ?? 25,
      actualSeconds: json['actualSeconds'] as int? ?? 0,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      taskId: json['taskId'] as String?,
    );
  }

  /// 转为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'durationMinutes': durationMinutes,
      'actualSeconds': actualSeconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'taskId': taskId,
    };
  }
}
