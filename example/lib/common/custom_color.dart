import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

const kCustomColors = [
  [null, 'Terciaria'],
  [Color(0xFFf5f50c), 'Amarelo'],
  [Color(0xFFf50ced), 'Rosa'],
  [Color(0xFF0cedf5), 'Azul'],
  [Color(0xFF200cf5), 'Azul escuro'],
  [Color(0xFF0cf527), 'Verde lima'],
  [Color(0xFF005448), 'Verde escuro'],
  [Color(0xFFFF0000), 'Vermelho'],
];

List<dynamic> customColorThemeFor(
  BuildContext context,
  bool harmonized,
  Color color,
  String/*!*/ name,
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
