import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/training/exercise_weight_estimator.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/onboarding/widgets/five_rm_input_card.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';
import 'package:ironmon/presentation/shared/pixel_text.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Onboarding screen with card-based flow for profile creation.
/// Uses PageView for step-by-step navigation with game-like feel.
///
/// New flow:
///   0: Welcome
///   1: Gender + Body Weight
///   2: Mode Select (Beginner / Experienced)
///   Beginner path: 3=Frequency, 4=Confirm
///   Experienced path: 3-6=Standard lifts (with recommended weights),
///                     7=AdjustAll, 8=Frequency, 9=Confirm
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

  // Body info (page 1)
  String _gender = 'male';
  double _bodyWeightKg = 70.0;
  late TextEditingController _weightTextController;

  // Recommended weights (calculated from gender + body weight)
  double _recommendedBench = 0.0;
  double _recommendedRow = 0.0;
  double _recommendedSquat = 0.0;
  double _recommendedOhp = 0.0;

  // 4 standard compound lift inputs (experienced mode pages 3-6)
  double _benchPress = 0.0;
  double _barbellRow = 0.0;
  double _squat = 0.0;
  double _shoulderPress = 0.0;

  // Per-exercise 5RM map (populated when adjustment page opens)
  Map<String, double> _exerciseFiveRms = {};

  int _weeklyFrequency = 3;

  // Total pages depends on mode:
  // Beginner: Welcome, BodyInfo, Mode, Frequency, Confirm = 5
  // Experienced: Welcome, BodyInfo, Mode, Bench, Row, Squat, OHP,
  //              AdjustAll, Frequency, Confirm = 10
  int get _totalPages => _isBeginnerMode ? 5 : 10;

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

    _fadeController.forward();
    _weightTextController = TextEditingController(text: '70');
    _updateRecommendations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _weightTextController.dispose();
    super.dispose();
  }

  void _updateRecommendations() {
    final rec = ExerciseWeightEstimator.estimateFromBodyWeight(
      bodyWeightKg: _bodyWeightKg,
      gender: _gender,
    );
    setState(() {
      _recommendedBench = rec.benchPress;
      _recommendedRow = rec.barbellRow;
      _recommendedSquat = rec.squat;
      _recommendedOhp = rec.shoulderPress;
      // Pre-fill with recommended values if user hasn't entered anything
      if (_benchPress == 0.0) _benchPress = rec.benchPress;
      if (_barbellRow == 0.0) _barbellRow = rec.barbellRow;
      if (_squat == 0.0) _squat = rec.squat;
      if (_shoulderPress == 0.0) _shoulderPress = rec.shoulderPress;
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      // When leaving body info page, update recommendations
      if (_currentPage == 1) {
        _updateRecommendations();
      }
      // When entering AdjustAll page (index 7) in experienced mode,
      // populate estimates from the 4 inputs.
      if (!_isBeginnerMode && _currentPage == 6) {
        _exerciseFiveRms = ExerciseWeightEstimator.estimateAll(
          benchPress: _benchPress,
          barbellRow: _barbellRow,
          squat: _squat,
          shoulderPress: _shoulderPress,
        );
      }
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
      gender: _gender,
      bodyWeightKg: _bodyWeightKg,
      benchPressFiveRm: _isBeginnerMode ? 20.0 : _benchPress,
      deadliftFiveRm: _isBeginnerMode ? 20.0 : _barbellRow,
      squatFiveRm: _isBeginnerMode ? 20.0 : _squat,
      overheadPressFiveRm: _isBeginnerMode ? 20.0 : _shoulderPress,
      weeklyFrequency: _weeklyFrequency,
      isBeginnerMode: _isBeginnerMode,
      calibrationSessionsCompleted: 0,
      calibrationTargetSessions: 5,
      level: 1,
      experiencePoints: 0,
      maxPp: 100,
      exerciseFiveRms:
          _isBeginnerMode ? const {} : Map.unmodifiable(_exerciseFiveRms),
    );

    try {
      await ref.read(userProfileProvider.notifier).saveProfile(profile);

      if (!mounted) return;

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
        1 => _buildBodyInfoPage(),
        2 => _buildModeSelectPage(),
        3 => _buildFrequencyPage(),
        4 => _buildConfirmPage(),
        _ => throw ArgumentError('Invalid page index: $index'),
      };
    } else {
      return switch (index) {
        0 => _buildWelcomePage(),
        1 => _buildBodyInfoPage(),
        2 => _buildModeSelectPage(),
        3 => _buildStandardLiftPage(
            muscleType: MuscleType.chest,
            exerciseName: 'Barbell Bench Press',
            exerciseSubtitle: 'Lie flat, press barbell up from chest',
            exerciseIcon: Icons.airline_seat_flat,
            value: _benchPress,
            recommendedValue: _recommendedBench,
            onChanged: (v) => setState(() => _benchPress = v),
          ),
        4 => _buildStandardLiftPage(
            muscleType: MuscleType.back,
            exerciseName: 'Barbell Row',
            exerciseSubtitle: 'Bend over, pull barbell to torso',
            exerciseIcon: Icons.fitness_center,
            value: _barbellRow,
            recommendedValue: _recommendedRow,
            onChanged: (v) => setState(() => _barbellRow = v),
          ),
        5 => _buildStandardLiftPage(
            muscleType: MuscleType.legs,
            exerciseName: 'Barbell Squat',
            exerciseSubtitle: 'Bar on back, squat down and stand up',
            exerciseIcon: Icons.accessibility_new,
            value: _squat,
            recommendedValue: _recommendedSquat,
            onChanged: (v) => setState(() => _squat = v),
          ),
        6 => _buildStandardLiftPage(
            muscleType: MuscleType.shoulders,
            exerciseName: 'Overhead Press',
            exerciseSubtitle: 'Press barbell overhead from shoulders',
            exerciseIcon: Icons.arrow_upward,
            value: _shoulderPress,
            recommendedValue: _recommendedOhp,
            onChanged: (v) => setState(() => _shoulderPress = v),
          ),
        7 => _buildExerciseAdjustmentPage(),
        8 => _buildFrequencyPage(),
        9 => _buildConfirmPage(),
        _ => throw ArgumentError('Invalid page index: $index'),
      };
    }
  }

  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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

  // ---------------------------------------------------------------------------
  // NEW: Body Info Page (Gender + Body Weight)
  // ---------------------------------------------------------------------------

  Widget _buildBodyInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PixelText.h2(
            'About You',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll use this to recommend starting weights',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: IronMonColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),

          // Gender selection
          Text(
            'Gender',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: IronMonColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  label: 'Male',
                  icon: Icons.male,
                  isSelected: _gender == 'male',
                  onTap: () => setState(() {
                    _gender = 'male';
                    _resetLiftsForRecommendation();
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _GenderCard(
                  label: 'Female',
                  icon: Icons.female,
                  isSelected: _gender == 'female',
                  onTap: () => setState(() {
                    _gender = 'female';
                    _resetLiftsForRecommendation();
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Body weight input
          Text(
            'Body Weight',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: IronMonColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 36,
                color: IronMonColors.primary,
                onPressed: () {
                  final newWeight = (_bodyWeightKg - 1).clamp(30.0, 200.0);
                  setState(() => _bodyWeightKg = newWeight);
                  _weightTextController.text = newWeight.round().toString();
                  _resetLiftsForRecommendation();
                },
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _weightTextController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: IronMonColors.onSurface,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: IronMonColors.primary),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                  onChanged: (text) {
                    final v = double.tryParse(text);
                    if (v != null && v >= 30 && v <= 200) {
                      setState(() => _bodyWeightKg = v);
                      _resetLiftsForRecommendation();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'kg',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: IronMonColors.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 36,
                color: IronMonColors.primary,
                onPressed: () {
                  final newWeight = (_bodyWeightKg + 1).clamp(30.0, 200.0);
                  setState(() => _bodyWeightKg = newWeight);
                  _weightTextController.text = newWeight.round().toString();
                  _resetLiftsForRecommendation();
                },
              ),
            ],
          ),
          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _resetLiftsForRecommendation() {
    // Reset to 0 so _updateRecommendations will re-fill them
    _benchPress = 0.0;
    _barbellRow = 0.0;
    _squat = 0.0;
    _shoulderPress = 0.0;
  }

  Widget _buildModeSelectPage() {
    return SingleChildScrollView(
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
              onTap: () => setState(() => _isBeginnerMode = true),
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
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: !_isBeginnerMode
                            ? IronMonColors.onPrimaryContainer
                            : IronMonColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll recommend weights based on your body\nAdjust to your actual 5RM',
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
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardLiftPage({
    required MuscleType muscleType,
    required String exerciseName,
    required String exerciseSubtitle,
    required double value,
    required double recommendedValue,
    required ValueChanged<double> onChanged,
    IconData? exerciseIcon,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FiveRmInputCard(
            muscleType: muscleType,
            value: value,
            onChanged: onChanged,
            exerciseName: exerciseName,
            exerciseSubtitle: exerciseSubtitle,
            recommendedValue: recommendedValue,
            exerciseIcon: exerciseIcon,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Adjustment page (page 7 in experienced mode)
  // ---------------------------------------------------------------------------

  static const _exerciseGroups = <_ExerciseGroup>[
    _ExerciseGroup(
      muscleType: MuscleType.chest,
      exercises: [
        _ExerciseInfo('chest-1', 'Push-up', isStandard: false),
        _ExerciseInfo('chest-2', 'Barbell Bench Press', isStandard: true),
        _ExerciseInfo('chest-3', 'Incline Dumbbell Press', isStandard: false),
      ],
    ),
    _ExerciseGroup(
      muscleType: MuscleType.back,
      exercises: [
        _ExerciseInfo('back-1', 'Inverted Row', isStandard: false),
        _ExerciseInfo('back-2', 'Barbell Row', isStandard: true),
        _ExerciseInfo('back-3', 'Lat Pulldown', isStandard: false),
      ],
    ),
    _ExerciseGroup(
      muscleType: MuscleType.legs,
      exercises: [
        _ExerciseInfo('legs-1', 'Bodyweight Squat', isStandard: false),
        _ExerciseInfo('legs-2', 'Barbell Squat', isStandard: true),
        _ExerciseInfo('legs-3', 'Front Squat', isStandard: false),
      ],
    ),
    _ExerciseGroup(
      muscleType: MuscleType.shoulders,
      exercises: [
        _ExerciseInfo('shoulders-1', 'Pike Push-up', isStandard: false),
        _ExerciseInfo('shoulders-2', 'Overhead Press', isStandard: true),
        _ExerciseInfo('shoulders-3', 'Arnold Press', isStandard: false),
      ],
    ),
    _ExerciseGroup(
      muscleType: MuscleType.arms,
      exercises: [
        _ExerciseInfo('arms-1', 'Diamond Push-up', isStandard: false),
        _ExerciseInfo('arms-2', 'Barbell Curl', isStandard: false),
        _ExerciseInfo('arms-3', 'Skull Crusher', isStandard: false),
      ],
    ),
  ];

  Widget _buildExerciseAdjustmentPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
          child: Column(
            children: [
              PixelText.h2(
                'Fine-Tune Your 5RMs',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We estimated your 5RM for each exercise.\nAdjust any value if needed.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: IronMonColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              for (final group in _exerciseGroups) ...[
                _buildGroupHeader(group.muscleType),
                for (final ex in group.exercises)
                  _buildExerciseRow(ex, group.muscleType),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupHeader(MuscleType muscleType) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
      child: Text(
        muscleType.displayName.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: IronMonColors.colorForType(muscleType),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildExerciseRow(_ExerciseInfo ex, MuscleType muscleType) {
    final value = _exerciseFiveRms[ex.id] ?? 0.0;
    return Card(
      color: IronMonColors.surfaceVariant,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            if (ex.isStandard)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.lock, size: 16,
                    color: IronMonColors.onSurfaceVariant),
              ),
            Expanded(
              child: Text(
                ex.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ex.isStandard
                      ? IronMonColors.onSurfaceVariant
                      : IronMonColors.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: ex.isStandard
                  ? Text(
                      '${value.toStringAsFixed(1)} kg',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: IronMonColors.onSurfaceVariant,
                      ),
                    )
                  : TextFormField(
                      initialValue: value.toStringAsFixed(1),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: IronMonColors.onSurface,
                      ),
                      decoration: const InputDecoration(
                        suffixText: 'kg',
                        suffixStyle: TextStyle(
                          color: IronMonColors.onSurfaceVariant,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: IronMonColors.primary,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        final v = double.tryParse(text);
                        if (v != null && v >= 0) {
                          setState(() => _exerciseFiveRms[ex.id] = v);
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyPage() {
    return SingleChildScrollView(
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
                        ? const Icon(Icons.check,
                            color: IronMonColors.primary)
                        : null,
                    onTap: () => setState(() => _weeklyFrequency = days),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmPage() {
    return SingleChildScrollView(
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
              'Standard Lift 5RMs:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _confirmRow('Bench Press', _benchPress),
            _confirmRow('Barbell Row', _barbellRow),
            _confirmRow('Squat', _squat),
            _confirmRow('Overhead Press', _shoulderPress),
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
          const SizedBox(height: 8),
          Text(
            'Gender: ${_gender == 'male' ? 'Male' : 'Female'} | '
            'Weight: ${_bodyWeightKg.round()} kg',
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

  Widget _confirmRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('${value.toStringAsFixed(1)} kg'),
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

// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------

class _ExerciseGroup {
  const _ExerciseGroup({
    required this.muscleType,
    required this.exercises,
  });
  final MuscleType muscleType;
  final List<_ExerciseInfo> exercises;
}

class _ExerciseInfo {
  const _ExerciseInfo(this.id, this.name, {required this.isStandard});
  final String id;
  final String name;
  final bool isStandard;
}

/// Gender selection card widget.
class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? IronMonColors.primaryContainer
          : IronMonColors.surfaceVariant,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected
                    ? IronMonColors.onPrimaryContainer
                    : IronMonColors.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isSelected
                      ? IronMonColors.onPrimaryContainer
                      : IronMonColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
