import 'package:ironmon/domain/moves/models/move_definition.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:test/test.dart';

void main() {
  const move = MoveDefinition(
    id: 'chest-1',
    name: 'Push-up',
    type: MuscleType.chest,
    power: 40,
    pp: 15,
    description: 'Basic chest exercise',
    exerciseName: 'Push-up',
    evolutionChainId: 'chest-chain',
    evolutionStage: 1,
    unlockLevel: 1,
  );

  group('MoveDefinition', () {
    test('equality by value', () {
      const other = MoveDefinition(
        id: 'chest-1',
        name: 'Push-up',
        type: MuscleType.chest,
        power: 40,
        pp: 15,
        description: 'Basic chest exercise',
        exerciseName: 'Push-up',
        evolutionChainId: 'chest-chain',
        evolutionStage: 1,
        unlockLevel: 1,
      );
      expect(move, equals(other));
      expect(move.hashCode, other.hashCode);
    });

    test('inequality when fields differ', () {
      final other = move.copyWith(id: 'chest-2');
      expect(move, isNot(equals(other)));
    });

    test('copyWith preserves unchanged fields', () {
      final copy = move.copyWith(power: 50);
      expect(copy.id, 'chest-1');
      expect(copy.name, 'Push-up');
      expect(copy.power, 50);
      expect(copy.pp, 15);
      expect(copy.type, MuscleType.chest);
    });

    test('copyWith updates all fields', () {
      final copy = move.copyWith(
        id: 'back-1',
        name: 'Row',
        type: MuscleType.back,
        power: 60,
        pp: 10,
        description: 'Row desc',
        exerciseName: 'Row',
        evolutionChainId: 'back-chain',
        evolutionStage: 2,
        unlockLevel: 5,
      );
      expect(copy.id, 'back-1');
      expect(copy.name, 'Row');
      expect(copy.type, MuscleType.back);
      expect(copy.power, 60);
      expect(copy.pp, 10);
      expect(copy.description, 'Row desc');
      expect(copy.exerciseName, 'Row');
      expect(copy.evolutionChainId, 'back-chain');
      expect(copy.evolutionStage, 2);
      expect(copy.unlockLevel, 5);
    });

    test('toString contains key info', () {
      final str = move.toString();
      expect(str, contains('chest-1'));
      expect(str, contains('Push-up'));
    });
  });
}
