import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/presentation/pokedex/widgets/evolution_chain_view.dart';
import 'package:ironmon/presentation/shared/type_badge.dart';
import 'package:ironmon/domain/shared/result.dart';
import 'package:ironmon/providers/repository_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Move detail screen — displays stats, evolution
/// chain, usage count, and PR record.
class MoveDetailScreen extends ConsumerWidget {
  /// Creates [MoveDetailScreen] for [moveId].
  const MoveDetailScreen({
    required this.moveId,
    super.key,
  });

  /// The move identifier from the route.
  final String moveId;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final registryAsync =
        ref.watch(moveRegistryProvider);
    final profileAsync =
        ref.watch(userProfileProvider);

    return registryAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text('Error: $e'),
        ),
      ),
      data: (registry) {
        final move = registry.getMove(moveId);
        if (move == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Move not found'),
            ),
          );
        }

        final profile =
            profileAsync.value;
        final unlockedIds =
            profile?.unlockedMoveIds ?? [];

        // Evolution chain
        final chain = move.evolutionChainId !=
                null
            ? registry.getEvolutionChain(
                move.evolutionChainId!,
              )
            : <MoveDefinition>[move];

        final color =
            TypeBadge.colorFor(move.type);

        return Scaffold(
          appBar: AppBar(
            title: Text(move.name),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // Header
                _HeaderCard(
                  move: move,
                  color: color,
                ),
                const SizedBox(height: 16),

                // Stats
                _SectionTitle(title: 'Stats'),
                const SizedBox(height: 8),
                _StatsCard(move: move),
                const SizedBox(height: 16),

                // Evolution Chain
                if (chain.length > 1) ...[
                  _SectionTitle(
                    title: 'Evolution Chain',
                  ),
                  const SizedBox(height: 8),
                  EvolutionChainView(
                    chain: chain,
                    currentMoveId: moveId,
                    unlockedIds: unlockedIds,
                  ),
                  const SizedBox(height: 16),
                ],

                // Usage & PR
                _SectionTitle(
                  title: 'Battle Records',
                ),
                const SizedBox(height: 8),
                _RecordsCard(move: move),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Move header with name, type badge, exercise.
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.move,
    required this.color,
  });

  final MoveDefinition move;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor:
                  color.withValues(alpha: 0.2),
              child: Text(
                'P${move.power}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    move.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    move.exerciseName,
                    style: TextStyle(
                      color:
                          Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TypeBadge(type: move.type),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section title text.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Stats card with power, PP, description.
class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.move});

  final MoveDefinition move;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _StatRow(
              label: 'Power',
              value: '${move.power}',
            ),
            _StatRow(
              label: 'PP',
              value: '${move.pp}',
            ),
            _StatRow(
              label: 'Type',
              value: move.type.displayName,
            ),
            _StatRow(
              label: 'Stage',
              value: '${move.evolutionStage}',
            ),
            _StatRow(
              label: 'Unlock Level',
              value: 'Lv.${move.unlockLevel}',
            ),
            const SizedBox(height: 8),
            Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                move.description,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A label-value row.
class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Battle records — usage count and best set
/// data queried from workout history (FR25).
class _RecordsCard extends ConsumerWidget {
  const _RecordsCard({required this.move});

  final MoveDefinition move;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(
      workoutSessionRepositoryProvider,
    );

    return FutureBuilder(
      future: Future.wait([
        repo.getMoveUsageCount(move.id),
        repo.getMoveBestSet(move.id),
      ]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child:
                    CircularProgressIndicator(),
              ),
            ),
          );
        }

        final results = snapshot.data!;
        final countResult = results[0];
        final bestResult = results[1];

        final count = countResult is Success
            ? (countResult as Success).value as int
            : 0;
        final bestSet = bestResult is Success
            ? (bestResult as Success).value
            : null;

        if (count == 0) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'No battle data yet',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Complete battles to see '
                    'usage count and PR records.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _StatRow(
                  label: 'Times Used',
                  value: '$count',
                ),
                if (bestSet != null) ...[
                  _StatRow(
                    label: 'Best Weight',
                    value:
                        '${bestSet.weight} kg',
                  ),
                  _StatRow(
                    label: 'Best Set',
                    value:
                        '${bestSet.weight} kg × '
                        '${bestSet.reps} reps',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
