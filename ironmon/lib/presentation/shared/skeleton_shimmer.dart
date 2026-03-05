import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Skeleton shimmer widget for loading states.
///
/// Provides configurable shimmer placeholders with Material 3 style.
class SkeletonShimmer extends StatefulWidget {
  /// Creates a [SkeletonShimmer].
  const SkeletonShimmer({
    required this.child,
    this.baseColor,
    this.highlightColor,
    super.key,
  });

  /// The child widget to apply shimmer effect to.
  final Widget child;

  /// Base color of the skeleton.
  final Color? baseColor;

  /// Highlight color of the shimmer effect.
  final Color? highlightColor;

  /// Creates a card-shaped skeleton placeholder.
  factory SkeletonShimmer.card({
    double width = double.infinity,
    double height = 120,
    double borderRadius = 12,
  }) {
    return SkeletonShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: IronMonColors.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Creates a list tile-shaped skeleton placeholder.
  factory SkeletonShimmer.listTile({
    double width = double.infinity,
    double height = 72,
  }) {
    return SkeletonShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: IronMonColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Creates a bar-shaped skeleton placeholder.
  factory SkeletonShimmer.bar({
    double width = double.infinity,
    double height = 16,
    double borderRadius = 8,
  }) {
    return SkeletonShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: IronMonColors.surfaceVariant,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Creates a circular skeleton placeholder.
  factory SkeletonShimmer.circle({
    double size = 48,
  }) {
    return SkeletonShimmer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: IronMonColors.surfaceVariant,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor =
        widget.baseColor ?? IronMonColors.surfaceVariant;
    final highlightColor = widget.highlightColor ??
        IronMonColors.onSurface.withValues(alpha: 0.1);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0.0),
              end: Alignment(1.0 + _animation.value, 0.0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// A collection of skeleton widgets for common loading patterns.
class SkeletonWidgets {
  /// Creates a skeleton layout for a stat card.
  static Widget statCard() {
    return Column(
      children: [
        SkeletonShimmer.circle(size: 32),
        const SizedBox(height: 8),
        SkeletonShimmer.bar(width: 80, height: 12),
        const SizedBox(height: 4),
        SkeletonShimmer.bar(width: 60, height: 16),
      ],
    );
  }

  /// Creates a skeleton layout for a profile header.
  static Widget profileHeader() {
    return Row(
      children: [
        SkeletonShimmer.circle(size: 64),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonShimmer.bar(width: 120, height: 20),
              const SizedBox(height: 8),
              SkeletonShimmer.bar(width: 80, height: 16),
              const SizedBox(height: 4),
              SkeletonShimmer.bar(height: 14),
            ],
          ),
        ),
      ],
    );
  }

  /// Creates a skeleton layout for a move list item.
  static Widget moveListItem() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SkeletonShimmer.circle(size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonShimmer.bar(width: 100, height: 18),
                const SizedBox(height: 4),
                SkeletonShimmer.bar(height: 14),
              ],
            ),
          ),
          SkeletonShimmer.circle(size: 24),
        ],
      ),
    );
  }
}
