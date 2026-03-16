import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Player back-view sprite for the battle scene.
/// Drawn with CustomPaint in pixel-art style.
class PlayerSprite extends StatelessWidget {
  const PlayerSprite({this.size = 72, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: const _PlayerPainter(),
      ),
    );
  }
}

class _PlayerPainter extends CustomPainter {
  const _PlayerPainter();

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final r = s.width * 0.35;

    // Hair / hat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, r * 0.6),
          width: r * 1.4,
          height: r * 1.0,
        ),
        Radius.circular(r * 0.4),
      ),
      Paint()..color = const Color(0xFF2D3748),
    );
    // Hat brim
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(cx, r * 1.05),
        width: r * 1.6,
        height: r * 0.2,
      ),
      Paint()..color = IronMonColors.error,
    );

    // Body (back view - wider)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, s.height * 0.55),
          width: r * 1.8,
          height: r * 1.5,
        ),
        Radius.circular(r * 0.2),
      ),
      Paint()..color = IronMonColors.primary,
    );

    // Backpack
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, s.height * 0.52),
          width: r * 1.2,
          height: r * 1.1,
        ),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF1F3552),
    );
    // Backpack pocket
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, s.height * 0.55),
          width: r * 0.6,
          height: r * 0.4,
        ),
        Radius.circular(r * 0.1),
      ),
      Paint()..color = IronMonColors.primary.withValues(alpha: 0.5),
    );

    // Arms (reaching out slightly)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - r * 1.1, s.height * 0.48),
          width: r * 0.5,
          height: r * 0.9,
        ),
        Radius.circular(r * 0.2),
      ),
      Paint()..color = IronMonColors.primary,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + r * 1.1, s.height * 0.48),
          width: r * 0.5,
          height: r * 0.9,
        ),
        Radius.circular(r * 0.2),
      ),
      Paint()..color = IronMonColors.primary,
    );

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx - r * 0.35, s.height * 0.82),
          width: r * 0.55,
          height: r * 0.7,
        ),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF2D3748),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx + r * 0.35, s.height * 0.82),
          width: r * 0.55,
          height: r * 0.7,
        ),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF2D3748),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Enemy trainer sprite for the intro screen.
/// Drawn facing right (toward the player).
class TrainerSprite extends StatelessWidget {
  const TrainerSprite({
    required this.typeColor,
    this.size = 90,
    super.key,
  });

  final Color typeColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _TrainerPainter(typeColor: typeColor),
      ),
    );
  }
}

class _TrainerPainter extends CustomPainter {
  const _TrainerPainter({required this.typeColor});

  final Color typeColor;

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final r = s.width * 0.3;
    final skin = const Color(0xFFE8C4A0);

    // Head
    canvas.drawCircle(Offset(cx, r * 0.8), r * 0.6, Paint()..color = skin);

    // Spiky hair
    final hair = Path()
      ..moveTo(cx - r * 0.6, r * 0.4)
      ..lineTo(cx - r * 0.3, r * -0.2)
      ..lineTo(cx, r * 0.3)
      ..lineTo(cx + r * 0.2, r * -0.3)
      ..lineTo(cx + r * 0.6, r * 0.2)
      ..lineTo(cx + r * 0.7, r * 0.6)
      ..close();
    canvas.drawPath(hair, Paint()..color = typeColor);

    // Eyes
    canvas.drawCircle(Offset(cx - r * 0.2, r * 0.7), r * 0.1, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx + r * 0.15, r * 0.7), r * 0.1, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx - r * 0.2, r * 0.7), r * 0.05, Paint()..color = const Color(0xFF1A1A2E));
    canvas.drawCircle(Offset(cx + r * 0.15, r * 0.7), r * 0.05, Paint()..color = const Color(0xFF1A1A2E));

    // Confident grin
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, r * 0.95), width: r * 0.5, height: r * 0.2),
      0.1, 2.9, false,
      Paint()..color = const Color(0xFF1A1A2E)..style = PaintingStyle.stroke..strokeWidth = 1.5,
    );

    // Body (coat)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, s.height * 0.52), width: r * 2.0, height: r * 1.6),
        Radius.circular(r * 0.2),
      ),
      Paint()..color = typeColor,
    );

    // Coat detail (V collar)
    final collar = Path()
      ..moveTo(cx - r * 0.5, s.height * 0.35)
      ..lineTo(cx, s.height * 0.55)
      ..lineTo(cx + r * 0.5, s.height * 0.35);
    canvas.drawPath(
      collar,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    // Belt
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, s.height * 0.63), width: r * 2.0, height: r * 0.15),
      Paint()..color = const Color(0xFF2D3748),
    );
    // Belt buckle
    canvas.drawCircle(
      Offset(cx, s.height * 0.63),
      r * 0.1,
      Paint()..color = const Color(0xFFFFD93D),
    );

    // Arm pointing forward (right arm extended)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx + r * 0.6, s.height * 0.38, r * 1.0, r * 0.35),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = skin,
    );

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx - r * 0.4, s.height * 0.82), width: r * 0.6, height: r * 0.7),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF2D3748),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx + r * 0.4, s.height * 0.82), width: r * 0.6, height: r * 0.7),
        Radius.circular(r * 0.15),
      ),
      Paint()..color = const Color(0xFF2D3748),
    );
  }

  @override
  bool shouldRepaint(covariant _TrainerPainter old) => typeColor != old.typeColor;
}
