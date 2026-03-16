import 'package:flutter/material.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Pokemon-style boss sprite widget.
///
/// Renders a unique creature per [MuscleType] × [BossStage] combination
/// using CustomPaint for a pixel-art aesthetic. Each type has a distinct
/// silhouette; stage controls size and decoration (crown, spikes, etc.).
class BossSprite extends StatelessWidget {
  const BossSprite({
    required this.boss,
    this.size = 90,
    this.showGlow = true,
    super.key,
  });

  final Boss boss;
  final double size;
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    final typeColor = IronMonColors.colorForType(boss.type);
    final stageScale = switch (boss.stage) {
      BossStage.minion => 0.7,
      BossStage.midBoss => 0.85,
      BossStage.gymLeader => 1.0,
    };
    final effectiveSize = size * stageScale;

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: effectiveSize,
          height: effectiveSize,
          decoration: showGlow
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: typeColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
                )
              : null,
          child: CustomPaint(
            size: Size(effectiveSize, effectiveSize),
            painter: _BossSpritePainter(
              type: boss.type,
              stage: boss.stage,
              color: typeColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Draws pixel-art creatures for each type.
class _BossSpritePainter extends CustomPainter {
  _BossSpritePainter({
    required this.type,
    required this.stage,
    required this.color,
  });

  final MuscleType type;
  final BossStage stage;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case MuscleType.chest:
        _drawFireCreature(canvas, size);
      case MuscleType.back:
        _drawWaterCreature(canvas, size);
      case MuscleType.legs:
        _drawRockCreature(canvas, size);
      case MuscleType.shoulders:
        _drawElectricCreature(canvas, size);
      case MuscleType.arms:
        _drawFightingCreature(canvas, size);
    }

    // Gym leader crown
    if (stage == BossStage.gymLeader) {
      _drawCrown(canvas, size);
    }
    // Mid-boss spikes
    if (stage == BossStage.midBoss) {
      _drawSpikes(canvas, size);
    }
  }

  // Fire (Chest) - flame creature: round body with flame tips on top
  void _drawFireCreature(Canvas canvas, Size s) {
    final p = Paint()..color = color;
    final dark = Paint()..color = _darken(color, 0.3);
    final light = Paint()..color = _lighten(color, 0.3);
    final eye = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF1A1A2E);
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.35;

    // Body
    canvas.drawCircle(Offset(cx, cy + r * 0.15), r, p);
    // Belly
    canvas.drawCircle(Offset(cx, cy + r * 0.4), r * 0.6, light);

    // Flame tips
    final flamePath = Path()
      ..moveTo(cx - r * 0.5, cy - r * 0.6)
      ..lineTo(cx - r * 0.2, cy - r * 1.2)
      ..lineTo(cx, cy - r * 0.7)
      ..lineTo(cx + r * 0.2, cy - r * 1.3)
      ..lineTo(cx + r * 0.5, cy - r * 0.6)
      ..close();
    canvas.drawPath(flamePath, dark);

    // Inner flame
    final innerFlame = Path()
      ..moveTo(cx - r * 0.3, cy - r * 0.5)
      ..lineTo(cx - r * 0.05, cy - r * 0.95)
      ..lineTo(cx + r * 0.05, cy - r * 0.5)
      ..lineTo(cx + r * 0.2, cy - r * 1.0)
      ..lineTo(cx + r * 0.3, cy - r * 0.5)
      ..close();
    canvas.drawPath(innerFlame, Paint()..color = const Color(0xFFFFD93D));

    // Eyes
    canvas.drawCircle(Offset(cx - r * 0.3, cy), r * 0.18, eye);
    canvas.drawCircle(Offset(cx + r * 0.3, cy), r * 0.18, eye);
    canvas.drawCircle(Offset(cx - r * 0.3, cy), r * 0.09, pupil);
    canvas.drawCircle(Offset(cx + r * 0.3, cy), r * 0.09, pupil);

    // Mouth
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.35), width: r * 0.6, height: r * 0.3),
      0.1, 3.0, false,
      Paint()..color = dark.color..style = PaintingStyle.stroke..strokeWidth = 2,
    );
  }

  // Water (Back) - turtle/shell creature: shell on top, fins
  void _drawWaterCreature(Canvas canvas, Size s) {
    final p = Paint()..color = color;
    final dark = Paint()..color = _darken(color, 0.3);
    final light = Paint()..color = _lighten(color, 0.4);
    final eye = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF1A1A2E);
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.35;

    // Shell (oval)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - r * 0.1), width: r * 2, height: r * 1.6),
      dark,
    );
    // Shell pattern lines
    for (var i = -2; i <= 2; i++) {
      canvas.drawLine(
        Offset(cx + i * r * 0.3, cy - r * 0.7),
        Offset(cx + i * r * 0.35, cy + r * 0.5),
        Paint()..color = color..strokeWidth = 1.5..style = PaintingStyle.stroke,
      );
    }

    // Face area (lighter)
    canvas.drawCircle(Offset(cx, cy + r * 0.3), r * 0.55, light);

    // Eyes
    canvas.drawCircle(Offset(cx - r * 0.25, cy + r * 0.15), r * 0.16, eye);
    canvas.drawCircle(Offset(cx + r * 0.25, cy + r * 0.15), r * 0.16, eye);
    canvas.drawCircle(Offset(cx - r * 0.25, cy + r * 0.15), r * 0.08, pupil);
    canvas.drawCircle(Offset(cx + r * 0.25, cy + r * 0.15), r * 0.08, pupil);

    // Mouth
    canvas.drawLine(
      Offset(cx - r * 0.15, cy + r * 0.5),
      Offset(cx + r * 0.15, cy + r * 0.5),
      Paint()..color = dark.color..strokeWidth = 2..strokeCap = StrokeCap.round,
    );

    // Fins
    final leftFin = Path()
      ..moveTo(cx - r, cy)
      ..lineTo(cx - r * 1.4, cy - r * 0.3)
      ..lineTo(cx - r * 1.2, cy + r * 0.2)
      ..close();
    canvas.drawPath(leftFin, p);
    final rightFin = Path()
      ..moveTo(cx + r, cy)
      ..lineTo(cx + r * 1.4, cy - r * 0.3)
      ..lineTo(cx + r * 1.2, cy + r * 0.2)
      ..close();
    canvas.drawPath(rightFin, p);
  }

  // Rock (Legs) - golem: angular body, rocky texture
  void _drawRockCreature(Canvas canvas, Size s) {
    final p = Paint()..color = color;
    final dark = Paint()..color = _darken(color, 0.3);
    final light = Paint()..color = _lighten(color, 0.3);
    final eye = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF1A1A2E);
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.35;

    // Angular body
    final body = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r * 0.8, cy - r * 0.3)
      ..lineTo(cx + r, cy + r * 0.5)
      ..lineTo(cx + r * 0.5, cy + r)
      ..lineTo(cx - r * 0.5, cy + r)
      ..lineTo(cx - r, cy + r * 0.5)
      ..lineTo(cx - r * 0.8, cy - r * 0.3)
      ..close();
    canvas.drawPath(body, p);

    // Rock cracks
    canvas.drawLine(
      Offset(cx - r * 0.3, cy - r * 0.5),
      Offset(cx - r * 0.1, cy + r * 0.3),
      Paint()..color = dark.color..strokeWidth = 1.5,
    );
    canvas.drawLine(
      Offset(cx + r * 0.2, cy - r * 0.3),
      Offset(cx + r * 0.4, cy + r * 0.5),
      Paint()..color = dark.color..strokeWidth = 1.5,
    );

    // Face plate
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.2, height: r * 0.9),
      light,
    );

    // Eyes (angry)
    canvas.drawCircle(Offset(cx - r * 0.25, cy - r * 0.05), r * 0.15, eye);
    canvas.drawCircle(Offset(cx + r * 0.25, cy - r * 0.05), r * 0.15, eye);
    canvas.drawCircle(Offset(cx - r * 0.25, cy - r * 0.05), r * 0.08, pupil);
    canvas.drawCircle(Offset(cx + r * 0.25, cy - r * 0.05), r * 0.08, pupil);

    // Angry brow
    canvas.drawLine(
      Offset(cx - r * 0.45, cy - r * 0.25),
      Offset(cx - r * 0.1, cy - r * 0.2),
      Paint()..color = dark.color..strokeWidth = 2.5..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(cx + r * 0.45, cy - r * 0.25),
      Offset(cx + r * 0.1, cy - r * 0.2),
      Paint()..color = dark.color..strokeWidth = 2.5..strokeCap = StrokeCap.round,
    );
  }

  // Electric (Shoulders) - spiky star creature
  void _drawElectricCreature(Canvas canvas, Size s) {
    final p = Paint()..color = color;
    final dark = Paint()..color = _darken(color, 0.2);
    final eye = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF1A1A2E);
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.3;

    // Star body with bolts
    final star = Path();
    const points = 6;
    for (var i = 0; i < points; i++) {
      final angle = (i * 3.14159 * 2 / points) - 3.14159 / 2;
      final outerR = i.isEven ? r * 1.3 : r * 0.7;
      final x = cx + outerR * _cos(angle);
      final y = cy + outerR * _sin(angle);
      if (i == 0) {
        star.moveTo(x, y);
      } else {
        star.lineTo(x, y);
      }
    }
    star.close();
    canvas.drawPath(star, p);

    // Inner circle
    canvas.drawCircle(Offset(cx, cy), r * 0.6, dark);

    // Lightning bolt marks on tips
    for (var i = 0; i < 3; i++) {
      final angle = (i * 2 * 3.14159 / 3) - 3.14159 / 2;
      final bx = cx + r * 1.1 * _cos(angle);
      final by = cy + r * 1.1 * _sin(angle);
      canvas.drawCircle(
        Offset(bx, by),
        3,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );
    }

    // Eyes
    canvas.drawCircle(Offset(cx - r * 0.25, cy - r * 0.05), r * 0.18, eye);
    canvas.drawCircle(Offset(cx + r * 0.25, cy - r * 0.05), r * 0.18, eye);
    canvas.drawCircle(Offset(cx - r * 0.25, cy - r * 0.05), r * 0.1, pupil);
    canvas.drawCircle(Offset(cx + r * 0.25, cy - r * 0.05), r * 0.1, pupil);

    // Grin
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.2), width: r * 0.7, height: r * 0.4),
      0.1, 2.9, false,
      Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2,
    );
  }

  // Fighting (Arms) - humanoid fighter
  void _drawFightingCreature(Canvas canvas, Size s) {
    final p = Paint()..color = color;
    final dark = Paint()..color = _darken(color, 0.3);
    final light = Paint()..color = _lighten(color, 0.3);
    final eye = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF1A1A2E);
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.3;

    // Torso
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + r * 0.2), width: r * 1.4, height: r * 1.6),
        Radius.circular(r * 0.3),
      ),
      p,
    );

    // Head
    canvas.drawCircle(Offset(cx, cy - r * 0.6), r * 0.55, dark);
    // Head band
    canvas.drawLine(
      Offset(cx - r * 0.55, cy - r * 0.7),
      Offset(cx + r * 0.55, cy - r * 0.7),
      Paint()..color = Colors.white..strokeWidth = 3..strokeCap = StrokeCap.round,
    );

    // Eyes (determined)
    canvas.drawCircle(Offset(cx - r * 0.2, cy - r * 0.6), r * 0.14, eye);
    canvas.drawCircle(Offset(cx + r * 0.2, cy - r * 0.6), r * 0.14, eye);
    canvas.drawCircle(Offset(cx - r * 0.2, cy - r * 0.6), r * 0.07, pupil);
    canvas.drawCircle(Offset(cx + r * 0.2, cy - r * 0.6), r * 0.07, pupil);

    // Fists (left punching out)
    canvas.drawCircle(Offset(cx - r * 1.1, cy), r * 0.3, light);
    // Right fist up
    canvas.drawCircle(Offset(cx + r * 1.0, cy - r * 0.4), r * 0.3, light);

    // Belt
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.5), width: r * 1.5, height: r * 0.2),
      dark,
    );
  }

  // Crown for gym leaders
  void _drawCrown(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final top = s.height * 0.02;
    final w = s.width * 0.35;
    final h = s.height * 0.12;

    final crown = Path()
      ..moveTo(cx - w, top + h)
      ..lineTo(cx - w, top + h * 0.3)
      ..lineTo(cx - w * 0.5, top + h * 0.6)
      ..lineTo(cx, top)
      ..lineTo(cx + w * 0.5, top + h * 0.6)
      ..lineTo(cx + w, top + h * 0.3)
      ..lineTo(cx + w, top + h)
      ..close();
    canvas.drawPath(crown, Paint()..color = const Color(0xFFFFD93D));
    // Jewel
    canvas.drawCircle(
      Offset(cx, top + h * 0.5),
      3,
      Paint()..color = Colors.red,
    );
  }

  // Spikes for mid-boss
  void _drawSpikes(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.42;
    final spike = Paint()..color = _darken(color, 0.2);

    for (var i = 0; i < 3; i++) {
      final angle = -1.57 + (i - 1) * 0.7;
      final bx = cx + r * _cos(angle);
      final by = cy + r * _sin(angle);
      final tip = Path()
        ..moveTo(bx - 4, by + 3)
        ..lineTo(bx, by - 8)
        ..lineTo(bx + 4, by + 3)
        ..close();
      canvas.drawPath(tip, spike);
    }
  }

  static double _cos(double a) => _cosLookup(a);
  static double _sin(double a) => _sinLookup(a);

  static double _cosLookup(double a) {
    // Simple cos using Dart math
    return a.isNaN ? 0 : _dartCos(a);
  }

  static double _sinLookup(double a) {
    return a.isNaN ? 0 : _dartSin(a);
  }

  // Inline trig to avoid dart:math import in a painting context
  static double _dartCos(double x) {
    // Taylor series approximation (good enough for our use)
    x = x % (2 * 3.14159265);
    var result = 1.0;
    var term = 1.0;
    for (var i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  static double _dartSin(double x) {
    x = x % (2 * 3.14159265);
    var result = x;
    var term = x;
    for (var i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  Color _darken(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  Color _lighten(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  bool shouldRepaint(covariant _BossSpritePainter oldDelegate) =>
      type != oldDelegate.type ||
      stage != oldDelegate.stage ||
      color != oldDelegate.color;
}
