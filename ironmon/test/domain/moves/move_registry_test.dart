import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/moves/move_registry.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:test/test.dart';

void main() {
  final testMoves = [
    const MoveDefinition(
      id: 'chest-1',
      name: 'Push-up',
      type: MuscleType.chest,
      power: 40,
      pp: 15,
      description: 'Basic chest',
      exerciseName: 'Push-up',
      evolutionChainId: 'chest-chain',
      evolutionStage: 1,
      unlockLevel: 1,
    ),
    const MoveDefinition(
      id: 'chest-2',
      name: 'Bench Press',
      type: MuscleType.chest,
      power: 70,
      pp: 10,
      description: 'Heavy chest',
      exerciseName: 'Bench Press',
      evolutionChainId: 'chest-chain',
      evolutionStage: 2,
      unlockLevel: 5,
    ),
    const MoveDefinition(
      id: 'back-1',
      name: 'Inverted Row',
      type: MuscleType.back,
      power: 40,
      pp: 15,
      description: 'Basic back',
      exerciseName: 'Inverted Row',
      evolutionChainId: 'back-chain',
      evolutionStage: 1,
      unlockLevel: 1,
    ),
    const MoveDefinition(
      id: 'legs-1',
      name: 'BW Squat',
      type: MuscleType.legs,
      power: 40,
      pp: 15,
      description: 'Basic legs',
      exerciseName: 'Bodyweight Squat',
      evolutionChainId: 'legs-chain',
      evolutionStage: 1,
      unlockLevel: 1,
    ),
    const MoveDefinition(
      id: 'shoulders-1',
      name: 'Pike Push-up',
      type: MuscleType.shoulders,
      power: 40,
      pp: 15,
      description: 'Basic shoulders',
      exerciseName: 'Pike Push-up',
      evolutionChainId: 'shoulders-chain',
      evolutionStage: 1,
      unlockLevel: 1,
    ),
    const MoveDefinition(
      id: 'arms-1',
      name: 'Diamond Push-up',
      type: MuscleType.arms,
      power: 40,
      pp: 15,
      description: 'Basic arms',
      exerciseName: 'Diamond Push-up',
      evolutionChainId: 'arms-chain',
      evolutionStage: 1,
      unlockLevel: 1,
    ),
  ];

  late MoveRegistry registry;

  setUp(() {
    registry = MoveRegistry(testMoves);
  });

  group('MoveRegistry', () {
    test('getMove returns correct move by id', () {
      final move = registry.getMove('chest-1');
      expect(move, isNotNull);
      expect(move!.name, 'Push-up');
    });

    test('getMove returns null for unknown id', () {
      expect(registry.getMove('unknown'), isNull);
    });

    test('getMovesByType returns correct moves', () {
      final chestMoves = registry.getMovesByType(
        MuscleType.chest,
      );
      expect(chestMoves.length, 2);
      expect(
        chestMoves.every((m) => m.type == MuscleType.chest),
        isTrue,
      );
    });

    test('getUnlockedMoves returns matching moves', () {
      final unlocked = registry.getUnlockedMoves(
        ['chest-1', 'back-1'],
      );
      expect(unlocked.length, 2);
      expect(unlocked[0].id, 'chest-1');
      expect(unlocked[1].id, 'back-1');
    });

    test(
      'getUnlockedMoves skips unknown ids',
      () {
        final unlocked = registry.getUnlockedMoves(
          ['chest-1', 'unknown-99'],
        );
        expect(unlocked.length, 1);
      },
    );

    test(
      'getEvolutionChain returns sorted chain',
      () {
        final chain = registry.getEvolutionChain(
          'chest-chain',
        );
        expect(chain.length, 2);
        expect(chain[0].evolutionStage, 1);
        expect(chain[1].evolutionStage, 2);
      },
    );

    test(
      'getEvolutionChain returns empty for unknown',
      () {
        final chain = registry.getEvolutionChain(
          'unknown-chain',
        );
        expect(chain, isEmpty);
      },
    );

    test(
      'defaultUnlockedMoveIds has one per type',
      () {
        final ids = registry.defaultUnlockedMoveIds;
        expect(ids.length, 5);
        expect(ids, contains('chest-1'));
        expect(ids, contains('back-1'));
        expect(ids, contains('legs-1'));
        expect(ids, contains('shoulders-1'));
        expect(ids, contains('arms-1'));
      },
    );

    test('allMoves returns all loaded moves', () {
      expect(registry.allMoves.length, testMoves.length);
    });
  });
}
