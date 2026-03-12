import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyBgmVolume = 'audio_bgm_volume';
const _keySfxVolume = 'audio_sfx_volume';
const _keyMuted = 'audio_muted';
const _sfxPoolSize = 4;

/// Factory typedef for creating [AudioPlayer]s.
typedef AudioPlayerFactory = AudioPlayer Function();

/// Centralized audio service managing BGM and SFX.
/// Belongs in the presentation layer — uses
/// Flutter platform APIs via `audioplayers`.
class AudioService {
  /// Creates an [AudioService].
  /// Pass [playerFactory] to inject mock players
  /// for testing. Defaults to [AudioPlayer.new].
  AudioService({AudioPlayerFactory? playerFactory}) {
    final factory = playerFactory ?? AudioPlayer.new;
    _bgmPlayer = factory();
    _sfxPool = List.generate(
      _sfxPoolSize,
      (_) => factory(),
    );
  }

  late final AudioPlayer _bgmPlayer;
  late final List<AudioPlayer> _sfxPool;

  double _bgmVolume = 0.7;
  double _sfxVolume = 1.0;
  bool _isMuted = false;
  int _sfxPoolIndex = 0;

  /// Background music volume (0.0 – 1.0).
  double get bgmVolume => _bgmVolume;

  /// Sound effects volume (0.0 – 1.0).
  double get sfxVolume => _sfxVolume;

  /// Whether all audio is globally muted.
  bool get isMuted => _isMuted;

  /// Initialises audio settings from
  /// SharedPreferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _bgmVolume =
        prefs.getDouble(_keyBgmVolume) ?? 0.7;
    _sfxVolume =
        prefs.getDouble(_keySfxVolume) ?? 1.0;
    _isMuted = prefs.getBool(_keyMuted) ?? false;
    await _bgmPlayer.setVolume(
      _isMuted ? 0 : _bgmVolume,
    );
  }

  /// Plays BGM from [assetPath]. Loops by default.
  /// Silently ignores missing assets to avoid crashes.
  Future<void> playBgm(
    String assetPath, {
    bool loop = true,
  }) async {
    if (_isMuted) return;
    try {
      await _bgmPlayer.setVolume(_bgmVolume);
      await _bgmPlayer.setReleaseMode(
        loop ? ReleaseMode.loop : ReleaseMode.release,
      );
      await _bgmPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Asset not yet available — skip silently.
    }
  }

  /// Stops BGM with an optional [fadeOut] duration.
  Future<void> stopBgm({
    Duration fadeOut = Duration.zero,
  }) async {
    if (fadeOut == Duration.zero) {
      await _bgmPlayer.stop();
      return;
    }
    // Simple fade by stepping volume down
    final steps = 20;
    final stepMs =
        fadeOut.inMilliseconds ~/ steps;
    final startVol = _bgmVolume;
    for (var i = 1; i <= steps; i++) {
      await Future<void>.delayed(
        Duration(milliseconds: stepMs),
      );
      await _bgmPlayer.setVolume(
        startVol * (1 - i / steps),
      );
    }
    await _bgmPlayer.stop();
    await _bgmPlayer.setVolume(_bgmVolume);
  }

  /// Crossfades BGM to [newAssetPath] over
  /// [duration].
  Future<void> crossfadeBgm(
    String newAssetPath, {
    Duration duration =
        const Duration(milliseconds: 500),
  }) async {
    await stopBgm(fadeOut: duration ~/ 2);
    await playBgm(newAssetPath);
  }

  /// Plays a one-shot SFX from [assetPath].
  /// Silently ignores missing assets to avoid crashes.
  Future<void> playSfx(String assetPath) async {
    if (_isMuted) return;
    try {
      final player = _sfxPool[_sfxPoolIndex];
      _sfxPoolIndex =
          (_sfxPoolIndex + 1) % _sfxPoolSize;
      await player.setVolume(_sfxVolume);
      await player.play(AssetSource(assetPath));
    } catch (_) {
      // Asset not yet available — skip silently.
    }
  }

  /// Sets BGM volume and persists the value.
  Future<void> setBgmVolume(double value) async {
    _bgmVolume = value.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _bgmPlayer.setVolume(_bgmVolume);
    }
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setDouble(
      _keyBgmVolume,
      _bgmVolume,
    );
  }

  /// Sets SFX volume and persists the value.
  Future<void> setSfxVolume(double value) async {
    _sfxVolume = value.clamp(0.0, 1.0);
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setDouble(
      _keySfxVolume,
      _sfxVolume,
    );
  }

  /// Globally mutes or unmutes all audio.
  Future<void> setMuted(bool muted) async {
    _isMuted = muted;
    await _bgmPlayer.setVolume(
      muted ? 0 : _bgmVolume,
    );
    final prefs =
        await SharedPreferences.getInstance();
    await prefs.setBool(_keyMuted, _isMuted);
  }

  /// Releases all audio players.
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    for (final p in _sfxPool) {
      await p.dispose();
    }
  }
}
