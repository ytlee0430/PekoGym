import 'package:flutter/material.dart';
import 'package:ironmon/presentation/shared/design_tokens.dart';

/// IronMon dark pixel theme built on Material 3.
///
/// Uses [IronMonColors] design tokens mapped to Material 3
/// color roles. Component themes are overridden for the
/// pixel-RPG aesthetic.
///
/// Reference: UX Design Specification — Design System Foundation
abstract final class IronMonTheme {
  /// Dark theme for the IronMon app.
  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      surface: IronMonColors.surface,
      surfaceContainerHighest: IronMonColors.surfaceVariant,
      primary: IronMonColors.primary,
      onPrimary: IronMonColors.onPrimary,
      secondary: IronMonColors.secondary,
      onSecondary: IronMonColors.surface,
      error: IronMonColors.error,
      onError: IronMonColors.onPrimary,
      onSurface: IronMonColors.onSurface,
      onSurfaceVariant: IronMonColors.onSurfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: IronMonColors.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: IronMonColors.primary,
          foregroundColor: IronMonColors.onPrimary,
          minimumSize: const Size(
            double.infinity,
            IronMonSizes.battleButton,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              IronMonSizes.cardRadius,
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: IronMonColors.surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            IronMonSizes.cardRadius,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: IronMonSpacing.xs,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: IronMonColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: IronMonColors.primary,
        inactiveTrackColor:
            IronMonColors.onSurfaceVariant.withValues(
          alpha: 0.3,
        ),
        thumbColor: IronMonColors.primary,
        overlayColor: IronMonColors.primary.withValues(
          alpha: 0.2,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: IronMonColors.surface,
        indicatorColor: IronMonColors.primary.withValues(
          alpha: 0.2,
        ),
        surfaceTintColor: Colors.transparent,
        labelTextStyle:
            WidgetStateProperty.all(
          const TextStyle(
            fontSize: 12,
            color: IronMonColors.onSurface,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: IronMonColors.surface,
        foregroundColor: IronMonColors.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: IronMonColors.surfaceVariant,
        selectedColor: IronMonColors.primary.withValues(
          alpha: 0.2,
        ),
        labelStyle: const TextStyle(
          color: IronMonColors.onSurface,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            IronMonSizes.barRadius,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
