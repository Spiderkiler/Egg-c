/// 成就页面 ViewModel
/// 管理成就列表展示和进度追踪
import 'package:flutter/foundation.dart';
import '../models/achievement_model.dart';
import '../services/achievement_service.dart';
import '../services/storage_service.dart';

class AchievementViewModel extends ChangeNotifier {
  final AchievementService _achievementService;

  /// 所有成就列表
  List<AchievementModel> _achievements = [];

  /// 已解锁成就数量
  int unlockedCount = 0;

  /// 总成就数量
  int totalCount = 0;

  AchievementViewModel({
    required AchievementService achievementService,
  }) : _achievementService = achievementService;

  /// 获取所有成就
  List<AchievementModel> get achievements => _achievements;

  /// 获取已解锁成就
  List<AchievementModel> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  /// 获取未解锁成就
  List<AchievementModel> get lockedAchievements =>
      _achievements.where((a) => !a.isUnlocked).toList();

  /// 解锁进度百分比
  double get progress {
    if (totalCount <= 0) return 0.0;
    return unlockedCount / totalCount;
  }

  /// 加载成就列表
  Future<void> loadAchievements() async {
    await StorageService.initDefaultAchievements();
    _achievements = _achievementService.achievements;
    unlockedCount = _achievementService.unlockedCount;
    totalCount = _achievementService.totalCount;
    notifyListeners();
  }

  /// 刷新成就状态
  void refresh() {
    _achievements = _achievementService.achievements;
    unlockedCount = _achievementService.unlockedCount;
    totalCount = _achievementService.totalCount;
    notifyListeners();
  }
}
