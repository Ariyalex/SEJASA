import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Palette: Himmel (Frieren).
/// - primary           : baju Himmel
/// - primaryContainer  : rambut Himmel
/// - secondary         : mata Himmel (gelap)
/// - secondaryContainer: mata Himmel
/// - tertiary          : jubah Himmel (gelap)
/// - tertiaryContainer : jubah Himmel
///
/// Dark mode di-generate otomatis dari light scheme via `.toDark(...)`.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // Custom palette — Himmel (sesuai brief tugas UAS).
  static const _himmelColors = FlexSchemeColor(
    primary: Color(0xFF4D5B8C),           // East Bay — baju Himmel
    primaryContainer: Color(0xFFA8C6E2),  // Spindle — rambut Himmel
    secondary: Color(0xFF89957B),         // Battleship Gray — mata Himmel (gelap)
    secondaryContainer: Color(0xFFE0ECCF), // Kidnapper — mata Himmel
    tertiary: Color(0xFF99988E),          // Star Dust — jubah Himmel (gelap)
    tertiaryContainer: Color(0xFFE5E3D7), // Satin Linen — jubah Himmel
    appBarColor: Color(0xFFE0ECCF),
    error: Color(0xFFBA1A1A),             // Thunderbird
    errorContainer: Color(0xFFFFDAD6),    // Peach Schnapps
  );

  // The FlexColorScheme defined light mode ThemeData.
  static ThemeData light = FlexThemeData.light(
    colors: _himmelColors,
    usedColors: 7,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The FlexColorScheme defined dark mode ThemeData.
  // Computed from light scheme using defaultError and toDark() methods.
  static ThemeData dark = FlexThemeData.dark(
    colors: _himmelColors.defaultError.toDark(10, true),
    usedColors: 7,
    swapColors: true,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}
