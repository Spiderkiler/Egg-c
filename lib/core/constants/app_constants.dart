/// 应用通用常量
/// 定义非字符串的其他常量值
class AppConstants {
  // ============ 窗口 ============

  /// 窗口默认宽度
  static const double windowWidth = 1200;

  /// 窗口默认高度
  static const double windowHeight = 800;

  /// 窗口最小宽度
  static const double windowMinWidth = 900;

  /// 窗口最小高度
  static const double windowMinHeight = 600;

  /// 标题栏高度
  static const double titleBarHeight = 40;

  // ============ 布局 ============

  /// 导航栏宽度
  static const double navigationWidth = 88;

  /// 页面水平内边距
  static const double pageHorizontalPadding = 40;

  /// 页面垂直内边距
  static const double pageVerticalPadding = 40;

  /// 卡片圆角
  static const double cardBorderRadius = 24;

  /// 按钮圆角
  static const double buttonBorderRadius = 16;

  /// 输入框圆角
  static const double inputBorderRadius = 12;

  // ============ 动画 ============

  /// 页面切换动画时长（毫秒）
  static const int pageTransitionMs = 250;

  /// 淡入动画时长（毫秒）
  static const int fadeInMs = 400;

  /// 滑动动画时长（毫秒）
  static const int slideMs = 300;

  // ============ 定时器 ============

  /// 最小专注时间（分钟）
  static const int minFocusDuration = 5;

  /// 最大专注时间（分钟）
  static const int maxFocusDuration = 60;

  /// 最小休息时间（分钟）
  static const int minBreakDuration = 1;

  /// 最大短休息时间（分钟）
  static const int maxShortBreakDuration = 15;

  /// 最大长休息时间（分钟）
  static const int maxLongBreakDuration = 45;

  /// 最小长休息间隔
  static const int minLongBreakInterval = 2;

  /// 最大长休息间隔
  static const int maxLongBreakInterval = 8;
}
