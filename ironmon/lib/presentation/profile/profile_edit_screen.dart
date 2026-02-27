import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Screen for manually overriding 5RM values.
/// Beginner mode and calibration progress are preserved on save.
class ProfileEditScreen extends ConsumerStatefulWidget {
  /// Creates [ProfileEditScreen].
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _squatController = TextEditingController();
  final _benchController = TextEditingController();
  final _deadliftController = TextEditingController();
  final _ohpController = TextEditingController();
  bool _isSaving = false;
  bool _initialized = false;
  UserProfile? _currentProfile;

  void _initFromProfile(UserProfile profile) {
    if (_initialized) return;
    _initialized = true;
    _currentProfile = profile;
    _squatController.text = profile.squatFiveRm.toString();
    _benchController.text = profile.benchPressFiveRm.toString();
    _deadliftController.text = profile.deadliftFiveRm.toString();
    _ohpController.text = profile.overheadPressFiveRm.toString();
  }

  @override
  void dispose() {
    _squatController.dispose();
    _benchController.dispose();
    _deadliftController.dispose();
    _ohpController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final current = _currentProfile;
    if (current == null) return;

    setState(() => _isSaving = true);

    final updated = current.copyWith(
      squatFiveRm:
          double.tryParse(_squatController.text) ?? current.squatFiveRm,
      benchPressFiveRm:
          double.tryParse(_benchController.text) ?? current.benchPressFiveRm,
      deadliftFiveRm:
          double.tryParse(_deadliftController.text) ?? current.deadliftFiveRm,
      overheadPressFiveRm:
          double.tryParse(_ohpController.text) ?? current.overheadPressFiveRm,
    );

    try {
      await ref
          .read(userProfileProvider.notifier)
          .updateProfile(updated);

      if (!mounted) return;

      final state = ref.read(userProfileProvider);
      if (state.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save. Try again.')),
        );
        return;
      }
      Navigator.of(context).pop();
    } on Exception catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save. Try again.')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: '$label 5RM (kg)',
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label 5RM';
          }
          final parsed = double.tryParse(value);
          if (parsed == null || parsed <= 0) {
            return 'Must be a valid number greater than 0';
          }
          if (parsed >= 1000) {
            return 'Must be less than 1000 kg';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userProfileProvider).whenData((profile) {
      if (profile != null) _initFromProfile(profile);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Edit 5RM Values')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_currentProfile?.isBeginnerMode ?? false) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Calibrating (${_currentProfile!.calibrationSessionsCompleted}/'
                    '${_currentProfile!.calibrationTargetSessions} sessions)',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const Divider(),
              ],
              _buildField('Squat', _squatController),
              _buildField('Bench Press', _benchController),
              _buildField('Deadlift', _deadliftController),
              _buildField('Overhead Press', _ohpController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isSaving ? null : _onSave,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
