/// 时间工具类
/// 提供各类日期时间格式化和计算功能
import 'package:intl/intl.dart';

class TimeUtils {
  /// 获取当前日期字符串（如：6月1日 星期一）
  static String getFormattedDate() {
    final now = DateTime.now();
    final weekDays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
    final month = now.month;
    final day = now.day;
    final weekDay = weekDays[now.weekday - 1];
    return '${month}月${day}日 $weekDay';
  }

  /// 获取当前时间字符串（如：14:30）
  static String getFormattedTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// 根据时间段生成欢迎语
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '夜深了，注意休息 🌙';
    if (hour < 9) return '早上好！新的一天开始了 ☀️';
    if (hour < 12) return '上午好！专注的时光最美好 🌤️';
    if (hour < 14) return '中午好！别忘了休息一下 🍱';
    if (hour < 18) return '下午好！继续加油 💪';
    if (hour < 21) return '晚上好！善用每一分钟 🌆';
    return '夜深了，注意休息 🌙';
  }

  /// 将秒数格式化为 HH:MM:SS
  static String formatSeconds(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours}小时${minutes}分钟';
    }
    if (minutes > 0) {
      return '${minutes}分钟${seconds}秒';
    }
    return '${seconds}秒';
  }

  /// 将秒数格式化为精简显示（如：2.5h, 45m）
  static String formatSecondsCompact(int totalSeconds) {
    final hours = totalSeconds / 3600;
    if (hours >= 1) {
      return '${hours.toStringAsFixed(1)}h';
    }
    final minutes = totalSeconds / 60;
    return '${minutes.toStringAsFixed(0)}m';
  }

  /// 判断两个日期是否是同一天
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 获取今天的开始时间
  static DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 获取本周的开始时间（周一）
  static DateTime get weekStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
  }

  /// 格式化日期为简短显示
  static String formatDateShort(DateTime date) {
    return DateFormat('MM/dd').format(date);
  }

  /// 格式化日期为完整显示
  static String formatDateFull(DateTime date) {
    return DateFormat('yyyy年MM月dd日 HH:mm').format(date);
  }

  /// 格式化分钟数为时间显示
  static String formatMinutes(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return mins > 0 ? '${hours}小时${mins}分钟' : '${hours}小时';
    }
    return '${minutes}分钟';
  }
}
