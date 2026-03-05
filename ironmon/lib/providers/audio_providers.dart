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
    NotifierProvider<_BoolNotifier, bool>(_BoolNotifier.new);

/// BGM volume level (0.0 – 1.0).
final bgmVolumeProvider =
    NotifierProvider<_BgmVolumeNotifier, double>(_BgmVolumeNotifier.new);

/// SFX volume level (0.0 – 1.0).
final sfxVolumeProvider =
    NotifierProvider<_SfxVolumeNotifier, double>(_SfxVolumeNotifier.new);

class _BoolNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool value) => state = value;
}

class _BgmVolumeNotifier extends Notifier<double> {
  @override
  double build() => 0.7;
  void set(double value) => state = value;
}

class _SfxVolumeNotifier extends Notifier<double> {
  @override
  double build() => 1.0;
  void set(double value) => state = value;
}
