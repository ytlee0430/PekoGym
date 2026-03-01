import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

/// Animated EXP bar that fills from previous EXP to new EXP.
///
/// Shows EXP gain amount and handles level up animations.
class AnimatedExpBar extends StatefulWidget {
  /// Creates an [AnimatedExpBar].
  const AnimatedExpBar({
    required this.previousExp,
    required this.currentExp,
    required this.expGained,
    required this.expToNextLevel,
    required this.leveledUp,
    this.onLevelUpAnimationComplete,
    super.key,
  });

  /// Previous EXP amount.
  final int previousExp;
  
  /// Current EXP amount.
  final int currentExp;
  
  /// EXP gained in this session.
  final int expGained;
  
  /// EXP required for next level.
  final int expToNextLevel;
  
  /// Whether the player leveled up.
  final bool leveledUp;
  
  /// Callback when level up animation completes.
  final VoidCallback? onLevelUpAnimationComplete;

  @override
  State<AnimatedExpBar> createState() => _AnimatedExpBarState();
}

class _AnimatedExpBarState extends State<AnimatedExpBar>
    with TickerProviderStateMixin {
  late final AnimationController _fillController;
  late final AnimationController _levelUpController;
  late final Animation<double> _fillAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  
  bool _showLevelUpBanner = false;

  @override
  void initState() {
    super.initState();
    
    _fillController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _levelUpController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fillAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fillController,
      curve: Curves.easeInOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _levelUpController,
      curve: Curves.bounceOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _levelUpController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _fillController.forward().then((_) {
      if (widget.leveledUp) {
        setState(() => _showLevelUpBanner = true);
        _levelUpController.forward().then((_) {
          widget.onLevelUpAnimationComplete?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _fillController.dispose();
    _levelUpController.dispose();
    super.dispose();
  }

  double _getPreviousPercentage() {
    if (widget.expToNextLevel == 0) return 0.0;
    return (widget.previousExp % widget.expToNextLevel) / widget.expToNextLevel;
  }

  double _getCurrentPercentage() {
    if (widget.expToNextLevel == 0) return 0.0;
    return (widget.currentExp % widget.expToNextLevel) / widget.expToNextLevel;
  }

  @override
  Widget build(BuildContext context) {
    final previousPercentage = _getPreviousPercentage();
    final currentPercentage = _getCurrentPercentage();
    
    return Column(
      children: [
        // Level up banner
        if (_showLevelUpBanner)
          SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: IronMonColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: IronMonColors.primary,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: IronMonColors.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    PixelText.h1(
                      'LEVEL UP!',
                      color: IronMonColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        const SizedBox(height: 16),
        
        // EXP gain text
        AnimatedBuilder(
          animation: _fillAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: 1.0 - _fillAnimation.value,
              child: Text(
                'EXP +${widget.expGained}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: IronMonColors.expBar,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 8),
        
        // EXP bar container
        Container(
          height: 24,
          decoration: BoxDecoration(
            color: IronMonColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Background fill (previous EXP)
              FractionallySizedBox(
                widthFactor: previousPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: IronMonColors.expBar.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              // Animated fill (new EXP)
              AnimatedBuilder(
                animation: _fillAnimation,
                builder: (context, child) {
                  final targetWidth = currentPercentage - previousPercentage;
                  final currentWidth = previousPercentage + (targetWidth * _fillAnimation.value);
                  
                  return FractionallySizedBox(
                    widthFactor: currentWidth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: IronMonColors.expBar,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 4),
        
        // EXP text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.currentExp} EXP',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: IronMonColors.onSurfaceVariant,
              ),
            ),
            Text(
              'Next: ${widget.expToNextLevel}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: IronMonColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
