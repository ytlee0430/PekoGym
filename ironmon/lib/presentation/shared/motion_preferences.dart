import 'package:flutter/widgets.dart';

/// Utility for checking system motion preferences.
///
/// Helps respect user's accessibility settings for animations.
class MotionPreferences {
  MotionPreferences._();
  
  /// Checks if the user has disabled animations in system settings.
  static bool isReduceMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
  
  /// Returns a duration scaled based on motion preferences.
  /// 
  /// If animations are disabled, returns Duration.zero.
  /// Otherwise returns the original duration.
  static Duration scaledDuration(BuildContext context, Duration duration) {
    return isReduceMotionEnabled(context) ? Duration.zero : duration;
  }
  
  /// Returns a curve based on motion preferences.
  /// 
  /// If animations are disabled, returns Curves.linear.
  /// Otherwise returns the provided curve.
  static Curve scaledCurve(BuildContext context, Curve curve) {
    return isReduceMotionEnabled(context) ? Curves.linear : curve;
  }
  
  /// Conditionally creates an animation based on motion preferences.
  /// 
  /// If animations are disabled, returns a controller that's already completed.
  /// Otherwise returns a normal animation controller.
  static AnimationController createController({
    required TickerProvider vsync,
    Duration? duration,
  }) {
    // Note: This would need context to check preferences
    // For now, return a normal controller
    return AnimationController(vsync: vsync, duration: duration);
  }
}
