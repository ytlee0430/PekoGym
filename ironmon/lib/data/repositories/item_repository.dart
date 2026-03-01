import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ironmon/domain/items/models/item_definition.dart';
import 'package:ironmon/domain/items/models/item_type.dart';
import 'package:ironmon/domain/training/models/user_profile.dart';

/// Loads item definitions from JSON and manages inventory reads.
/// Inventory mutations delegate to [UserProfile.copyWith] — persistence
/// is handled by [UserProfileRepository].
class ItemRepository {
  /// Creates an [ItemRepository].
  const ItemRepository();

  /// Loads all item definitions from `assets/data/items.json`.
  Future<List<ItemDefinition>> loadItems() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/items.json',
    );
    final jsonList =
        json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => _fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Returns the count of [itemId] in [profile].
  int getQuantity(UserProfile profile, String itemId) {
    return switch (itemId) {
      'potion' => profile.potionCount,
      'ether' => profile.etherCount,
      'rare_candy' => profile.rareCandyCount,
      _ => 0,
    };
  }

  /// Returns [profile] with [itemId] quantity incremented by [amount].
  /// Clamps to [maxStack] (default 99).
  UserProfile addItem(
    UserProfile profile,
    String itemId, {
    int amount = 1,
    int maxStack = 99,
  }) {
    return switch (itemId) {
      'potion' => profile.copyWith(
          potionCount:
              (profile.potionCount + amount).clamp(0, maxStack),
        ),
      'ether' => profile.copyWith(
          etherCount:
              (profile.etherCount + amount).clamp(0, maxStack),
        ),
      'rare_candy' => profile.copyWith(
          rareCandyCount:
              (profile.rareCandyCount + amount).clamp(0, maxStack),
        ),
      _ => profile,
    };
  }

  /// Returns [profile] with [itemId] quantity decremented by [amount].
  /// Returns unchanged profile if quantity is 0.
  UserProfile removeItem(
    UserProfile profile,
    String itemId, {
    int amount = 1,
  }) {
    final current = getQuantity(profile, itemId);
    if (current <= 0) return profile;
    return addItem(profile, itemId, amount: -amount, maxStack: 99);
  }

  static ItemDefinition _fromJson(Map<String, dynamic> json) {
    return ItemDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      nameZh: json['name_zh'] as String,
      description: json['description'] as String,
      type: _parseType(json['type'] as String),
      maxStack: json['max_stack'] as int? ?? 99,
      price: json['price'] as int? ?? 50,
    );
  }

  static ItemType _parseType(String raw) {
    return switch (raw) {
      'potion' => ItemType.potion,
      'ether' => ItemType.ether,
      'rare_candy' => ItemType.rareCandy,
      _ => ItemType.potion,
    };
  }
}
