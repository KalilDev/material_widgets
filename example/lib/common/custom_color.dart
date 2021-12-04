import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

const kYellowSeed = Color(0xFFf5f50c);
const kPinkSeed = Color(0xFFf50ced);
const kBlueSeed = Color(0xFF0cedf5);
const kDarkBlueSeed = Color(0xFF200cf5);
const kLimeSeed = Color(0xFF0cf527);
const kGreenSeed = Color(0xFF005448);
const kRedSeed = Color(0xFFFF0000);

CustomColorScheme schemeForSeed(BuildContext context, Color seed) {
  final customColorTheme = context.monetTheme.harmonizedCustomColorTheme(seed);
  return context.isDark ? customColorTheme.dark : customColorTheme.light;
}

const kCustomColors = [
  [null, 'Terciaria'],
  [kYellowSeed, 'Amarelo'],
  [kPinkSeed, 'Rosa'],
  [kBlueSeed, 'Azul'],
  [kDarkBlueSeed, 'Azul escuro'],
  [kLimeSeed, 'Verde lima'],
  [kGreenSeed, 'Verde escuro'],
  [kRedSeed, 'Vermelho'],
];

List<dynamic> customColorThemeFor(
  BuildContext context,
  bool harmonized,
  Color? color,
  String name,
) {
  CustomColorScheme colorScheme;
  if (color == null) {
    colorScheme = context.colorScheme.tertiaryScheme;
  } else {
    CustomColorTheme colorTheme;
    if (harmonized) {
      colorTheme = context.monetTheme.harmonizedCustomColorTheme(color);
    } else {
      final cam = Cam16.fromIntInViewingConditions(
        color.value,
        ViewingConditions.standard,
      );
      colorTheme = generateCustomColorThemeFrom(
        ColorTonalPalette.fromRaw(TonalPalette.of(cam.hue, cam.chroma)),
      );
    }
    colorScheme = context.isDark ? colorTheme.dark : colorTheme.light;
  }

  return [
    colorScheme,
    name,
  ];
}
