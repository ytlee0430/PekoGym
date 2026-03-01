import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/presentation/shared/audio_service.dart';

/// Maps battle phases to BGM tracks and triggers
/// crossfade transitions via [AudioService].
class BattleBgmController {
  /// Creates a [BattleBgmController].
  const BattleBgmController(this._audio);

  final AudioService _audio;

  static const _warmupTrack =
      'audio/bgm/battle_warmup.mp3';
  static const _midBossTrack =
      'audio/bgm/battle_midboss.mp3';
  static const _bossTrack =
      'audio/bgm/battle_boss.mp3';

  /// Returns the BGM asset path for [phase],
  /// or null when no music should play.
  static String? trackForPhase(BattlePhase phase) {
    return switch (phase) {
      Idle() => null,
      Warmup() => _warmupTrack,
      MidBossPhase() => _midBossTrack,
      GymLeaderPhase() => _bossTrack,
      BattleResult() => null,
    };
  }

  /// Called when the battle phase changes.
  /// Crossfades to the matching track, or stops
  /// BGM when the battle ends.
  Future<void> onPhaseChanged(
    BattlePhase phase,
  ) async {
    final track = trackForPhase(phase);
    if (track == null) {
      await _audio.stopBgm(
        fadeOut: const Duration(
          milliseconds: 500,
        ),
      );
    } else {
      await _audio.crossfadeBgm(
        track,
        duration: const Duration(
          milliseconds: 500,
        ),
      );
    }
  }
}
