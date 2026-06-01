/// 应用字符串常量
/// 集中管理所有界面文本，方便国际化和统一管理
class AppStrings {
  // ============ 应用基本信息 ============

  /// 应用名称
  static const String appName = '咸蛋时钟';

  /// 应用英文名称
  static const String appNameEn = 'Salted Egg Clock';

  /// 应用标语
  static const String slogan = '专注每一分钟，像咸蛋一样沉淀自己。';

  /// 应用版本
  static const String version = '1.0.0';

  // ============ 导航菜单 ============

  /// 导航项标签
  static const List<String> navLabels = [
    '首页',
    '专注',
    '任务',
    '统计',
    '成就',
    '设置',
  ];

  /// 导航项图标（Emoji）
  static const List<String> navIcons = [
    '🏠',
    '🍅',
    '📝',
    '📊',
    '🏆',
    '⚙',
  ];

  // ============ 计时器 ============

  /// 默认专注时间（分钟）
  static const int defaultFocusDuration = 25;

  /// 默认短休息时间（分钟）
  static const int defaultShortBreakDuration = 5;

  /// 默认长休息时间（分钟）
  static const int defaultLongBreakDuration = 15;

  /// 默认长休息间隔（次）
  static const int defaultLongBreakInterval = 4;

  /// 计时器模式标签
  static const String focusMode = '专注';
  static const String shortBreakMode = '短休息';
  static const String longBreakMode = '长休息';

  // ============ 成就名称 ============

  /// 成就列表
  static const List<Map<String, String>> achievementNames = [
    {'name': '初出蛋壳', 'icon': '🥚', 'desc': '完成1次专注'},
    {'name': '小鸡成长', 'icon': '🐣', 'desc': '完成10次专注'},
    {'name': '破壳而出', 'icon': '🐥', 'desc': '完成25次专注'},
    {'name': '阳光沐浴', 'icon': '☀️', 'desc': '累计专注10小时'},
    {'name': '黄金蛋黄', 'icon': '🌞', 'desc': '累计专注100小时'},
    {'name': '咸蛋大师', 'icon': '🏆', 'desc': '累计专注500小时'},
    {'name': '七天连续', 'icon': '🔥', 'desc': '连续打卡7天'},
    {'name': '一月坚持', 'icon': '💪', 'desc': '连续打卡30天'},
    {'name': '任务收割者', 'icon': '✅', 'desc': '完成10个任务'},
    {'name': '效率超人', 'icon': '⚡', 'desc': '单日完成8次专注'},
  ];

  // ============ 欢迎语 ============

  /// 根据时间段的欢迎语
  static String getGreetingByHour(int hour) {
    if (hour < 6) return '夜深了，注意休息 🌙';
    if (hour < 9) return '早上好！新的一天开始了 ☀️';
    if (hour < 12) return '上午好！专注的时光最美好 🌤️';
    if (hour < 14) return '中午好！别忘了休息一下 🍱';
    if (hour < 18) return '下午好！继续加油 💪';
    if (hour < 21) return '晚上好！善用每一分钟 🌆';
    return '夜深了，注意休息 🌙';
  }
}
