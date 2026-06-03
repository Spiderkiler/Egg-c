/// 设置页面
/// 管理用户的全部偏好设置，包括计时、通知、声音、主题等
library;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_viewmodel.dart';
import '../viewmodels/settings_viewmodel.dart';
import '../widgets/glass_card.dart';
import '../widgets/sound_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsViewModel>().reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<SettingsViewModel>(
      builder: (context, vm, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题
              Text(
                '⚙ 设置',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '自定义你的专注体验',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white38 : AppColors.textDisabled,
                ),
              ),

              const SizedBox(height: 32),

              // 专注时间设置
              _buildSectionLabel('⏱️ 专注时间', isDark),
              const SizedBox(height: 12),
              _buildTimeSettingCard(vm, isDark),

              const SizedBox(height: 24),

              // 休息时间设置
              _buildSectionLabel('☕ 休息时间', isDark),
              const SizedBox(height: 12),
              _buildBreakSettingCard(vm, isDark),

              const SizedBox(height: 24),

              // 长休息间隔设置
              _buildSectionLabel('🔄 长休息间隔', isDark),
              const SizedBox(height: 12),
              _buildLongBreakIntervalCard(vm, isDark),

              const SizedBox(height: 24),

              // 主题设置
              _buildSectionLabel('🎨 主题外观', isDark),
              const SizedBox(height: 12),
              _buildThemeCard(vm, isDark),

              const SizedBox(height: 24),

              // 通知设置
              _buildSectionLabel('🔔 通知', isDark),
              const SizedBox(height: 12),
              _buildNotificationCard(vm, isDark),

              const SizedBox(height: 24),

              // 白噪音设置
              _buildSectionLabel('🎵 白噪音', isDark),
              const SizedBox(height: 12),
              _buildSoundCard(vm, isDark),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  /// 构建分区标题
  Widget _buildSectionLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white70 : AppColors.textSecondary,
      ),
    );
  }

  /// 构建专注时间设置卡片
  Widget _buildTimeSettingCard(SettingsViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSliderSetting(
            label: '专注时长',
            value: vm.focusDuration.toDouble(),
            unit: '分钟',
            min: 5,
            max: 60,
            divisions: 11,
            onChanged: (v) => vm.setFocusDuration(v.toInt()),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// 构建休息时间设置卡片
  Widget _buildBreakSettingCard(SettingsViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSliderSetting(
            label: '短休息时长',
            value: vm.shortBreakDuration.toDouble(),
            unit: '分钟',
            min: 1,
            max: 15,
            divisions: 14,
            onChanged: (v) => vm.setShortBreakDuration(v.toInt()),
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          _buildSliderSetting(
            label: '长休息时长',
            value: vm.longBreakDuration.toDouble(),
            unit: '分钟',
            min: 5,
            max: 45,
            divisions: 8,
            onChanged: (v) => vm.setLongBreakDuration(v.toInt()),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// 构建长休息间隔卡片
  Widget _buildLongBreakIntervalCard(SettingsViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: _buildSliderSetting(
        label: '每完成N次专注后进入长休息',
        value: vm.longBreakInterval.toDouble(),
        unit: '次',
        min: 2,
        max: 8,
        divisions: 6,
        onChanged: (v) => vm.setLongBreakInterval(v.toInt()),
        isDark: isDark,
      ),
    );
  }

  /// 构建滑块设置项
  Widget _buildSliderSetting({
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required bool isDark,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: isDark ? Colors.white70 : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : AppColors.primary.withValues(alpha: 0.1),
                  thumbColor: AppColors.primary,
                  overlayColor: AppColors.primary.withValues(alpha: 0.15),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 7,
                    pressedElevation: 4,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 16,
                  ),
                ),
                child: SizedBox(
                  height: 32,
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: divisions,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 72,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${value.toInt()} $unit',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建主题设置卡片
  Widget _buildThemeCard(SettingsViewModel vm, bool isDark) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeVm, child) {
        return GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildToggleOption(
                label: '当前主题',
                value: themeVm.themeModeLabel,
                valueKey: ValueKey(themeVm.themeModeLabel),
                onTap: () async {
                  await themeVm.cycleThemeMode();
                  // 同步更新 SettingsViewModel 中的设置状态
                  vm.reload();
                },
                isDark: isDark,
                isClickable: true,
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建通知设置卡片
  Widget _buildNotificationCard(SettingsViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSwitchOption(
            label: '启用通知提醒',
            subtitle: '专注结束和休息结束时发送通知',
            value: vm.notificationsEnabled,
            onChanged: (v) => vm.setNotificationsEnabled(v),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  /// 构建声音设置卡片
  Widget _buildSoundCard(SettingsViewModel vm, bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSwitchOption(
            label: '启用白噪音',
            subtitle: '在专注时播放背景声音',
            value: vm.soundEnabled,
            onChanged: (v) => vm.setSoundEnabled(v),
            isDark: isDark,
          ),

          if (vm.soundEnabled) ...[
            const SizedBox(height: 20),

            // 声音选择
            SoundPicker(
              sounds: vm.availableSounds,
              selectedId: vm.selectedSound,
              isPlaying: vm.soundEnabled,
              onSelect: (sound) => vm.selectSound(sound.id),
            ),

            const SizedBox(height: 20),

            // 音量控制
            Row(
              children: [
                Icon(Icons.volume_down_rounded,
                    size: 20,
                    color:
                        isDark ? Colors.white38 : AppColors.textDisabled),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : AppColors.primary.withValues(alpha: 0.1),
                      thumbColor: AppColors.primary,
                      overlayColor:
                          AppColors.primary.withValues(alpha: 0.15),
                      trackHeight: 5,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7,
                      ),
                    ),
                    child: Slider(
                      value: vm.soundVolume,
                      onChanged: (v) => vm.setSoundVolume(v),
                    ),
                  ),
                ),
                Icon(Icons.volume_up_rounded,
                    size: 20,
                    color:
                        isDark ? Colors.white38 : AppColors.textDisabled),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 构建开关选项
  Widget _buildSwitchOption({
    required String label,
    required String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white38
                        : AppColors.textDisabled,
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
        ),
      ],
    );
  }

  /// 构建点击选项
  Widget _buildToggleOption({
    required String label,
    required String value,
    required VoidCallback onTap,
    required bool isDark,
    bool isClickable = false,
    Key? valueKey,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          // 使用 AnimatedSwitcher 使主题标签切换时产生平滑过渡动画
          AnimatedSwitcher(
            duration: AppTheme.themeTransitionDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Container(
              key: valueKey,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? Colors.white70
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (isClickable) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: isDark
                          ? Colors.white38
                          : AppColors.textDisabled,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
