import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/onboarding/widgets/five_rm_input_card.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Onboarding screen with card-based flow for profile creation.
/// Uses PageView for step-by-step navigation with game-like feel.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  
  int _currentPage = 0;
  bool _isBeginnerMode = false;
  bool _isSaving = false;
  
  // 5RM values
  final Map<MuscleType, double> _fiveRmValues = {};
  int _weeklyFrequency = 3;

  // Total pages depends on mode
  int get _totalPages => _isBeginnerMode ? 4 : 8;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);
    
    // Initialize 5RM values
    for (final type in MuscleType.values) {
      _fiveRmValues[type] = 0.0;
    }
    
    // Start fade-in animation
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _onSubmit() async {
    setState(() => _isSaving = true);

    final profile = UserProfile(
      chestFiveRm: _fiveRmValues[MuscleType.chest] ?? 0.0,
      backFiveRm: _fiveRmValues[MuscleType.back] ?? 0.0,
      legsFiveRm: _fiveRmValues[MuscleType.legs] ?? 0.0,
      shouldersFiveRm: _fiveRmValues[MuscleType.shoulders] ?? 0.0,
      coreFiveRm: _fiveRmValues[MuscleType.core] ?? 0.0,
      weeklyFrequency: _weeklyFrequency,
      isBeginnerMode: _isBeginnerMode,
      calibrationSessionsCompleted: 0,
      calibrationTargetSessions: 5,
      level: 1,
      exp: 0,
      maxPp: 100,
    );

    try {
      await ref
          .read(userProfileProvider.notifier)
          .saveProfile(profile);

      if (!mounted) return;

      // Show celebration
      _showCelebration();
    } on Exception catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save profile. Try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showCelebration() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return CelebrationScreen(
            onComplete: () => context.go('/'),
          );
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Widget _buildPage(int index) {
    if (_isBeginnerMode) {
      return switch (index) {
        0 => _buildWelcomePage(),
        1 => _buildModeSelectPage(),
        2 => _buildFrequencyPage(),
        3 => _buildConfirmPage(),
        _ => throw ArgumentError('Invalid page index: $index'),
      };
    } else {
      return switch (index) {
        0 => _buildWelcomePage(),
        1 => _buildModeSelectPage(),
        2 => _buildFiveRmPage(MuscleType.chest),
        3 => _buildFiveRmPage(MuscleType.back),
        4 => _buildFiveRmPage(MuscleType.legs),
        5 => _buildFiveRmPage(MuscleType.shoulders),
        6 => _buildFrequencyPage(),
        7 => _buildConfirmPage(),
        _ => throw ArgumentError('Invalid page index: $index'),
      };
    }
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Character sprite placeholder
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: IronMonColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 60,
              color: IronMonColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          
          PixelText.h1(
            'Welcome to IronMon!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          Text(
            'Training is Battle,\nProgress is Upgrade',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: IronMonColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),
          
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
            child: const Text('Begin Your Journey'),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelectPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixelText.h2(
            'Choose Your Path',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          Card(
            color: _isBeginnerMode 
                ? IronMonColors.primaryContainer 
                : IronMonColors.surfaceVariant,
            child: InkWell(
              onTap: () {
                setState(() => _isBeginnerMode = true);
                // Set default values for beginner mode
                for (final type in MuscleType.values) {
                  _fiveRmValues[type] = 20.0;
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 48,
                      color: _isBeginnerMode 
                          ? IronMonColors.onPrimaryContainer 
                          : IronMonColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Beginner Mode',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: _isBeginnerMode 
                            ? IronMonColors.onPrimaryContainer 
                            : IronMonColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start with light weights\nSystem auto-calibrates your 5RM',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: IronMonColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Card(
            color: !_isBeginnerMode 
                ? IronMonColors.primaryContainer 
                : IronMonColors.surfaceVariant,
            child: InkWell(
              onTap: () => setState(() => _isBeginnerMode = false),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 48,
                      color: !_isBeginnerMode 
                          ? IronMonColors.onPrimaryContainer 
                          : IronMonColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Experienced Mode',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: !_isBeginnerMode 
                            ? IronMonColors.onPrimaryContainer 
                            : IronMonColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your current 5RM weights\nStart with accurate progression',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: IronMonColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiveRmPage(MuscleType muscleType) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: FiveRmInputCard(
        muscleType: muscleType,
        value: _fiveRmValues[muscleType] ?? 0.0,
        onChanged: (value) => _fiveRmValues[muscleType] = value,
      ),
    );
  }

  Widget _buildFrequencyPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixelText.h2(
            'Training Frequency',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          Text(
            'How many days per week will you train?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: IronMonColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          
          // Frequency selector
          Column(
            children: List.generate(7, (index) {
              final days = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  color: _weeklyFrequency == days
                      ? IronMonColors.primaryContainer
                      : IronMonColors.surfaceVariant,
                  child: ListTile(
                    title: Text(
                      '$days day${days > 1 ? 's' : ''} per week',
                      style: TextStyle(
                        color: _weeklyFrequency == days
                            ? IronMonColors.onPrimaryContainer
                            : IronMonColors.onSurface,
                      ),
                    ),
                    trailing: _weeklyFrequency == days
                        ? const Icon(Icons.check, color: IronMonColors.primary)
                        : null,
                    onTap: () => setState(() => _weeklyFrequency = days),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixelText.h2(
            'Ready to Start!',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          if (!_isBeginnerMode) ...[
            Text(
              'Your 5RM Values:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...MuscleType.values.map((type) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(type.displayName),
                  Text('${_fiveRmValues[type]?.toStringAsFixed(1) ?? '0.0'} kg'),
                ],
              ),
            )),
            const SizedBox(height: 24),
          ],
          
          Text(
            'Training: $_weeklyFrequency days/week',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Mode: ${_isBeginnerMode ? 'Beginner' : 'Experienced'}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 48),
          
          ElevatedButton(
            onPressed: _isSaving ? null : _onSubmit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
              backgroundColor: IronMonColors.primary,
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IronMonColors.surface,
      appBar: AppBar(
        backgroundColor: IronMonColors.surface,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousPage,
              )
            : null,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentPage = index),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _totalPages,
          itemBuilder: (context, index) => _buildPage(index),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _totalPages,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? IronMonColors.primary
                    : IronMonColors.onSurfaceVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Celebration screen shown after profile creation.
class CelebrationScreen extends StatefulWidget {
  const CelebrationScreen({
    required this.onComplete,
    super.key,
  });

  final VoidCallback onComplete;

  @override
  State<CelebrationScreen> createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _controller.forward();
    
    // Auto-navigate after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IronMonColors.surface,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PixelText.h1(
                'Profile Created!',
                textAlign: TextAlign.center,
                color: IronMonColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Your journey begins now...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: IronMonColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
