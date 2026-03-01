import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/battle/battle_phase.dart';
import 'package:ironmon/presentation/battle/widgets/animated_exp_bar.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';
import 'package:ironmon/providers/battle_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Battle result screen showing victory/defeat with animated EXP bar
/// and stat cards in a rewarding, screenshot-worthy layout.
class BattleResultScreen extends ConsumerStatefulWidget {
  /// Creates a [BattleResultScreen].
  const BattleResultScreen({super.key});

  @override
  ConsumerState<BattleResultScreen> createState() => _BattleResultScreenState();
}

class _BattleResultScreenState extends ConsumerState<BattleResultScreen>
    with TickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(battleStateNotifierProvider);
    final phase = state.phase;

    if (phase is! BattleResult) {
      return Scaffold(
        backgroundColor: IronMonColors.surface,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No battle result'),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Return Home'),
              ),
            ],
          ),
        ),
      );
    }

    final outcome = phase.outcome;
    final isVictory = outcome.isVictory;
    
    // Get user profile for EXP calculations
    final profile = ref.watch(userProfileProvider).value;
    final previousExp = profile?.experiencePoints ?? 0;
    final currentExp = previousExp + outcome.earnedExp;
    final expToNextLevel = 250; // Simplified for now
    final leveledUp = outcome.levelsGained > 0;

    return Scaffold(
      backgroundColor: IronMonColors.surface,
      appBar: AppBar(
        backgroundColor: IronMonColors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Victory/Defeat banner
              _buildOutcomeBanner(isVictory, outcome),
              
              const SizedBox(height: 24),
              
              // Animated EXP bar
              AnimatedExpBar(
                previousExp: previousExp,
                currentExp: currentExp,
                expGained: outcome.earnedExp,
                expToNextLevel: expToNextLevel,
                leveledUp: leveledUp,
              ),
              
              const SizedBox(height: 32),
              
              // Stat cards grid
              _buildStatCards(outcome, state),
              
              const SizedBox(height: 32),
              
              // Return Home button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => context.go('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IronMonColors.primary,
                    foregroundColor: IronMonColors.onPrimary,
                  ),
                  child: const Text('Return Home'),
                ),
              ),
              
              // Bottom padding for iOS Home Indicator
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutcomeBanner(bool isVictory, dynamic outcome) {
    if (isVictory) {
      return AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: IronMonColors.primary.withValues(alpha: _glowAnimation.value * 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: PixelText.h1(
              'VICTORY!',
              textAlign: TextAlign.center,
              color: IronMonColors.primary,
              shadows: const [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: IronMonColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            PixelText.h1(
              'DEFEAT',
              textAlign: TextAlign.center,
              color: IronMonColors.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'You still earned 60% EXP!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: IronMonColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStatCards(dynamic outcome, dynamic state) {
    // Calculate time elapsed (simplified)
    final timeElapsed = '24:35'; // Placeholder
    
    return Column(
      children: [
        // Title
        PixelText.h2(
          'Training Stats',
          color: IronMonColors.onSurface,
        ),
        const SizedBox(height: 16),
        
        // 2x2 grid of stat cards
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _StatCard(
              icon: Icons.fitness_center,
              label: 'Total Volume',
              value: '${outcome.totalVolume.toStringAsFixed(0)} kg',
            ),
            _StatCard(
              icon: Icons.flash_on,
              label: 'Total Damage',
              value: '${outcome.totalDamageDealt}',
            ),
            _StatCard(
              icon: Icons.repeat,
              label: 'Sets Completed',
              value: '${outcome.totalSets}',
            ),
            _StatCard(
              icon: Icons.timer,
              label: 'Time Elapsed',
              value: timeElapsed,
            ),
            _StatCard(
              icon: Icons.monetization_on,
              label: 'Coins Earned',
              value: '+${outcome.coinsEarned}',
            ),
          ],
        ),
      ],
    );
  }
}

/// Stat card displaying a single training metric.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: IronMonColors.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: IronMonColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: IronMonColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: IronMonColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
