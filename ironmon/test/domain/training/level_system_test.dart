import 'package:ironmon/domain/training/level_system.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';
import 'package:test/test.dart';

void main() {
  const system = LevelSystem();

  group('expForLevel', () {
    test('level 1 requires 0 EXP', () {
      expect(system.expForLevel(1), 0);
    });

    test('level 2 requires 150 EXP', () {
      // 2 * 100 + 1 * 50 = 250
      expect(system.expForLevel(2), 250);
    });

    test('level 3 requires 400 EXP', () {
      // 3 * 100 + 2 * 50 = 400
      expect(system.expForLevel(3), 400);
    });

    test('level 4 requires 600 EXP', () {
      // 4 * 100 + 3 * 50 = 550
      expect(system.expForLevel(4), 550);
    });

    test('progression increases per level', () {
      for (var lv = 2; lv <= 20; lv++) {
        expect(
          system.expForLevel(lv),
          greaterThan(system.expForLevel(lv - 1)),
        );
      }
    });
  });

  group('expToNextLevel', () {
    test('level 1 to 2 needs 250', () {
      // expForLevel(2) - expForLevel(1) = 250 - 0
      expect(system.expToNextLevel(1), 250);
    });

    test('level 2 to 3 needs 150', () {
      // expForLevel(3) - expForLevel(2) = 400 - 250
      expect(system.expToNextLevel(2), 150);
    });
  });

  group('checkLevelUp', () {
    test('no level up when EXP insufficient', () {
      const profile = UserProfile(
        level: 1,
        experiencePoints: 0,
      );
      final result = system.checkLevelUp(
        profile,
        100,
      );
      expect(result.didLevelUp, false);
      expect(result.newLevel, 1);
      expect(result.levelsGained, 0);
      expect(result.remainingExp, 100);
      expect(result.hpIncrease, 0);
    });

    test('single level up', () {
      const profile = UserProfile(
        level: 1,
        experiencePoints: 0,
      );
      // Need 250 for level 2
      final result = system.checkLevelUp(
        profile,
        250,
      );
      expect(result.didLevelUp, true);
      expect(result.newLevel, 2);
      expect(result.levelsGained, 1);
      expect(result.remainingExp, 250);
      expect(result.hpIncrease, 5);
    });

    test('multi-level up', () {
      const profile = UserProfile(
        level: 1,
        experiencePoints: 0,
      );
      // Need 250 for lv2, 400 for lv3
      // Give 500 → should reach lv3
      final result = system.checkLevelUp(
        profile,
        500,
      );
      expect(result.didLevelUp, true);
      expect(result.newLevel, 3);
      expect(result.levelsGained, 2);
      expect(result.remainingExp, 500);
      expect(result.hpIncrease, 10);
    });

    test('exact threshold levels up', () {
      const profile = UserProfile(
        level: 1,
        experiencePoints: 0,
      );
      final result = system.checkLevelUp(
        profile,
        250,
      );
      expect(result.didLevelUp, true);
      expect(result.newLevel, 2);
    });

    test('existing EXP contributes', () {
      const profile = UserProfile(
        level: 1,
        experiencePoints: 200,
      );
      // Already 200, earn 50 → 250 = level 2
      final result = system.checkLevelUp(
        profile,
        50,
      );
      expect(result.didLevelUp, true);
      expect(result.newLevel, 2);
      expect(result.remainingExp, 250);
    });

    test('stat increase scales with levels', () {
      const profile = UserProfile(
        level: 1,
        experiencePoints: 0,
      );
      // Give enough for 5 levels
      final result = system.checkLevelUp(
        profile,
        10000,
      );
      expect(result.levelsGained, greaterThan(1));
      expect(
        result.hpIncrease,
        result.levelsGained * 5,
      );
    });

    test('zero earned EXP returns no change', () {
      const profile = UserProfile(
        level: 5,
        experiencePoints: 500,
      );
      final result = system.checkLevelUp(
        profile,
        0,
      );
      expect(result.didLevelUp, false);
      expect(result.newLevel, 5);
    });
  });
}
