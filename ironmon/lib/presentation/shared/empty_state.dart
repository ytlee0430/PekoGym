import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';

/// Empty state widget with customizable content and optional action.
///
/// Provides a centered layout with icon, title, subtitle, and CTA button.
class EmptyState extends StatelessWidget {
  /// Creates an [EmptyState].
  const EmptyState({
    required this.title,
    this.icon,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.backgroundColor,
    super.key,
  });

  /// Title text displayed prominently.
  final String title;
  
  /// Optional icon or illustration.
  final Widget? icon;
  
  /// Optional subtitle text.
  final String? subtitle;
  
  /// Optional action button label.
  final String? actionLabel;
  
  /// Optional callback for action button.
  final VoidCallback? onAction;
  
  /// Optional background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundColor ?? IronMonColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(height: 24),
          ],
          
          PixelText.h2(
            title,
            textAlign: TextAlign.center,
            color: IronMonColors.onSurface,
          ),
          
          if (subtitle != null) ...[
            const SizedBox(height: 12),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: IronMonColors.onSurfaceVariant,
              ),
            ),
          ],
          
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: IronMonColors.primary,
                foregroundColor: IronMonColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates an empty state for no training history.
  factory EmptyState.noTrainingHistory({VoidCallback? onStartBattle}) {
    return EmptyState(
      icon: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: IronMonColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(60),
        ),
        child: Icon(
          Icons.fitness_center,
          size: 60,
          color: IronMonColors.primary,
        ),
      ),
      title: 'Start your first battle!',
      subtitle: 'Complete your first workout to see your training history here.',
      actionLabel: 'Start Battle',
      onAction: onStartBattle,
    );
  }

  /// Creates an empty state for no moves unlocked.
  factory EmptyState.noMovesUnlocked() {
    return EmptyState(
      icon: Icon(
        Icons.lock,
        size: 80,
        color: IronMonColors.onSurfaceVariant,
      ),
      title: 'No Moves Yet',
      subtitle: 'Keep training to unlock new moves and abilities!',
    );
  }

  /// Creates an empty state for no data available.
  factory EmptyState.noData({
    required String title,
    String? subtitle,
  }) {
    return EmptyState(
      icon: Icon(
        Icons.inbox_outlined,
        size: 80,
        color: IronMonColors.onSurfaceVariant,
      ),
      title: title,
      subtitle: subtitle,
    );
  }

  /// Creates an empty state for network error.
  factory EmptyState.networkError({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Icon(
        Icons.wifi_off,
        size: 80,
        color: IronMonColors.error,
      ),
      title: 'Connection Error',
      subtitle: 'Unable to load data. Please check your connection and try again.',
      actionLabel: 'Retry',
      onAction: onRetry,
      backgroundColor: IronMonColors.error.withValues(alpha: 0.05),
    );
  }
}
