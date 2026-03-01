import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// Panel for entering weight, reps, and RPE for a
/// training set.
/// Uses [ConsumerStatefulWidget] pattern for local
/// text controller state.
class SetInputPanel extends StatefulWidget {
  /// Creates a [SetInputPanel].
  const SetInputPanel({
    required this.onSubmit,
    this.previousWeight,
    this.previousReps,
    super.key,
  });

  /// Callback when the set is submitted.
  final void Function(
    double weight,
    int reps,
    int rpe,
  ) onSubmit;

  /// Previous set weight for prefill.
  final double? previousWeight;

  /// Previous set reps for prefill.
  final int? previousReps;

  @override
  State<SetInputPanel> createState() =>
      _SetInputPanelState();
}

class _SetInputPanelState
    extends State<SetInputPanel> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  int _rpe = 7;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text:
          (widget.previousWeight ?? 20.0).toString(),
    );
    _repsController = TextEditingController(
      text:
          (widget.previousReps ?? 10).toString(),
    );
  }

  @override
  void didUpdateWidget(SetInputPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.previousWeight !=
            oldWidget.previousWeight &&
        widget.previousWeight != null) {
      _weightController.text =
          widget.previousWeight.toString();
    }
    if (widget.previousReps !=
            oldWidget.previousReps &&
        widget.previousReps != null) {
      _repsController.text =
          widget.previousReps.toString();
    }
  }

  void _adjustWeight(double delta) {
    final current =
        double.tryParse(_weightController.text) ??
            20.0;
    final newWeight = (current + delta).clamp(
      0.0,
      999.0,
    );
    _weightController.text = newWeight.toString();
  }

  void _adjustReps(int delta) {
    final current =
        int.tryParse(_repsController.text) ?? 10;
    final newReps = (current + delta).clamp(0, 999);
    _repsController.text = newReps.toString();
  }

  void _submit() {
    final weight =
        double.tryParse(_weightController.text) ??
            0;
    final reps =
        int.tryParse(_repsController.text) ?? 0;
    if (weight > 0 && reps > 0) {
      widget.onSubmit(weight, reps, _rpe);
      _repsController.clear();
      setState(() => _rpe = 7);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Weight row
            Row(
              children: [
                const Text('Weight (kg)'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () =>
                      _adjustWeight(-2.5),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _weightController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .allow(
                        RegExp(r'[\d.]'),
                      ),
                    ],
                    textAlign: TextAlign.center,
                    decoration:
                        const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      _adjustWeight(2.5),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Reps row
            Row(
              children: [
                const Text('Reps'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () =>
                      _adjustReps(-1),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _repsController,
                    keyboardType:
                        TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    decoration:
                        const InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _adjustReps(1),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // RPE quick buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _rpe = 7),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _rpe == 7
                          ? IronMonColors.hpHigh
                          : IronMonColors.surfaceVariant,
                      foregroundColor: _rpe == 7
                          ? IronMonColors.onPrimary
                          : IronMonColors.onSurface,
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text('Easy'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _rpe = 8),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _rpe == 8
                          ? IronMonColors.secondary
                          : IronMonColors.surfaceVariant,
                      foregroundColor: _rpe == 8
                          ? IronMonColors.onSecondary
                          : IronMonColors.onSurface,
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text('Medium'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _rpe = 10),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _rpe == 10
                          ? IronMonColors.error
                          : IronMonColors.surfaceVariant,
                      foregroundColor: _rpe == 10
                          ? IronMonColors.onPrimary
                          : IronMonColors.onSurface,
                      minimumSize: const Size(48, 48),
                    ),
                    child: const Text('Hard'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // RPE slider
            Row(
              children: [
                Text('RPE: $_rpe'),
                Expanded(
                  child: Slider(
                    value: _rpe.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _rpe.toString(),
                    onChanged: (v) => setState(
                      () => _rpe = v.round(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Attack!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
