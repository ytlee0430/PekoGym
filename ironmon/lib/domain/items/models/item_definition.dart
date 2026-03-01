import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:meta/meta.dart';

/// Immutable definition of a game item.
/// Pure Dart — zero Flutter dependency.
@immutable
class ItemDefinition {
  /// Creates an [ItemDefinition].
  const ItemDefinition({
    required this.id,
    required this.name,
    required this.nameZh,
    required this.description,
    required this.type,
    this.maxStack = 99,
    this.price = 50,
  });

  /// Unique identifier (e.g., "potion").
  final String id;

  /// English display name.
  final String name;

  /// Chinese display name.
  final String nameZh;

  /// Item description text.
  final String description;

  /// Item type category.
  final ItemType type;

  /// Maximum stack size per inventory slot.
  final int maxStack;

  /// Purchase price in coins.
  final int price;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemDefinition &&
        other.id == id &&
        other.name == name &&
        other.nameZh == nameZh &&
        other.description == description &&
        other.type == type &&
        other.maxStack == maxStack &&
        other.price == price;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        nameZh,
        description,
        type,
        maxStack,
        price,
      );

  @override
  String toString() =>
      'ItemDefinition(id: $id, name: $name, '
      'type: ${type.name}, price: $price)';
}
