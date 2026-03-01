import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/presentation/battle/battle_bgm_controller.dart';
import 'package:ironmon/presentation/shared/audio_service.dart';

/// Singleton [AudioService] provider.
/// Initialises once and disposes on tear-down.
final audioServiceProvider =
    Provider<AudioService>((ref) {
  final service = AudioService();
  // Initialise asynchronously — callers should
  // await init before playback.
  service.init();
  ref.onDispose(service.dispose);
  return service;
});

/// Provides the [BattleBgmController] singleton.
final battleBgmControllerProvider =
    Provider<BattleBgmController>((ref) {
  final audio = ref.watch(audioServiceProvider);
  return BattleBgmController(audio);
});

/// Whether BGM is globally muted.
final isMutedProvider =
    StateProvider<bool>((ref) => false);

/// BGM volume level (0.0 – 1.0).
final bgmVolumeProvider =
    StateProvider<double>((ref) => 0.7);

/// SFX volume level (0.0 – 1.0).
final sfxVolumeProvider =
    StateProvider<double>((ref) => 1.0);
