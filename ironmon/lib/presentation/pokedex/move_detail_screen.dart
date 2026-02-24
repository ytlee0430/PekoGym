import 'package:flutter/material.dart';

/// Move detail screen placeholder — 完整實作於 Story 5.2
class MoveDetailScreen extends StatelessWidget {
  /// Creates [MoveDetailScreen] for the given [moveId]
  const MoveDetailScreen({required this.moveId, super.key});

  /// The move identifier from the route parameter
  final String moveId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Move: $moveId')),
    );
  }
}
