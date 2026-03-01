import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/type_system/type_effectiveness.dart';

/// Provides the [TypeEffectiveness] matrix instance.
final typeEffectivenessProvider =
    Provider<TypeEffectiveness>((ref) {
  return const TypeEffectiveness();
});
