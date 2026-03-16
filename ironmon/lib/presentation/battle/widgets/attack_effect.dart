import 'package:flutter/material.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Full-screen attack effect overlay, styled per move type.
///
/// Fire  → flame burst particles
/// Water → wave ripple
/// Rock  → ground crack lines
/// Electric → lightning bolts
/// Fighting → impact star burst
class AttackEffect extends StatefulWidget {
  const AttackEffect({
    required this.moveType,
    required this.onComplete,
    super.key,
  });

  final MuscleType moveType;
  final VoidCallback onComplete;

  @override
  State<AttackEffect> createState() => _AttackEffectState();
}

class _AttackEffectState extends State<AttackEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _ctrl.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = IronMonColors.colorForType(widget.moveType);
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _AttackEffectPainter(
              type: widget.moveType,
              progress: _progress.value,
              color: color,
            ),
          );
        },
      ),
    );
  }
}

class _AttackEffectPainter extends CustomPainter {
  _AttackEffectPainter({
    required this.type,
    required this.progress,
    required this.color,
  });

  final MuscleType type;
  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    if (opacity <= 0) return;

    switch (type) {
      case MuscleType.chest:
        _drawFireEffect(canvas, size, opacity);
      case MuscleType.back:
        _drawWaterEffect(canvas, size, opacity);
      case MuscleType.legs:
        _drawRockEffect(canvas, size, opacity);
      case MuscleType.shoulders:
        _drawElectricEffect(canvas, size, opacity);
      case MuscleType.arms:
        _drawFightingEffect(canvas, size, opacity);
    }
  }

  void _drawFireEffect(Canvas canvas, Size s, double opacity) {
    final cx = s.width * 0.7;
    final cy = s.height * 0.25;
    final p = Paint()..color = color.withValues(alpha: opacity * 0.6);

    // Expanding flame circles
    for (var i = 0; i < 5; i++) {
      final r = progress * 60 + i * 15;
      final o = (opacity * (1 - i * 0.15)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(cx + (i - 2) * 12, cy + (i.isEven ? -10 : 10) * progress),
        r,
        Paint()..color = color.withValues(alpha: o * 0.4),
      );
    }

    // Central burst
    canvas.drawCircle(
      Offset(cx, cy),
      progress * 40,
      Paint()..color = Colors.white.withValues(alpha: opacity * 0.5),
    );
  }

  void _drawWaterEffect(Canvas canvas, Size s, double opacity) {
    final cx = s.width * 0.7;
    final cy = s.height * 0.25;

    // Concentric ripples
    for (var i = 0; i < 4; i++) {
      final r = progress * 80 + i * 25;
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..color = color.withValues(alpha: opacity * 0.3 * (1 - i * 0.2))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
    }
  }

  void _drawRockEffect(Canvas canvas, Size s, double opacity) {
    final cx = s.width * 0.7;
    final cy = s.height * 0.25;

    // Crack lines radiating from center
    for (var i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      final len = progress * 70;
      final cos = _approxCos(angle);
      final sin = _approxSin(angle);
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + cos * len, cy + sin * len),
        Paint()
          ..color = color.withValues(alpha: opacity * 0.7)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Central impact
    canvas.drawCircle(
      Offset(cx, cy),
      progress * 20,
      Paint()..color = Colors.white.withValues(alpha: opacity * 0.5),
    );
  }

  void _drawElectricEffect(Canvas canvas, Size s, double opacity) {
    final cx = s.width * 0.7;
    final cy = s.height * 0.25;

    // Lightning bolt zigzags
    for (var b = 0; b < 3; b++) {
      final path = Path();
      final startX = cx + (b - 1) * 30.0;
      path.moveTo(startX, cy - 50 * progress);
      var y = cy - 50 * progress;
      for (var seg = 0; seg < 5; seg++) {
        y += 20 * progress;
        final dx = (seg.isEven ? 15.0 : -15.0) * progress;
        path.lineTo(startX + dx, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: opacity * 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    // Flash
    canvas.drawCircle(
      Offset(cx, cy),
      progress * 30,
      Paint()..color = Colors.white.withValues(alpha: opacity * 0.4),
    );
  }

  void _drawFightingEffect(Canvas canvas, Size s, double opacity) {
    final cx = s.width * 0.7;
    final cy = s.height * 0.25;

    // Impact star
    final star = Path();
    for (var i = 0; i < 8; i++) {
      final angle = i * 3.14159 / 4;
      final r = i.isEven ? progress * 50 : progress * 25;
      final x = cx + _approxCos(angle) * r;
      final y = cy + _approxSin(angle) * r;
      if (i == 0) {
        star.moveTo(x, y);
      } else {
        star.lineTo(x, y);
      }
    }
    star.close();
    canvas.drawPath(star, Paint()..color = color.withValues(alpha: opacity * 0.5));

    // POW circle
    canvas.drawCircle(
      Offset(cx, cy),
      progress * 25,
      Paint()..color = Colors.white.withValues(alpha: opacity * 0.6),
    );
  }

  double _approxCos(double a) {
    a = a % (2 * 3.14159265);
    var r = 1.0;
    var t = 1.0;
    for (var i = 1; i <= 8; i++) {
      t *= -a * a / ((2 * i - 1) * (2 * i));
      r += t;
    }
    return r;
  }

  double _approxSin(double a) {
    a = a % (2 * 3.14159265);
    var r = a;
    var t = a;
    for (var i = 1; i <= 8; i++) {
      t *= -a * a / ((2 * i) * (2 * i + 1));
      r += t;
    }
    return r;
  }

  @override
  bool shouldRepaint(covariant _AttackEffectPainter old) =>
      progress != old.progress;
}
