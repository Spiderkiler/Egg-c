/// 咸蛋时钟 - 应用入口
/// 专注每一分钟，像咸蛋一样沉淀自己。
/// 初始化所有服务和依赖，启动应用主界面。
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_viewmodel.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/sound_service.dart';
import 'services/timer_service.dart';
import 'services/achievement_service.dart';
import 'repositories/task_repository.dart';
import 'repositories/focus_repository.dart';
import 'repositories/settings_repository.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/focus_viewmodel.dart';
import 'viewmodels/task_viewmodel.dart';
import 'viewmodels/statistics_viewmodel.dart';
import 'viewmodels/achievement_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'widgets/app_shell.dart';
import 'widgets/theme_transition_overlay.dart';

void main() async {
  // 确保Flutter绑定已完成
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Window Manager（Windows桌面端）
  await _initWindowManager();

  // 初始化存储服务
  await StorageService.init();

  // 初始化通知服务
  final notificationService = NotificationService();
  await notificationService.init();

  // 初始化声音服务
  final soundService = SoundService();

  // 初始化计时器服务
  final timerService = TimerService();

  // 初始化仓库层
  final taskRepository = TaskRepository();
  final focusRepository = FocusRepository();
  final settingsRepository = SettingsRepository();

  // 初始化成就服务
  final achievementService = AchievementService(
    notificationService: notificationService,
  );

  // 初始化默认成就数据
  await StorageService.initDefaultAchievements();

  // 启动应用
  runApp(
    SaltedEggClockApp(
      notificationService: notificationService,
      soundService: soundService,
      timerService: timerService,
      taskRepository: taskRepository,
      focusRepository: focusRepository,
      settingsRepository: settingsRepository,
      achievementService: achievementService,
    ),
  );
}

/// 初始化窗口管理器
Future<void> _initWindowManager() async {
  await windowManager.ensureInitialized();

  // 设置窗口参数
  const windowOptions = WindowOptions(
    size: Size(
      AppConstants.windowWidth,
      AppConstants.windowHeight,
    ),
    minimumSize: Size(
      AppConstants.windowMinWidth,
      AppConstants.windowMinHeight,
    ),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // 设置窗口为可拖拽
  await windowManager.setPreventClose(false);
}

/// 咸蛋时钟应用根Widget
class SaltedEggClockApp extends StatelessWidget {
  final NotificationService notificationService;
  final SoundService soundService;
  final TimerService timerService;
  final TaskRepository taskRepository;
  final FocusRepository focusRepository;
  final SettingsRepository settingsRepository;
  final AchievementService achievementService;

  const SaltedEggClockApp({
    super.key,
    required this.notificationService,
    required this.soundService,
    required this.timerService,
    required this.taskRepository,
    required this.focusRepository,
    required this.settingsRepository,
    required this.achievementService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ============ 主题ViewModel ============
        ChangeNotifierProvider<ThemeViewModel>(
          create: (_) => ThemeViewModel(
            settingsRepository: settingsRepository,
          ),
        ),

        // ============ ViewModel层 ============
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(
            focusRepository: focusRepository,
            taskRepository: taskRepository,
          ),
        ),

        ChangeNotifierProvider<FocusViewModel>(
          create: (_) => FocusViewModel(
            timerService: timerService,
            focusRepository: focusRepository,
            settingsRepository: settingsRepository,
            taskRepository: taskRepository,
            notificationService: notificationService,
            soundService: soundService,
            achievementService: achievementService,
          ),
        ),

        ChangeNotifierProvider<TaskViewModel>(
          create: (_) => TaskViewModel(
            taskRepository: taskRepository,
            achievementService: achievementService,
          ),
        ),

        ChangeNotifierProvider<StatisticsViewModel>(
          create: (_) => StatisticsViewModel(
            focusRepository: focusRepository,
          ),
        ),

        ChangeNotifierProvider<AchievementViewModel>(
          create: (_) => AchievementViewModel(
            achievementService: achievementService,
          ),
        ),

        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => SettingsViewModel(
            settingsRepository: settingsRepository,
            soundService: soundService,
            timerService: timerService,
          ),
        ),
      ],
      child: const AppRoot(),
    );
  }
}

/// 应用根节点
/// 监听主题变化，构建 MaterialApp
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 初始化平台亮度
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      context.read<ThemeViewModel>().updatePlatformBrightness(brightness);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    context.read<ThemeViewModel>().updatePlatformBrightness(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeVm, child) {
        return MaterialApp(
          title: '咸蛋时钟',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeVm.themeMode,
          themeAnimationDuration: AppTheme.themeTransitionDuration,
          themeAnimationCurve: AppTheme.themeTransitionCurve,
          home: ThemeTransitionOverlay(
            isDark: themeVm.isDark,
            child: const AppShell(),
          ),
        );
      },
    );
  }
}
