/// 白噪音播放服务
/// 基于 audioplayers 的背景音播放管理服务
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();

  /// 获取单例实例
  factory SoundService() => _instance;

  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _alertPlayer = AudioPlayer();

  /// 当前播放的声音ID
  String? _currentSoundId;

  /// 当前音量
  double _volume = 0.5;

  /// 是否正在播放
  bool _isPlaying = false;

  /// 是否正在播放
  bool get isPlaying => _isPlaying;

  /// 当前播放的声音ID
  String? get currentSoundId => _currentSoundId;

  /// 当前音量
  double get volume => _volume;

  /// 播放完成提示音
  /// 使用触感反馈 + 独立 AudioPlayer，不会干扰背景白噪音
  void playCompletionSound() {
    // 触感反馈（所有平台安全调用）
    HapticFeedback.heavyImpact();

    // 播放完成提示音文件（如果存在）
    try {
      _alertPlayer.play(AssetSource('sounds/radar-iphone-ringtone.mp3'));
    } catch (_) {
      // completion.mp3 不存在时静默忽略
    }
  }

  /// 播放指定白噪音
  Future<void> play(String soundId, String assetPath) async {
    if (_currentSoundId == soundId && _isPlaying) return;

    await stop();

    _currentSoundId = soundId;

    await _player.setSource(AssetSource(assetPath.replaceFirst('assets/', '')));
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(_volume);
    await _player.resume();

    _isPlaying = true;
  }

  /// 暂停播放
  Future<void> pause() async {
    if (!_isPlaying) return;
    await _player.pause();
    _isPlaying = false;
  }

  /// 恢复播放
  Future<void> resume() async {
    if (_isPlaying) return;
    await _player.resume();
    _isPlaying = true;
  }

  /// 停止播放
  Future<void> stop() async {
    await _player.stop();
    _isPlaying = false;
    _currentSoundId = null;
  }

  /// 设置音量（0.0 - 1.0）
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
  }

  /// 释放资源
  void dispose() {
    _player.dispose();
    _alertPlayer.dispose();
  }
}
