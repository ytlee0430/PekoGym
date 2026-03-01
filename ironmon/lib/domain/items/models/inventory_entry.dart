import 'package:meta/meta.dart';

/// Immutable entry representing a quantity of a specific item.
/// Pure Dart — zero Flutter dependency.
@immutable
class InventoryEntry {
  /// Creates an [InventoryEntry].
  const InventoryEntry({
    required this.itemId,
    required this.quantity,
  });

  /// The item's unique identifier.
  final String itemId;

  /// Number of this item held (0–99).
  final int quantity;

  /// Returns a copy with updated fields.
  InventoryEntry copyWith({
    String? itemId,
    int? quantity,
  }) {
    return InventoryEntry(
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InventoryEntry &&
        other.itemId == itemId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(itemId, quantity);

  @override
  String toString() =>
      'InventoryEntry(itemId: $itemId, qty: $quantity)';
}
