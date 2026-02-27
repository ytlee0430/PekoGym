import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ironmon/domain/training/beginner_calibration_service.dart';

/// Singleton [BeginnerCalibrationService] provider.
/// Stateless pure-Dart service — created once and reused.
final beginnerCalibrationServiceProvider =
    Provider<BeginnerCalibrationService>((ref) {
  return const BeginnerCalibrationService();
});
