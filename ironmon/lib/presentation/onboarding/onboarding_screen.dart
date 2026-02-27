import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/presentation/onboarding/widgets/five_rm_input_card.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Onboarding screen where the player enters 5RM values and sets
/// weekly training frequency. Shown only on first launch.
class OnboardingScreen extends ConsumerStatefulWidget {
  /// Creates [OnboardingScreen].
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _squatController = TextEditingController();
  final _benchController = TextEditingController();
  final _deadliftController = TextEditingController();
  final _ohpController = TextEditingController();
  int _weeklyFrequency = 3;
  bool _isBeginnerMode = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _squatController.dispose();
    _benchController.dispose();
    _deadliftController.dispose();
    _ohpController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final profile = UserProfile(
      squatFiveRm: double.tryParse(_squatController.text) ?? 0.0,
      benchPressFiveRm: double.tryParse(_benchController.text) ?? 0.0,
      deadliftFiveRm: double.tryParse(_deadliftController.text) ?? 0.0,
      overheadPressFiveRm: double.tryParse(_ohpController.text) ?? 0.0,
      weeklyFrequency: _weeklyFrequency,
      isBeginnerMode: _isBeginnerMode,
    );

    try {
      await ref
          .read(userProfileProvider.notifier)
          .saveProfile(profile);

      if (!mounted) return;

      final state = ref.read(userProfileProvider);
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to save profile. Try again.',
            ),
          ),
        );
        return;
      }
      context.go('/');
    } on Exception catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Failed to save profile. Try again.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Your Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                title: const Text('Beginner Mode'),
                subtitle: const Text(
                  'Start with minimum weights. System auto-calibrates '
                  'your 5RM over your first 5 sessions.',
                ),
                value: _isBeginnerMode,
                onChanged: (value) {
                  setState(() {
                    _isBeginnerMode = value;
                    if (value) {
                      _squatController.text = '20';
                      _benchController.text = '20';
                      _deadliftController.text = '20';
                      _ohpController.text = '20';
                    }
                  });
                },
              ),
              const SizedBox(height: 8),
              FiveRmInputCard(
                label: 'Squat',
                controller: _squatController,
              ),
              const SizedBox(height: 16),
              FiveRmInputCard(
                label: 'Bench Press',
                controller: _benchController,
              ),
              const SizedBox(height: 16),
              FiveRmInputCard(
                label: 'Deadlift',
                controller: _deadliftController,
              ),
              const SizedBox(height: 16),
              FiveRmInputCard(
                label: 'Overhead Press',
                controller: _ohpController,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<int>(
                initialValue: _weeklyFrequency,
                decoration: const InputDecoration(
                  labelText: 'Weekly Training Frequency',
                ),
                items: List.generate(7, (i) => i + 1)
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text('$v days'),
                      ),
                    )
                    .toList(),
                onChanged: (v) =>
                    setState(() => _weeklyFrequency = v!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _onSubmit,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Start Training'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
