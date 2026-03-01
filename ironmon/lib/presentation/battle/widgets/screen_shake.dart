import 'package:flutter/material.dart';

/// Screen shake animation wrapper for battle impacts.
///
/// Used for critical hits and super effective attacks.
/// Implements shake with Transform.translate and AnimationController.
abstract class ScreenShakeState extends State<ScreenShake> {
  void shake();
}

class ScreenShake extends StatefulWidget {
  /// Creates a [ScreenShake] widget.
  const ScreenShake({
    required this.child,
    super.key,
  });

  /// The child widget to shake.
  final Widget child;

  @override
  State<ScreenShake> createState() => _ScreenShakeState();
  
  /// Expose the shake method through a static method
  static void shake(GlobalKey<ScreenShakeState> key) {
    key.currentState?.shake();
  }
}

class _ScreenShakeState extends ScreenShakeState
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _offsetAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(-10, 0))
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 0.25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-10, 0), end: const Offset(10, 0))
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(10, 0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 0.25,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Triggers the screen shake animation.
  void shake() {
    if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
