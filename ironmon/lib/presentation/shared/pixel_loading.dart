import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Pixel-style loading spinner with optional message.
///
/// Features rotating pixel blocks animation with primary color.
class PixelLoading extends StatefulWidget {
  /// Creates a [PixelLoading].
  const PixelLoading({
    this.message,
    this.size = 48.0,
    super.key,
  });

  /// Optional message to display below the spinner.
  final String? message;

  /// Size of the spinner.
  final double size;

  @override
  State<PixelLoading> createState() => _PixelLoadingState();
}

class _PixelLoadingState extends State<PixelLoading>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    // Create staggered animations for each block
    _animations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            index * 0.2 + 0.6,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Build 4 pixel blocks in a square pattern
              for (int i = 0; i < 4; i++)
                AnimatedBuilder(
                  animation: _animations[i],
                  builder: (context, child) {
                    final progress = _animations[i].value;
                    final offset = _calculateOffset(i, progress);
                    final scale = 0.5 + (progress * 0.5);

                    return Transform.translate(
                      offset: offset,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          width: widget.size * 0.25,
                          height: widget.size * 0.25,
                          decoration: BoxDecoration(
                            color: IronMonColors.primary,
                            boxShadow: [
                              BoxShadow(
                                color: IronMonColors.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: const TextStyle(
              color: IronMonColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Offset _calculateOffset(int index, double progress) {
    final radius = widget.size * 0.2;
    final angle =
        (progress * 2 * math.pi) + (index * math.pi / 2);

    return Offset(
      radius * math.cos(angle),
      radius * math.sin(angle),
    );
  }
}
