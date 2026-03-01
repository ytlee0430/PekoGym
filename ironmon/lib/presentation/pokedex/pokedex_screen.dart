import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/pokedex/widgets/move_list_tile.dart';
import 'package:ironmon/presentation/shared/type_badge.dart';
import 'package:ironmon/providers/repository_providers.dart';
import 'package:ironmon/providers/user_profile_providers.dart';

/// Filter state for the Pokédex type filter.
final _typeFilterProvider =
    NotifierProvider<_TypeFilter, MuscleType?>(
  _TypeFilter.new,
);

class _TypeFilter extends Notifier<MuscleType?> {
  @override
  MuscleType? build() => null;
}

/// Pokédex screen — browse all moves with
/// unlocked/locked status and type filter.
class PokedexScreen extends ConsumerWidget {
  /// Creates [PokedexScreen].
  const PokedexScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final registryAsync =
        ref.watch(moveRegistryProvider);
    final profileAsync =
        ref.watch(userProfileProvider);
    final typeFilter =
        ref.watch(_typeFilterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: registryAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
        data: (registry) {
          final profile =
              profileAsync.value;
          final unlockedIds =
              profile?.unlockedMoveIds ?? [];

          var moves = List.of(registry.allMoves);
          if (typeFilter != null) {
            moves = moves
                .where(
                  (m) => m.type == typeFilter,
                )
                .toList();
          }

          // Sort: unlocked first, then by
          // evolution stage
          moves.sort((a, b) {
            final aUnlocked =
                unlockedIds.contains(a.id);
            final bUnlocked =
                unlockedIds.contains(b.id);
            if (aUnlocked != bUnlocked) {
              return aUnlocked ? -1 : 1;
            }
            return a.evolutionStage
                .compareTo(b.evolutionStage);
          });

          return Column(
            children: [
              _TypeFilterBar(
                selected: typeFilter,
                onSelected: (type) => ref
                    .read(
                      _typeFilterProvider
                          .notifier,
                    )
                    .state = type,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: moves.length,
                  itemBuilder: (ctx, i) {
                    final move = moves[i];
                    final unlocked =
                        unlockedIds
                            .contains(move.id);
                    return MoveListTile(
                      move: move,
                      isUnlocked: unlocked,
                      onTap: unlocked
                          ? () => context.push(
                                '/pokedex/'
                                '${move.id}',
                              )
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Horizontal type filter chips.
class _TypeFilterBar extends StatelessWidget {
  const _TypeFilterBar({
    required this.selected,
    required this.onSelected,
  });

  final MuscleType? selected;
  final ValueChanged<MuscleType?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          ...MuscleType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: _FilterChip(
                label: type.elementName,
                color: TypeBadge.colorFor(type),
                isSelected: selected == type,
                onTap: () => onSelected(type),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single filter chip.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor =
        color ?? Colors.grey.shade400;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor.withValues(alpha: 0.3)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? chipColor
                : Colors.grey.shade600,
          ),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? chipColor
                : Colors.grey.shade400,
            fontWeight: isSelected
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
