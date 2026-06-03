/// 专注页面 ViewModel
/// 管理番茄时钟的核心逻辑，包括定时器控制、模式切换、记录保存
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/focus_record_model.dart';
import '../models/user_settings_model.dart';
import '../services/timer_service.dart';
import '../services/notification_service.dart';
import '../services/sound_service.dart';
import '../services/achievement_service.dart';
import '../repositories/focus_repository.dart';
import '../repositories/settings_repository.dart';
import '../repositories/task_repository.dart';
import '../models/task_model.dart';

class FocusViewModel extends ChangeNotifier {
  final TimerService _timerService;
  final FocusRepository _focusRepository;
  final SettingsRepository _settingsRepository;
  final TaskRepository _taskRepository;
  final NotificationService _notificationService;
  final SoundService _soundService;
  final AchievementService _achievementService;

  /// 当前关联的任务
  TaskModel? selectedTask;

  /// 是否显示任务选择器
  bool showTaskPicker = false;

  /// 当前设置
  UserSettingsModel _settings;

  FocusViewModel({
    required TimerService timerService,
    required FocusRepository focusRepository,
    required SettingsRepository settingsRepository,
    required TaskRepository taskRepository,
    required NotificationService notificationService,
    required SoundService soundService,
    required AchievementService achievementService,
  })  : _timerService = timerService,
        _focusRepository = focusRepository,
        _settingsRepository = settingsRepository,
        _taskRepository = taskRepository,
        _notificationService = notificationService,
        _soundService = soundService,
        _achievementService = achievementService,
        _settings = settingsRepository.get() {
    // 监听计时器变化
    _timerService.addListener(_onTimerChanged);
  }

  // ============ Getters 代理 ============

  TimerState get state => _timerService.state;
  TimerMode get mode => _timerService.mode;
  int get remainingSeconds => _timerService.remainingSeconds;
  int get totalSeconds => _timerService.totalSeconds;
  int get elapsedSeconds => _timerService.elapsedSeconds;
  double get progress => _timerService.progress;
  String get formattedRemaining => _timerService.formattedRemaining;
  String get formattedTotal => _timerService.formattedTotal;
  int get cycleCount => _timerService.cycleCount;
  bool get isIdle => _timerService.isIdle;
  bool get isRunning => _timerService.isRunning;
  bool get isPaused => _timerService.isPaused;
  bool get isBreakMode => _timerService.isBreakMode;
  UserSettingsModel get settings => _settings;

  /// 获取未完成的任务列表
  List<TaskModel> get activeTasks => _taskRepository.getActive();

  // ============ 计时器操作 ============

  /// 开始计时
  void start() {
    _timerService.start();
    if (_settings.soundEnabled) {
      _soundService.resume();
    }
  }

  /// 暂停计时
  void pause() {
    _timerService.pause();
    _soundService.pause();
  }

  /// 继续计时
  void resume() {
    _timerService.resume();
    if (_settings.soundEnabled) {
      _soundService.resume();
    }
  }

  /// 重置计时
  void reset() {
    _timerService.reset();
    _soundService.pause();
  }

  /// 跳过当前计时
  void skip() {
    _timerService.skip();
    _soundService.pause();
  }

  /// 切换开始/暂停
  void toggleStartPause() {
    if (isRunning) {
      pause();
    } else if (isPaused) {
      resume();
    } else {
      start();
    }
  }

  /// 切换到专注模式
  void switchToFocus() {
    _timerService.switchToFocus(_settings.focusDuration);
  }

  /// 切换到短休息
  void switchToShortBreak() {
    _timerService.switchToShortBreak(_settings.shortBreakDuration);
  }

  /// 切换到长休息
  void switchToLongBreak() {
    _timerService.switchToLongBreak(_settings.longBreakDuration);
  }

  /// 切换任务选择器
  void toggleTaskPicker() {
    showTaskPicker = !showTaskPicker;
    notifyListeners();
  }

  /// 选择关联任务
  void selectTask(TaskModel? task) {
    selectedTask = task;
    showTaskPicker = false;
    notifyListeners();
  }

  /// 计时器变化回调
  void _onTimerChanged() async {
    if (_timerService.state == TimerState.completed) {
      try {
        // 播放完成提示音（触感反馈 + 提示音文件）
        _soundService.playCompletionSound();

        final record = _timerService.takeCompletedRecord();
        if (record != null) {
          await _focusRepository.save(record);

          // 如果是专注完成且关联了任务，增加任务的番茄钟
          if (record.type == FocusType.focus && selectedTask != null) {
            await _taskRepository.incrementPomodoro(selectedTask!);
          }

          // 发送通知
          if (_settings.notificationsEnabled) {
            if (record.type == FocusType.focus) {
              await _notificationService.showFocusEndNotification();
            } else {
              await _notificationService.showBreakEndNotification();
            }
          }

          // 检查成就
          await _achievementService.checkAll();
        }

        _soundService.pause();
      } catch (e) {
        // 保证回调异常时计时器状态仍被正确清理
        debugPrint('FocusViewModel._onTimerChanged error: $e');
        _timerService.takeCompletedRecord();
        _soundService.pause();
      }
    }
    notifyListeners();
  }

  /// 刷新设置
  void refreshSettings() {
    _settings = _settingsRepository.get();
    _timerService.setLongBreakInterval(_settings.longBreakInterval);
    // 同步保存的专注时长到计时器，避免启动时始终显示默认的 25 分钟
    if (!_timerService.isRunning) {
      _timerService.setFocusDuration(_settings.focusDuration);
    }
    notifyListeners();
  }

  /// 处理键盘快捷键
  KeyEventResult handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        toggleStartPause();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.keyR) {
        reset();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  /// 选择计时模式
  void selectMode(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus:
        switchToFocus();
        break;
      case TimerMode.shortBreak:
        switchToShortBreak();
        break;
      case TimerMode.longBreak:
        switchToLongBreak();
        break;
    }
  }

  @override
  void dispose() {
    _timerService.removeListener(_onTimerChanged);
    super.dispose();
  }
}
