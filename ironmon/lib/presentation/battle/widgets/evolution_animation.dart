import 'package:flutter/material.dart';
import 'package:ironmon/domain/training/pr_detector.dart';

/// Evolution animation overlay shown when a PR
/// is detected during battle.
/// Uses RepaintBoundary to avoid parent repaints
/// (NFR6).
class EvolutionAnimation extends StatefulWidget {
  /// Creates an [EvolutionAnimation].
  const EvolutionAnimation({
    required this.prResult,
    required this.onComplete,
    super.key,
  });

  /// The PR result to display.
  final PRResult prResult;

  /// Called when the animation completes.
  final VoidCallback onComplete;

  @override
  State<EvolutionAnimation> createState() =>
      _EvolutionAnimationState();
}

class _EvolutionAnimationState
    extends State<EvolutionAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _flashAnim;
  late final Animation<double> _textAnim;
  late final Animation<double> _valueAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2500,
      ),
    );

    // Flash: 0.0→1.0 in first 30%, then fade
    _flashAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 40,
      ),
    ]).animate(_controller);

    // Text appears at 30%
    _textAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.3,
        0.6,
        curve: Curves.easeOut,
      ),
    );

    // Value transition at 50%
    _valueAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.5,
        0.8,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward().then(
          (_) => widget.onComplete(),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pr = widget.prResult;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              // White flash overlay
              if (_flashAnim.value > 0)
                Positioned.fill(
                  child: ColoredBox(
                    color: Colors.white
                        .withValues(
                      alpha: _flashAnim.value * 0.8,
                    ),
                  ),
                ),

              // PR text
              Center(
                child: Opacity(
                  opacity: _textAnim.value,
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      const Text(
                        'PR BREAKTHROUGH!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight:
                              FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Opacity(
                        opacity:
                            _valueAnim.value,
                        child: Text(
                          '${pr.oldFiveRm.toStringAsFixed(1)} kg'
                          ' → '
                          '${pr.newFiveRm.toStringAsFixed(1)} kg',
                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Opacity(
                        opacity:
                            _valueAnim.value,
                        child: Text(
                          pr.muscleType
                              .displayName,
                          style:
                              const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
