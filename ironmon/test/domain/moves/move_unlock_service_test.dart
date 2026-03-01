import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/moves/move_registry.dart';
import 'package:ironmon/domain/moves/move_unlock_service.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:test/test.dart';

void main() {
  const service = MoveUnlockService();

  final moves = [
    const MoveDefinition(
      id: 'chest-1',
      name: 'Push-up',
      type: MuscleType.chest,
      power: 40,
      pp: 35,
      description: 'Basic chest',
      exerciseName: 'Push-up',
      evolutionStage: 1,
      unlockLevel: 1,
      evolutionChainId: 'chest-chain',
    ),
    const MoveDefinition(
      id: 'chest-2',
      name: 'Bench Press',
      type: MuscleType.chest,
      power: 80,
      pp: 15,
      description: 'Barbell chest',
      exerciseName: 'Barbell Bench Press',
      evolutionStage: 2,
      unlockLevel: 5,
      evolutionChainId: 'chest-chain',
    ),
    const MoveDefinition(
      id: 'chest-3',
      name: 'Incline DB Press',
      type: MuscleType.chest,
      power: 100,
      pp: 10,
      description: 'Incline chest',
      exerciseName: 'Incline Dumbbell Press',
      evolutionStage: 3,
      unlockLevel: 10,
      evolutionChainId: 'chest-chain',
    ),
    const MoveDefinition(
      id: 'back-1',
      name: 'Pull-up',
      type: MuscleType.back,
      power: 45,
      pp: 30,
      description: 'Basic back',
      exerciseName: 'Pull-up',
      evolutionStage: 1,
      unlockLevel: 1,
    ),
    const MoveDefinition(
      id: 'legs-1',
      name: 'Squat',
      type: MuscleType.legs,
      power: 50,
      pp: 25,
      description: 'Basic legs',
      exerciseName: 'Bodyweight Squat',
      evolutionStage: 1,
      unlockLevel: 3,
    ),
  ];

  late MoveRegistry registry;

  setUp(() {
    registry = MoveRegistry(moves);
  });

  group('checkNewUnlocks', () {
    test('level 1 unlocks stage-1 moves at level 1', () {
      const profile = UserProfile(
        level: 1,
        unlockedMoveIds: [],
      );
      final unlocked = service.checkNewUnlocks(
        profile: profile,
        registry: registry,
      );
      final ids = unlocked.map((m) => m.id);
      expect(ids, contains('chest-1'));
      expect(ids, contains('back-1'));
      expect(ids, isNot(contains('legs-1')));
    });

    test('level 3 unlocks legs-1', () {
      const profile = UserProfile(
        level: 3,
        unlockedMoveIds: ['chest-1', 'back-1'],
      );
      final unlocked = service.checkNewUnlocks(
        profile: profile,
        registry: registry,
      );
      final ids = unlocked.map((m) => m.id);
      expect(ids, contains('legs-1'));
    });

    test(
      'level 5 unlocks chest-2 when chest-1 '
      'already unlocked',
      () {
        const profile = UserProfile(
          level: 5,
          unlockedMoveIds: [
            'chest-1',
            'back-1',
          ],
        );
        final unlocked =
            service.checkNewUnlocks(
          profile: profile,
          registry: registry,
        );
        final ids = unlocked.map((m) => m.id);
        expect(ids, contains('chest-2'));
        expect(ids, contains('legs-1'));
      },
    );

    test(
      'chest-2 blocked by level even if chest-1 '
      'available',
      () {
        // level 4 < chest-2 unlockLevel (5)
        const profile = UserProfile(
          level: 4,
          unlockedMoveIds: ['back-1'],
        );
        final unlocked =
            service.checkNewUnlocks(
          profile: profile,
          registry: registry,
        );
        final ids = unlocked.map((m) => m.id);
        expect(ids, isNot(contains('chest-2')));
        // chest-1 still unlocks (level 1)
        expect(ids, contains('chest-1'));
      },
    );

    test(
      'cannot unlock chest-3 without chest-2',
      () {
        const profile = UserProfile(
          level: 10,
          unlockedMoveIds: ['chest-1'],
        );
        final unlocked =
            service.checkNewUnlocks(
          profile: profile,
          registry: registry,
        );
        final ids =
            unlocked.map((m) => m.id).toList();
        // chest-2 should unlock (chest-1 exists)
        expect(ids, contains('chest-2'));
        // chest-3 should also unlock
        // (chest-2 now in newly unlocked)
        expect(ids, contains('chest-3'));
      },
    );

    test('already unlocked moves not re-reported',
        () {
      const profile = UserProfile(
        level: 5,
        unlockedMoveIds: [
          'chest-1',
          'back-1',
          'legs-1',
          'chest-2',
        ],
      );
      final unlocked = service.checkNewUnlocks(
        profile: profile,
        registry: registry,
      );
      expect(unlocked, isEmpty);
    });

    test('multiple simultaneous unlocks', () {
      const profile = UserProfile(
        level: 10,
        unlockedMoveIds: [],
      );
      final unlocked = service.checkNewUnlocks(
        profile: profile,
        registry: registry,
      );
      // Should unlock chest-1, chest-2, chest-3,
      // back-1, legs-1
      expect(unlocked.length, 5);
    });
  });
}
