/// 桌面通知服务
/// 基于 flutter_local_notifications 的系统通知服务
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  /// 获取单例实例
  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// 通知ID计数器
  int _notificationId = 0;

  /// 初始化通知服务
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  /// 通知点击回调
  void _onNotificationResponse(NotificationResponse response) {
    // 处理通知点击事件
  }

  /// 显示专注结束通知
  Future<void> showFocusEndNotification() async {
    await _showNotification(
      title: '🍅 专注时间结束',
      body: '太棒了！休息一下吧～',
    );
  }

  /// 显示休息结束通知
  Future<void> showBreakEndNotification() async {
    await _showNotification(
      title: '☕ 休息时间结束',
      body: '准备好了吗？开始新的专注吧！',
    );
  }

  /// 显示任务提醒通知
  Future<void> showTaskReminderNotification(String taskTitle) async {
    await _showNotification(
      title: '📝 待办任务提醒',
      body: '你还有未完成的任务：$taskTitle',
    );
  }

  /// 显示成就解锁通知
  Future<void> showAchievementNotification(
      String name, String icon) async {
    await _showNotification(
      title: '$icon 成就解锁！',
      body: '恭喜获得「$name」成就！',
    );
  }

  /// 内部通用通知方法
  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    final id = _notificationId++;

    const androidDetails = AndroidNotificationDetails(
      'salted_egg_channel',
      '咸蛋时钟通知',
      channelDescription: '专注计时和任务提醒通知',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(id, title, body, details);
  }

  /// 关闭所有通知
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
