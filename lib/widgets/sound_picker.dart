/// 白噪音选择器组件
/// 供用户选择和切换白噪音类型
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';
import '../models/sound_model.dart';

class SoundPicker extends StatelessWidget {
  /// 所有可选声音
  final List<SoundModel> sounds;

  /// 当前选中的声音ID
  final String? selectedId;

  /// 是否正在播放
  final bool isPlaying;

  /// 选择回调
  final ValueChanged<SoundModel> onSelect;

  const SoundPicker({
    super.key,
    required this.sounds,
    this.selectedId,
    this.isPlaying = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: sounds.map((sound) {
        final isSelected = sound.id == selectedId && isPlaying;

        return GestureDetector(
          onTap: () => onSelect(sound),
          child: AnimatedContainer(
            duration: 300.ms,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.12)
                  : (isDark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.4)
                    : (isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.black.withOpacity(0.04)),
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(sound.icon, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  sound.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white70 : AppColors.textPrimary),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.volume_up_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
