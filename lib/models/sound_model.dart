/// 白噪音声音数据模型
/// 用于定义可用的白噪音选项
class SoundModel {
  /// 声音唯一标识
  final String id;

  /// 声音名称（中文）
  final String name;

  /// 声音图标（Emoji）
  final String icon;

  /// 资源文件路径
  final String assetPath;

  /// 创建声音对象
  const SoundModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.assetPath,
  });

  /// 获取所有内置白噪音列表
  static List<SoundModel> get builtInSounds => [
        const SoundModel(
          id: 'rain',
          name: '雨声',
          icon: '🌧️',
          assetPath: 'assets/sounds/rain.mp3',
        ),
        const SoundModel(
          id: 'forest',
          name: '森林',
          icon: '🌲',
          assetPath: 'assets/sounds/forest.mp3',
        ),
        const SoundModel(
          id: 'cafe',
          name: '咖啡馆',
          icon: '☕',
          assetPath: 'assets/sounds/cafe.mp3',
        ),
        const SoundModel(
          id: 'ocean',
          name: '海浪',
          icon: '🌊',
          assetPath: 'assets/sounds/ocean.mp3',
        ),
        const SoundModel(
          id: 'wind',
          name: '风声',
          icon: '💨',
          assetPath: 'assets/sounds/wind.mp3',
        ),
      ];
}
