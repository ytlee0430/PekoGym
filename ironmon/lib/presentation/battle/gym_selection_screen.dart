import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/providers/battle_providers.dart';

/// Screen for selecting muscle group and gym type
/// before starting a battle.
class GymSelectionScreen extends ConsumerWidget {
  /// Creates a [GymSelectionScreen].
  const GymSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMuscle =
        ref.watch(selectedMuscleTypeProvider);
    final selectedGym =
        ref.watch(selectedGymTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Gym'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose Muscle Group',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 12),
            _MuscleTypeGrid(
              selected: selectedMuscle,
              onSelected: (type) => ref
                  .read(
                    selectedMuscleTypeProvider
                        .notifier,
                  )
                  .state = type,
            ),
            const SizedBox(height: 24),
            Text(
              'Choose Gym Type',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 12),
            _GymTypeSelector(
              selected: selectedGym,
              onSelected: (type) => ref
                  .read(
                    selectedGymTypeProvider.notifier,
                  )
                  .state = type,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: selectedMuscle == null
                    ? null
                    : () => context.push('/battle'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child:
                    const Text('Start Battle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MuscleTypeGrid extends StatelessWidget {
  const _MuscleTypeGrid({
    required this.selected,
    required this.onSelected,
  });

  final MuscleType? selected;
  final ValueChanged<MuscleType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: MuscleType.values.map((type) {
        final isSelected = type == selected;
        return ChoiceChip(
          label: Text(
            '${type.displayName}\n'
            '(${type.elementName})',
            textAlign: TextAlign.center,
          ),
          selected: isSelected,
          onSelected: (_) => onSelected(type),
        );
      }).toList(),
    );
  }
}

class _GymTypeSelector extends StatelessWidget {
  const _GymTypeSelector({
    required this.selected,
    required this.onSelected,
  });

  final GymType selected;
  final ValueChanged<GymType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: GymType.values.map((type) {
        final isSelected = type == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: OutlinedButton(
              onPressed: () => onSelected(type),
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected
                    ? Theme.of(context)
                        .colorScheme
                        .primaryContainer
                    : null,
                padding:
                    const EdgeInsets.all(16),
              ),
              child: Column(
                children: [
                  Text(
                    type.displayName,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
