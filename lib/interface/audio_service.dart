/// Interface for managing audio playback within the application.
///
/// This interface defines the contract for services that can play,
/// stop, and manage sound effects or music.
abstract class IAudioService {
  /// Plays a sound from the application's assets.
  ///
  /// [soundAssetPath] The path to the sound file within the assets directory
  /// (e.g., 'sounds/notification.mp3').
  ///
  /// This method should handle loading and playing the specified sound.
  /// If a sound is already playing, it might either stop the current sound
  /// and play the new one, or play them concurrently, depending on the
  /// implementation.
  Future<void> playSound(String soundAssetPath);

  /// Stops any currently playing sound.
  ///
  /// This method should halt all audio playback initiated by this service.
  Future<void> stopSound();

  /// Preloads a sound for faster playback.
  ///
  /// [soundAssetPath] The path to the sound file within the assets directory.
  ///
  /// This can be used to load sounds into memory before they are needed,
  /// reducing latency when `playSound` is called.
  Future<void> preloadSound(String soundAssetPath);

  /// Releases any resources associated with the audio service.
  ///
  /// This method should be called when the audio service is no longer
  /// needed to free up system resources.
  void dispose();
}
