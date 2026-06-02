/// 应用主框架组件
/// 组合侧边导航栏和内容区域，实现整体布局
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_theme.dart';
import '../views/home_page.dart';
import '../views/focus_page.dart';
import '../views/task_page.dart';
import '../views/statistics_page.dart';
import '../views/achievement_page.dart';
import '../views/settings_page.dart';
import 'navigation_rail.dart';
import 'custom_title_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => AppShellState();
}

class AppShellState extends State<AppShell> {
  /// 当前选中的导航索引
  int _currentIndex = 0;

  /// 页面列表
  final List<Widget> _pages = const [
    HomePage(),
    FocusPage(),
    TaskPage(),
    StatisticsPage(),
    AchievementPage(),
    SettingsPage(),
  ];

  /// 切换页面
  void switchPage(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedContainer(
        duration: AppTheme.themeTransitionDuration,
        curve: AppTheme.themeTransitionCurve,
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(isDark),
        ),
        child: Column(
        children: [
          // 自定义标题栏
          const CustomTitleBar(),

          // 主体内容
          Expanded(
            child: Row(
              children: [
                // 左侧导航栏
                AppNavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: switchPage,
                ),

                // 右侧内容区域
                Expanded(
                  child: AnimatedSwitcher(
                    duration: 250.ms,
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.02, 0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOut,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(_currentIndex),
                      child: _pages[_currentIndex],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
