import 'package:audioplayers/audioplayers.dart';
import 'package:flow_focus/interface/audio_service.dart';
import 'package:flutter/foundation.dart';

class AudioService implements IAudioService {
  AudioPlayer? _audioPlayer;

  AudioPlayer _getPlayerInstance() {
    _audioPlayer ??= AudioPlayer();
    return _audioPlayer!;
  }

  @override
  Future<void> playSound(String soundAssetPath) async {
    try {
      final player = _getPlayerInstance();
      await player.play(AssetSource(soundAssetPath));
    } catch (e) {
      debugPrint("Error playing sound $soundAssetPath: $e");
    }
  }

  @override
  Future<void> stopSound() async {
    try {
      if (_audioPlayer != null && _audioPlayer!.state == PlayerState.playing) {
        await _audioPlayer!.stop();
      }
    } catch (e) {
      debugPrint("Error stopping sound: $e");
    }
  }

  @override
  Future<void> preloadSound(String soundAssetPath) async {
    debugPrint(
      "PreloadSound called for $soundAssetPath. Audioplayers handles caching implicitly.",
    );
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}
