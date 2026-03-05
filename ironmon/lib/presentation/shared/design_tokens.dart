import 'package:flutter/material.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';

/// Centralized design tokens for the IronMon dark pixel theme.
/// All color, spacing, and size constants are defined here
/// to ensure visual consistency across the app.
///
/// Reference: UX Design Specification — Visual Design Foundation
abstract final class IronMonColors {
  // ── Primary Palette (Dark) ──────────────────────────

  /// Main background color.
  static const surface = Color(0xFF0D1117);

  /// Card / panel background color.
  static const surfaceVariant = Color(0xFF161B22);

  /// Primary action color (buttons, active states).
  static const primary = Color(0xFF58A6FF);

  /// Text on primary color.
  static const onPrimary = Color(0xFFFFFFFF);

  /// Secondary accent (EXP bar, important numbers).
  static const secondary = Color(0xFFF0C040);

  /// Text on secondary color.
  static const onSecondary = Color(0xFF000000);

  /// Primary color container (selected card background).
  static const primaryContainer = Color(0xFF1F3552);

  /// Text/icon on primary container.
  static const onPrimaryContainer = Color(0xFF58A6FF);

  /// Border / divider color.
  static const outline = Color(0xFF30363D);

  /// Error / low HP color.
  static const error = Color(0xFFF85149);

  /// General text on surface.
  static const onSurface = Color(0xFFC9D1D9);

  /// Secondary text on surface.
  static const onSurfaceVariant = Color(0xFF8B949E);

  // ── Type Effectiveness Colors ───────────────────────

  /// Fire type (Chest) color.
  static const typeFire = Color(0xFFFF6B35);

  /// Water type (Back) color.
  static const typeWater = Color(0xFF4B9CD3);

  /// Rock type (Legs) color.
  static const typeRock = Color(0xFFA0855B);

  /// Electric type (Shoulders) color.
  static const typeElectric = Color(0xFFFFD93D);

  /// Fighting type (Arms) color.
  static const typeFighting = Color(0xFFC2185B);

  // ── Semantic Damage Colors ──────────────────────────

  /// Normal damage text color.
  static const damageNormal = Color(0xFFFFFFFF);

  /// Critical hit damage text color.
  static const damageCritical = Color(0xFFFFD93D);

  /// Super effective damage text color.
  static const damageSuperEffective = Color(0xFFFF6B35);

  /// Not very effective damage text color.
  static const damageNotEffective = Color(0xFF8B949E);

  // ── Semantic HP Colors ──────────────────────────────

  /// HP bar color when above 50%.
  static const hpHigh = Color(0xFF3FB950);

  /// HP bar color when 25–50%.
  static const hpMid = Color(0xFFF0C040);

  /// HP bar color when below 25%.
  static const hpLow = Color(0xFFF85149);

  // ── EXP Bar ─────────────────────────────────────────

  /// EXP progress bar color.
  static const expBar = Color(0xFF58A6FF);

  // ── HP Bar Track ────────────────────────────────────

  /// HP bar background track color.
  static const hpBarTrack = Color(0xFF21262D);

  /// Returns the [Color] for a given [MuscleType].
  static Color colorForType(MuscleType type) {
    return switch (type) {
      MuscleType.chest => typeFire,
      MuscleType.back => typeWater,
      MuscleType.legs => typeRock,
      MuscleType.shoulders => typeElectric,
      MuscleType.arms => typeFighting,
    };
  }
}

/// 8dp grid spacing tokens used throughout the app.
///
/// Reference: UX Design Specification — Spacing System
abstract final class IronMonSpacing {
  /// 4dp — internal element spacing.
  static const double xs = 4;

  /// 8dp — tight arrangement.
  static const double sm = 8;

  /// 16dp — standard spacing.
  static const double md = 16;

  /// 24dp — section spacing.
  static const double lg = 24;

  /// 32dp — major block spacing.
  static const double xl = 32;

  /// 48dp — screen region spacing.
  static const double xxl = 48;
}

/// Standard touch-target sizes.
///
/// Reference: UX Design Specification — Touch Targets
abstract final class IronMonSizes {
  /// Minimum touch target (Material 3 standard).
  static const double touchMin = 48;

  /// Battle button size (glove-friendly).
  static const double battleButton = 56;

  /// Standard border radius for cards.
  static const double cardRadius = 12;

  /// Standard border radius for HP bars.
  static const double barRadius = 8;
}
