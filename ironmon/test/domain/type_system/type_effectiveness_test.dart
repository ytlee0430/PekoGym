import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/domain/type_system/type_effectiveness.dart';
import 'package:test/test.dart';

void main() {
  const te = TypeEffectiveness();

  group('MuscleType', () {
    test('has exactly 5 values', () {
      expect(MuscleType.values.length, 5);
    });

    test('displayName returns correct names', () {
      expect(MuscleType.chest.displayName, 'Chest');
      expect(MuscleType.back.displayName, 'Back');
      expect(MuscleType.legs.displayName, 'Legs');
      expect(
        MuscleType.shoulders.displayName,
        'Shoulders',
      );
      expect(MuscleType.arms.displayName, 'Arms');
    });

    test('elementName returns correct elements', () {
      expect(MuscleType.chest.elementName, 'Fire');
      expect(MuscleType.back.elementName, 'Water');
      expect(MuscleType.legs.elementName, 'Rock');
      expect(
        MuscleType.shoulders.elementName,
        'Electric',
      );
      expect(MuscleType.arms.elementName, 'Fighting');
    });
  });

  group('TypeEffectiveness', () {
    test('chest (Fire) matchups', () {
      expect(
        te.getMultiplier(MuscleType.chest, MuscleType.chest),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.chest, MuscleType.back),
        0.5,
      );
      expect(
        te.getMultiplier(MuscleType.chest, MuscleType.legs),
        1.5,
      );
      expect(
        te.getMultiplier(
          MuscleType.chest,
          MuscleType.shoulders,
        ),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.chest, MuscleType.arms),
        1.0,
      );
    });

    test('back (Water) matchups', () {
      expect(
        te.getMultiplier(MuscleType.back, MuscleType.chest),
        1.5,
      );
      expect(
        te.getMultiplier(MuscleType.back, MuscleType.back),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.back, MuscleType.legs),
        1.0,
      );
      expect(
        te.getMultiplier(
          MuscleType.back,
          MuscleType.shoulders,
        ),
        0.5,
      );
      expect(
        te.getMultiplier(MuscleType.back, MuscleType.arms),
        1.0,
      );
    });

    test('legs (Rock) matchups', () {
      expect(
        te.getMultiplier(MuscleType.legs, MuscleType.chest),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.legs, MuscleType.back),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.legs, MuscleType.legs),
        1.0,
      );
      expect(
        te.getMultiplier(
          MuscleType.legs,
          MuscleType.shoulders,
        ),
        1.5,
      );
      expect(
        te.getMultiplier(MuscleType.legs, MuscleType.arms),
        0.5,
      );
    });

    test('shoulders (Electric) matchups', () {
      expect(
        te.getMultiplier(
          MuscleType.shoulders,
          MuscleType.chest,
        ),
        1.0,
      );
      expect(
        te.getMultiplier(
          MuscleType.shoulders,
          MuscleType.back,
        ),
        1.5,
      );
      expect(
        te.getMultiplier(
          MuscleType.shoulders,
          MuscleType.legs,
        ),
        0.5,
      );
      expect(
        te.getMultiplier(
          MuscleType.shoulders,
          MuscleType.shoulders,
        ),
        1.0,
      );
      expect(
        te.getMultiplier(
          MuscleType.shoulders,
          MuscleType.arms,
        ),
        1.0,
      );
    });

    test('arms (Fighting) matchups', () {
      expect(
        te.getMultiplier(MuscleType.arms, MuscleType.chest),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.arms, MuscleType.back),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.arms, MuscleType.legs),
        1.5,
      );
      expect(
        te.getMultiplier(
          MuscleType.arms,
          MuscleType.shoulders,
        ),
        1.0,
      );
      expect(
        te.getMultiplier(MuscleType.arms, MuscleType.arms),
        1.0,
      );
    });

    test('all 25 matchups have valid values', () {
      for (final attacker in MuscleType.values) {
        for (final defender in MuscleType.values) {
          final m = te.getMultiplier(attacker, defender);
          expect(
            m,
            anyOf(0.5, 1.0, 1.5),
            reason: '${attacker.name} vs '
                '${defender.name} = $m',
          );
        }
      }
    });
  });
}
