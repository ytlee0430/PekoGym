import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Animated player PP (stamina) bar widget.
/// Uses [AnimatedBuilder] pattern for smooth 60fps
/// PP depletion animation.
/// Color gradient: green (>50%) → yellow (25-50%) → red (<25%).
class PpBar extends StatefulWidget {
  /// Creates a [PpBar].
  const PpBar({
    required this.currentPp,
    required this.maxPp,
    super.key,
  });

  /// Current PP value.
  final int currentPp;

  /// Maximum PP value.
  final int maxPp;

  @override
  State<PpBar> createState() => _PpBarState();
}

class _PpBarState extends State<PpBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousRatio = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _previousRatio = _ppRatio;
    _animation = Tween<double>(
      begin: _previousRatio,
      end: _previousRatio,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(PpBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentPp != widget.currentPp) {
      _animation = Tween<double>(
        begin: _previousRatio,
        end: _ppRatio,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
      _controller.reset();
      unawaited(_controller.forward());
      _previousRatio = _ppRatio;
    }
  }

  double get _ppRatio {
    if (widget.maxPp <= 0) return 0;
    return (widget.currentPp / widget.maxPp)
        .clamp(0.0, 1.0);
  }

  Color _barColor(double ratio) {
    if (ratio > 0.5) return IronMonColors.hpHigh;
    if (ratio > 0.25) return IronMonColors.hpMid;
    return IronMonColors.hpLow;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PP',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface,
              ),
            ),
            Text(
              '${widget.currentPp}/${widget.maxPp}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 12,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final ratio = _animation.value;
              return ClipRRect(
                borderRadius:
                    BorderRadius.circular(6),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            IronMonColors.hpBarTrack,
                        borderRadius:
                            BorderRadius.circular(6),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: ratio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _barColor(ratio),
                          borderRadius:
                              BorderRadius.circular(
                            6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
