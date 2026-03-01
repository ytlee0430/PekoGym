import 'package:flutter/material.dart';

/// Animated phase transition for boss changes.
///
/// Fades out old boss (300ms) then slides in new boss from right (300ms).
class PhaseTransition extends StatefulWidget {
  /// Creates a [PhaseTransition] widget.
  const PhaseTransition({
    required this.child,
    required this.phaseKey,
    super.key,
  });

  /// The current phase content to display.
  final Widget child;
  
  /// Key to identify phase changes and trigger animation.
  final Key phaseKey;

  @override
  State<PhaseTransition> createState() => _PhaseTransitionState();
}

class _PhaseTransitionState extends State<PhaseTransition>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  
  Key? _lastPhaseKey;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(PhaseTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.phaseKey != _lastPhaseKey) {
      _startTransition();
      _lastPhaseKey = widget.phaseKey;
    }
  }

  void _startTransition() async {
    // Fade out old boss
    await _fadeController.forward();
    
    // Reset animations
    _fadeController.reset();
    _slideController.reset();
    
    // Update content and slide in new boss
    setState(() {});
    await _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_fadeController.status == AnimationStatus.completed) {
      // During transition - show sliding animation
      return SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: AlwaysStoppedAnimation(1.0),
          child: widget.child,
        ),
      );
    }
    
    // Normal state - show fade animation
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
