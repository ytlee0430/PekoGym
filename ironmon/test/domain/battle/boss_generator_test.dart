import 'package:ironmon/domain/battle/boss_generator.dart';
import 'package:ironmon/domain/battle/models/boss.dart';
import 'package:ironmon/domain/battle/models/gym_type.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/domain/type_system/type_effectiveness.dart';
import 'package:test/test.dart';

void main() {
  const te = TypeEffectiveness();
  final generator = BossGenerator(te);

  group('BossGenerator', () {
    test('generates exactly 3 bosses', () {
      final lineup = generator.generateLineup(
        playerMuscle: MuscleType.chest,
        gymType: GymType.physique,
        playerLevel: 1,
      );
      expect(lineup.length, 3);
    });

    test('bosses are in correct stage order', () {
      final lineup = generator.generateLineup(
        playerMuscle: MuscleType.chest,
        gymType: GymType.physique,
        playerLevel: 1,
      );
      expect(lineup[0].stage, BossStage.minion);
      expect(lineup[1].stage, BossStage.midBoss);
      expect(lineup[2].stage, BossStage.gymLeader);
    });

    test(
      'strength gym has high defense low HP',
      () {
        final strength = generator.generateLineup(
          playerMuscle: MuscleType.chest,
          gymType: GymType.strength,
          playerLevel: 5,
        );
        final physique = generator.generateLineup(
          playerMuscle: MuscleType.chest,
          gymType: GymType.physique,
          playerLevel: 5,
        );

        // Compare gym leader stats
        final sLeader = strength[2];
        final pLeader = physique[2];

        expect(
          sLeader.defense,
          greaterThan(pLeader.defense),
        );
        expect(
          sLeader.maxHp,
          lessThan(pLeader.maxHp),
        );
      },
    );

    test(
      'physique gym has low defense high HP',
      () {
        final physique = generator.generateLineup(
          playerMuscle: MuscleType.back,
          gymType: GymType.physique,
          playerLevel: 5,
        );
        final strength = generator.generateLineup(
          playerMuscle: MuscleType.back,
          gymType: GymType.strength,
          playerLevel: 5,
        );

        final pLeader = physique[2];
        final sLeader = strength[2];

        expect(
          pLeader.maxHp,
          greaterThan(sLeader.maxHp),
        );
        expect(
          pLeader.defense,
          lessThan(sLeader.defense),
        );
      },
    );

    test('boss stats scale with player level', () {
      final low = generator.generateLineup(
        playerMuscle: MuscleType.legs,
        gymType: GymType.physique,
        playerLevel: 1,
      );
      final high = generator.generateLineup(
        playerMuscle: MuscleType.legs,
        gymType: GymType.physique,
        playerLevel: 10,
      );

      expect(
        high[2].maxHp,
        greaterThan(low[2].maxHp),
      );
      expect(
        high[2].defense,
        greaterThan(low[2].defense),
      );
    });

    test(
      'gym leader type resists player type',
      () {
        // Chest (Fire) is not effective vs Back
        // (Water) → leader should be Water
        final lineup = generator.generateLineup(
          playerMuscle: MuscleType.chest,
          gymType: GymType.physique,
          playerLevel: 1,
        );
        final leader = lineup[2];
        final mult = te.getMultiplier(
          MuscleType.chest,
          leader.type,
        );
        // Leader should resist or at least not be
        // super effective target
        expect(
          mult,
          lessThanOrEqualTo(1.0),
        );
      },
    );

    test('minion has same type as player', () {
      for (final muscle in MuscleType.values) {
        final lineup = generator.generateLineup(
          playerMuscle: muscle,
          gymType: GymType.physique,
          playerLevel: 1,
        );
        expect(
          lineup[0].type,
          muscle,
          reason:
              'Minion type for ${muscle.name}',
        );
      }
    });

    test('boss currentHp equals maxHp', () {
      final lineup = generator.generateLineup(
        playerMuscle: MuscleType.shoulders,
        gymType: GymType.strength,
        playerLevel: 3,
      );
      for (final boss in lineup) {
        expect(boss.currentHp, boss.maxHp);
      }
    });

    test(
      'generates for all muscle types',
      () {
        for (final muscle in MuscleType.values) {
          for (final gym in GymType.values) {
            final lineup =
                generator.generateLineup(
              playerMuscle: muscle,
              gymType: gym,
              playerLevel: 5,
            );
            expect(
              lineup.length,
              3,
              reason:
                  '${muscle.name} + ${gym.name}',
            );
          }
        }
      },
    );
  });
}
