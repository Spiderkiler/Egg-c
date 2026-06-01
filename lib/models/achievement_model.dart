/// 成就数据模型
/// 用于定义和追踪用户的成就进度
import 'package:hive/hive.dart';

/// 成就解锁状态枚举
enum AchievementStatus {
  /// 未解锁
  locked,

  /// 已解锁
  unlocked,
}

@HiveType(typeId: 2)
class AchievementModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String icon;

  @HiveField(4)
  final int targetCount;

  @HiveField(5)
  int currentCount;

  @HiveField(6)
  AchievementStatus status;

  @HiveField(7)
  DateTime? unlockedTime;

  /// 创建成就对象
  AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.targetCount,
    this.currentCount = 0,
    this.status = AchievementStatus.locked,
    this.unlockedTime,
  });

  /// 计算成就进度（百分比）
  double get progress {
    if (targetCount <= 0) return 0.0;
    return (currentCount / targetCount).clamp(0.0, 1.0);
  }

  /// 判断是否已解锁
  bool get isUnlocked => status == AchievementStatus.unlocked;

  /// 从JSON创建成就对象
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      targetCount: json['targetCount'] as int,
      currentCount: json['currentCount'] as int? ?? 0,
      status: json['status'] != null
          ? AchievementStatus.values[json['status'] as int]
          : AchievementStatus.locked,
      unlockedTime: json['unlockedTime'] != null
          ? DateTime.parse(json['unlockedTime'] as String)
          : null,
    );
  }

  /// 转为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'status': status.index,
      'unlockedTime': unlockedTime?.toIso8601String(),
    };
  }
}
