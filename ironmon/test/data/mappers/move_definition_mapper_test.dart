import 'package:ironmon/data/mappers/move_definition_mapper.dart';
import 'package:ironmon/domain/type_system/muscle_type.dart';
import 'package:test/test.dart';

void main() {
  const mapper = MoveDefinitionMapper();

  group('MoveDefinitionMapper', () {
    test('fromJson parses valid JSON correctly', () {
      final json = <String, dynamic>{
        'id': 'chest-1',
        'name': 'Push-up',
        'type': 'chest',
        'power': 40,
        'pp': 15,
        'description': 'Basic chest exercise',
        'exerciseName': 'Push-up',
        'evolutionChainId': 'chest-chain',
        'evolutionStage': 1,
        'unlockLevel': 1,
      };

      final move = mapper.fromJson(json);

      expect(move.id, 'chest-1');
      expect(move.name, 'Push-up');
      expect(move.type, MuscleType.chest);
      expect(move.power, 40);
      expect(move.pp, 15);
      expect(move.description, 'Basic chest exercise');
      expect(move.exerciseName, 'Push-up');
      expect(move.evolutionChainId, 'chest-chain');
      expect(move.evolutionStage, 1);
      expect(move.unlockLevel, 1);
    });

    test('fromJson handles null evolutionChainId', () {
      final json = <String, dynamic>{
        'id': 'standalone-1',
        'name': 'Test Move',
        'type': 'back',
        'power': 50,
        'pp': 10,
        'description': 'A test move',
        'exerciseName': 'Test Exercise',
        'evolutionChainId': null,
        'evolutionStage': 1,
        'unlockLevel': 1,
      };

      final move = mapper.fromJson(json);
      expect(move.evolutionChainId, isNull);
      expect(move.type, MuscleType.back);
    });

    test('fromJson throws on unknown type', () {
      final json = <String, dynamic>{
        'id': 'bad-1',
        'name': 'Bad',
        'type': 'unknown',
        'power': 10,
        'pp': 5,
        'description': 'bad',
        'exerciseName': 'bad',
        'evolutionChainId': null,
        'evolutionStage': 1,
        'unlockLevel': 1,
      };

      expect(
        () => mapper.fromJson(json),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('fromJson parses all muscle types', () {
      for (final type in MuscleType.values) {
        final json = <String, dynamic>{
          'id': '${type.name}-test',
          'name': 'Test',
          'type': type.name,
          'power': 10,
          'pp': 5,
          'description': 'test',
          'exerciseName': 'test',
          'evolutionChainId': null,
          'evolutionStage': 1,
          'unlockLevel': 1,
        };
        final move = mapper.fromJson(json);
        expect(move.type, type);
      }
    });
  });
}
