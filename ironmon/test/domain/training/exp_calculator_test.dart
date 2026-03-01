import 'package:ironmon/domain/training/exp_calculator.dart';
import 'package:test/test.dart';

void main() {
  const calculator = ExpCalculator();

  group('ExpCalculator', () {
    test('victory formula matches expected', () {
      // 3000 * 0.1 + 12 * 10 + 2400 * 0.01
      // = 300 + 120 + 24 = 444 * 1.0 = 444
      final exp = calculator.calculateExp(
        totalDamage: 3000,
        totalSets: 12,
        totalVolume: 2400,
        isVictory: true,
      );
      expect(exp, 444);
    });

    test('defeat applies 0.6 modifier', () {
      // 3000 * 0.1 + 12 * 10 + 2400 * 0.01
      // = 444 * 0.6 = 266.4 → 266
      final exp = calculator.calculateExp(
        totalDamage: 3000,
        totalSets: 12,
        totalVolume: 2400,
        isVictory: false,
      );
      expect(exp, 266);
    });

    test('minimum EXP is 1', () {
      final exp = calculator.calculateExp(
        totalDamage: 0,
        totalSets: 0,
        totalVolume: 0,
        isVictory: true,
      );
      expect(exp, 1);
    });

    test('minimum EXP is 1 on defeat', () {
      final exp = calculator.calculateExp(
        totalDamage: 0,
        totalSets: 0,
        totalVolume: 0,
        isVictory: false,
      );
      expect(exp, 1);
    });

    test('zero damage still earns from sets', () {
      // 0 + 5 * 10 + 0 = 50 * 1.0 = 50
      final exp = calculator.calculateExp(
        totalDamage: 0,
        totalSets: 5,
        totalVolume: 0,
        isVictory: true,
      );
      expect(exp, 50);
    });

    test('zero sets still earns from damage', () {
      // 1000 * 0.1 + 0 + 0 = 100 * 1.0 = 100
      final exp = calculator.calculateExp(
        totalDamage: 1000,
        totalSets: 0,
        totalVolume: 0,
        isVictory: true,
      );
      expect(exp, 100);
    });

    test('large values compute correctly', () {
      // 10000 * 0.1 + 50 * 10 + 50000 * 0.01
      // = 1000 + 500 + 500 = 2000 * 1.0 = 2000
      final exp = calculator.calculateExp(
        totalDamage: 10000,
        totalSets: 50,
        totalVolume: 50000,
        isVictory: true,
      );
      expect(exp, 2000);
    });

    test('defeat large values', () {
      // 2000 * 0.6 = 1200
      final exp = calculator.calculateExp(
        totalDamage: 10000,
        totalSets: 50,
        totalVolume: 50000,
        isVictory: false,
      );
      expect(exp, 1200);
    });
  });
}
