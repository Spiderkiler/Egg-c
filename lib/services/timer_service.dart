/// 专注计时核心服务
/// 提供精准的倒计时功能，管理专注/休息模式的切换
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/focus_record_model.dart';

/// 计时器状态枚举
enum TimerState {
  /// 空闲
  idle,

  /// 运行中
  running,

  /// 已暂停
  paused,

  /// 已完成
  completed,
}

/// 计时器模式枚举
enum TimerMode {
  /// 专注模式
  focus,

  /// 短休息模式
  shortBreak,

  /// 长休息模式
  longBreak,
}

class TimerService extends ChangeNotifier {
  /// 当前计时器状态
  TimerState _state = TimerState.idle;

  /// 当前计时器模式
  TimerMode _mode = TimerMode.focus;

  /// 总秒数
  int _totalSeconds = 25 * 60;

  /// 已流逝秒数
  int _elapsedSeconds = 0;

  /// 剩余秒数
  int _remainingSeconds = 25 * 60;

  /// 定时器
  Timer? _timer;

  /// 循环计数（用于长休息判断）
  int _cycleCount = 0;

  /// 长休息间隔（每N次专注后进入长休息）
  int _longBreakInterval = 4;

  /// 当前专注记录
  FocusRecordModel? _currentRecord;

  /// 记录开始时间
  DateTime? _sessionStartTime;

  // ============ Getters ============

  TimerState get state => _state;
  TimerMode get mode => _mode;
  int get totalSeconds => _totalSeconds;
  int get elapsedSeconds => _elapsedSeconds;
  int get remainingSeconds => _remainingSeconds;
  int get cycleCount => _cycleCount;
  int get longBreakInterval => _longBreakInterval;
  FocusRecordModel? get currentRecord => _currentRecord;

  /// 进度（0.0 - 1.0）
  double get progress {
    if (_totalSeconds <= 0) return 0.0;
    return (_elapsedSeconds / _totalSeconds).clamp(0.0, 1.0);
  }

  /// 剩余时间格式化字符串
  String get formattedRemaining {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 总时长格式化字符串
  String get formattedTotal {
    final minutes = _totalSeconds ~/ 60;
    final seconds = _totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 是否为空闲状态
  bool get isIdle => _state == TimerState.idle;

  /// 是否正在运行
  bool get isRunning => _state == TimerState.running;

  /// 是否已暂停
  bool get isPaused => _state == TimerState.paused;

  /// 是否是休息模式
  bool get isBreakMode =>
      _mode == TimerMode.shortBreak || _mode == TimerMode.longBreak;

  // ============ 计时器操作 ============

  /// 设置专注时长（分钟）
  void setFocusDuration(int minutes) {
    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  /// 设置休息时长（分钟）
  void setBreakDuration(int minutes) {
    _totalSeconds = minutes * 60;
    _remainingSeconds = _totalSeconds;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  /// 设置长休息间隔
  void setLongBreakInterval(int interval) {
    _longBreakInterval = interval;
  }

  /// 切换到专注模式
  void switchToFocus(int focusMinutes) {
    _mode = TimerMode.focus;
    _totalSeconds = focusMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _elapsedSeconds = 0;
    _state = TimerState.idle;
    _currentRecord = null;
    _sessionStartTime = null;
    notifyListeners();
  }

  /// 切换到短休息模式
  void switchToShortBreak(int breakMinutes) {
    _mode = TimerMode.shortBreak;
    _totalSeconds = breakMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _elapsedSeconds = 0;
    _state = TimerState.idle;
    _currentRecord = null;
    _sessionStartTime = null;
    notifyListeners();
  }

  /// 切换到长休息模式
  void switchToLongBreak(int breakMinutes) {
    _mode = TimerMode.longBreak;
    _totalSeconds = breakMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _elapsedSeconds = 0;
    _state = TimerState.idle;
    _currentRecord = null;
    _sessionStartTime = null;
    notifyListeners();
  }

  /// 开始计时
  void start() {
    if (_state == TimerState.running) return;

    // 如果计时已完成，重置流逝时间再开始
    if (_state == TimerState.completed) {
      _elapsedSeconds = 0;
      _remainingSeconds = _totalSeconds;
      _currentRecord = null;
      _sessionStartTime = null;
    }

    _sessionStartTime ??= DateTime.now();

    // 如果是新开始的专注，创建记录
    if (_currentRecord == null && _mode == TimerMode.focus) {
      _currentRecord = FocusRecordModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: FocusType.focus,
        durationMinutes: _totalSeconds ~/ 60,
        actualSeconds: 0,
        startTime: _sessionStartTime!,
      );
    } else if (_currentRecord == null && isBreakMode) {
      _currentRecord = FocusRecordModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _mode == TimerMode.shortBreak
            ? FocusType.shortBreak
            : FocusType.longBreak,
        durationMinutes: _totalSeconds ~/ 60,
        actualSeconds: 0,
        startTime: _sessionStartTime!,
      );
    }

    _state = TimerState.running;
    _startTicking();
    notifyListeners();
  }

  /// 暂停计时
  void pause() {
    if (_state != TimerState.running) return;
    _timer?.cancel();
    _state = TimerState.paused;
    notifyListeners();
  }

  /// 继续计时
  void resume() {
    if (_state != TimerState.paused) return;
    _state = TimerState.running;
    _startTicking();
    notifyListeners();
  }

  /// 重置计时
  void reset() {
    _timer?.cancel();
    _state = TimerState.idle;
    _elapsedSeconds = 0;
    _remainingSeconds = _totalSeconds;
    _currentRecord = null;
    _sessionStartTime = null;
    notifyListeners();
  }

  /// 跳过当前计时
  void skip() {
    _timer?.cancel();
    _elapsedSeconds = _totalSeconds;
    _remainingSeconds = 0;
    _state = TimerState.completed;
    _completeCurrentRecord();
    notifyListeners();
  }

  /// 内部计时
  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_state != TimerState.running) {
        _timer?.cancel();
        return;
      }

      _elapsedSeconds++;
      _remainingSeconds = _totalSeconds - _elapsedSeconds;

      // 更新当前记录的已用时间
      _currentRecord?.actualSeconds = _elapsedSeconds;

      if (_remainingSeconds <= 0) {
        _state = TimerState.completed;
        _timer?.cancel();
        _completeCurrentRecord();
      }

      notifyListeners();
    });
  }

  /// 完成当前记录
  void _completeCurrentRecord() {
    if (_currentRecord != null) {
      _currentRecord!.isCompleted = true;
      _currentRecord!.endTime = DateTime.now();
      _currentRecord!.actualSeconds = _elapsedSeconds;
    }

    if (_mode == TimerMode.focus) {
      _cycleCount++;
    }
  }

  /// 获取已完成但未保存的记录
  FocusRecordModel? takeCompletedRecord() {
    if (_state == TimerState.completed && _currentRecord != null) {
      final record = _currentRecord;
      _currentRecord = null;
      _sessionStartTime = null;
      return record;
    }
    return null;
  }

  /// 清理资源
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
