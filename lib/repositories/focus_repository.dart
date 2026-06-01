/// 专注记录仓库
/// 封装专注记录的数据持久化操作
import '../models/focus_record_model.dart';
import '../services/storage_service.dart';

class FocusRepository {
  /// 获取今日专注记录
  List<FocusRecordModel> getToday() {
    return StorageService.getTodayFocusRecords();
  }

  /// 获取本周专注记录
  List<FocusRecordModel> getWeek() {
    return StorageService.getWeekFocusRecords();
  }

  /// 获取本月专注记录
  List<FocusRecordModel> getMonth() {
    return StorageService.getMonthFocusRecords();
  }

  /// 获取所有专注记录
  List<FocusRecordModel> getAll() {
    return StorageService.getAllFocusRecords();
  }

  /// 保存专注记录
  Future<void> save(FocusRecordModel record) async {
    await StorageService.saveFocusRecord(record);
  }

  /// 获取今日专注总秒数
  int getTodayTotalSeconds() {
    return StorageService.getTodayTotalFocusSeconds();
  }

  /// 获取累计专注总秒数
  int getTotalSeconds() {
    return StorageService.getTotalFocusSeconds();
  }

  /// 获取已完成专注次数
  int getCompletedCount() {
    return StorageService.getCompletedFocusCount();
  }

  /// 获取连续打卡天数
  int getStreakDays() {
    return StorageService.getStreakDays();
  }

  /// 获取今日专注次数
  int getTodayFocusCount() {
    return getToday()
        .where((r) => r.isCompleted && r.type == FocusType.focus)
        .length;
  }

  /// 获取今日完成番茄钟总数
  int getTodayCompletedCount() {
    return getToday().where((r) => r.isCompleted).length;
  }
}
