import 'package:flutter/services.dart';

/// Service for triggering haptic feedback
/// during battle events.
class HapticService {
  /// Creates a [HapticService].
  const HapticService();

  /// Light vibration for normal attack hits
  /// (FR31).
  Future<void> onAttackHit() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium vibration for super effective hits.
  Future<void> onSuperEffective() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy vibration for critical events:
  /// boss defeated, evolution, level up (FR32).
  Future<void> onCriticalEvent() async {
    await HapticFeedback.heavyImpact();
  }

  /// Medium vibration for player taking damage
  /// (exhaustion/counter).
  Future<void> onPlayerDamage() async {
    await HapticFeedback.mediumImpact();
  }

  /// Selection click for UI interactions.
  Future<void> onSelectionClick() async {
    await HapticFeedback.selectionClick();
  }
}
