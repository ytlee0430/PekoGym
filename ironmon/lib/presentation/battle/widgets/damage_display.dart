import 'package:flutter/material.dart';
import 'package:ironmon/domain/battle/models/damage_result.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

/// Displays animated damage numbers floating up
/// and fading out.
/// Wrapped in [RepaintBoundary] to isolate repaints.
class DamageDisplay extends StatefulWidget {
  /// Creates a [DamageDisplay].
  const DamageDisplay({
    required this.damageResult,
    super.key,
  });

  /// The damage result to display.
  final DamageResult? damageResult;

  @override
  State<DamageDisplay> createState() =>
      _DamageDisplayState();
}

class _DamageDisplayState extends State<DamageDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  DamageResult? _lastResult;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didUpdateWidget(DamageDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.damageResult != null &&
        widget.damageResult !=
            oldWidget.damageResult) {
      _lastResult = widget.damageResult;
      
      // Set scale based on damage type
      final scale = switch (widget.damageResult!.effectiveness) {
        Effectiveness.superEffective => 1.2,
        Effectiveness.notVeryEffective => 0.8,
        Effectiveness.neutral when widget.damageResult!.isCritical => 1.3,
        Effectiveness.neutral => 1.0,
      };
      
      _scaleAnimation = Tween<double>(
        begin: scale,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
        ),
      );
      
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
  Color _damageColor(Effectiveness eff) {
    return switch (eff) {
      Effectiveness.superEffective =>
        IronMonColors.damageSuperEffective,
      Effectiveness.notVeryEffective =>
        IronMonColors.damageNotEffective,
      Effectiveness.neutral =>
        IronMonColors.damageNormal,
    };
  }

  String _getEffectivenessText() {
    if (_lastResult?.isCritical == true) {
      return 'Critical hit!';
    }
    switch (_lastResult?.effectiveness) {
      case Effectiveness.superEffective:
        return 'Super effective!';
      case Effectiveness.notVeryEffective:
        return 'Not very effective';
      case Effectiveness.neutral:
      default:
        return 'Normal damage';
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectivenessText = _getEffectivenessText();
    
    return RepaintBoundary(
      child: SizedBox(
        height: 80,
        child: _lastResult == null
            ? const SizedBox.shrink()
            : IgnorePointer(
                child: Semantics(
                  liveRegion: true,
                  label: 'Dealt ${_lastResult!.finalDamage} damage, $effectivenessText',
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Transform.scale(
                            scale: _scaleAnimation.value,
                            child: PixelText.display(
                              '-${_lastResult!.finalDamage}',
                              color: _damageColor(
                                _lastResult!.effectiveness,
                              ),
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black.withAlpha(128),
                                  offset: const Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
