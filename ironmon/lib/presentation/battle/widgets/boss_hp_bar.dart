import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/motion_preferences.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

/// Animated boss HP bar widget.
/// Uses [AnimatedBuilder] pattern for smooth 60fps
/// HP depletion animation.
class BossHpBar extends StatefulWidget {
  /// Creates a [BossHpBar].
  const BossHpBar({
    required this.currentHp,
    required this.maxHp,
    required this.bossName,
    super.key,
  });

  /// Current HP value.
  final int currentHp;

  /// Maximum HP value.
  final int maxHp;

  /// Boss display name.
  final String bossName;

  @override
  State<BossHpBar> createState() => _BossHpBarState();
}

class _BossHpBarState extends State<BossHpBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousRatio = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _previousRatio = _hpRatio;
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
  void didUpdateWidget(BossHpBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentHp != widget.currentHp) {
      _animation = Tween<double>(
        begin: _previousRatio,
        end: _hpRatio,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
      _controller
        ..reset()
        ..forward();
      _previousRatio = _hpRatio;
    }
  }

  double get _hpRatio {
    if (widget.maxHp <= 0) return 0;
    return (widget.currentHp / widget.maxHp)
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
    final percentage = (_hpRatio * 100).round();
    
    return Semantics(
      label: 'Boss ${widget.bossName}, HP ${widget.currentHp} out of ${widget.maxHp}, $percentage percent',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              PixelText.h2(
                widget.bossName,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              Text(
                '${widget.currentHp}/${widget.maxHp}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 16,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final ratio = MotionPreferences.isReduceMotionEnabled(context) 
                    ? _hpRatio 
                    : _animation.value;
                return ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: IronMonColors.hpBarTrack,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: ratio,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _barColor(ratio),
                            borderRadius:
                                BorderRadius.circular(
                              8,
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
      ),
    );
  }
}
