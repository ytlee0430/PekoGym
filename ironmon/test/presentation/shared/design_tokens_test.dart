import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

void main() {
  group('IronMonColors', () {
    test('primary palette matches UX spec hex values', () {
      expect(IronMonColors.surface, const Color(0xFF0D1117));
      expect(
        IronMonColors.surfaceVariant,
        const Color(0xFF161B22),
      );
      expect(IronMonColors.primary, const Color(0xFF58A6FF));
      expect(
        IronMonColors.onPrimary,
        const Color(0xFFFFFFFF),
      );
      expect(
        IronMonColors.secondary,
        const Color(0xFFF0C040),
      );
      expect(IronMonColors.error, const Color(0xFFF85149));
      expect(
        IronMonColors.onSurface,
        const Color(0xFFC9D1D9),
      );
      expect(
        IronMonColors.onSurfaceVariant,
        const Color(0xFF8B949E),
      );
    });

    test('type effectiveness colors match UX spec', () {
      expect(
        IronMonColors.typeFire,
        const Color(0xFFFF6B35),
      );
      expect(
        IronMonColors.typeWater,
        const Color(0xFF4B9CD3),
      );
      expect(
        IronMonColors.typeRock,
        const Color(0xFFA0855B),
      );
      expect(
        IronMonColors.typeElectric,
        const Color(0xFFFFD93D),
      );
      expect(
        IronMonColors.typeFighting,
        const Color(0xFFC2185B),
      );
    });

    test('semantic damage colors match UX spec', () {
      expect(
        IronMonColors.damageNormal,
        const Color(0xFFFFFFFF),
      );
      expect(
        IronMonColors.damageCritical,
        const Color(0xFFFFD93D),
      );
      expect(
        IronMonColors.damageSuperEffective,
        const Color(0xFFFF6B35),
      );
      expect(
        IronMonColors.damageNotEffective,
        const Color(0xFF8B949E),
      );
    });

    test('semantic HP colors match UX spec', () {
      expect(IronMonColors.hpHigh, const Color(0xFF3FB950));
      expect(IronMonColors.hpMid, const Color(0xFFF0C040));
      expect(IronMonColors.hpLow, const Color(0xFFF85149));
    });

    test('EXP bar color matches UX spec', () {
      expect(IronMonColors.expBar, const Color(0xFF58A6FF));
    });

    test(
      'colorForType covers all 5 MuscleType values',
      () {
        expect(
          IronMonColors.colorForType(MuscleType.chest),
          IronMonColors.typeFire,
        );
        expect(
          IronMonColors.colorForType(MuscleType.back),
          IronMonColors.typeWater,
        );
        expect(
          IronMonColors.colorForType(MuscleType.legs),
          IronMonColors.typeRock,
        );
        expect(
          IronMonColors.colorForType(
            MuscleType.shoulders,
          ),
          IronMonColors.typeElectric,
        );
        expect(
          IronMonColors.colorForType(MuscleType.arms),
          IronMonColors.typeFighting,
        );
      },
    );
  });

  group('IronMonSpacing', () {
    test('follows 8dp grid system', () {
      expect(IronMonSpacing.xs, 4.0);
      expect(IronMonSpacing.sm, 8.0);
      expect(IronMonSpacing.md, 16.0);
      expect(IronMonSpacing.lg, 24.0);
      expect(IronMonSpacing.xl, 32.0);
      expect(IronMonSpacing.xxl, 48.0);
    });
  });

  group('IronMonSizes', () {
    test('touch targets meet minimums', () {
      expect(IronMonSizes.touchMin, 48.0);
      expect(IronMonSizes.battleButton, 56.0);
    });
  });
}
