import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import 'package:shape_theme_switcher/shape_theme_switcher.dart';

class ThemeSwitcher extends StatelessWidget {
  final ThemeMode themeMode;
  final ThemeData highContrastTheme;
  final ThemeData highContrastDarkTheme;
  final ThemeData theme;
  final ThemeData darkTheme;
  final Widget/*!*/ child;
  const ThemeSwitcher({
    Key key,
    this.themeMode,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.theme,
    this.darkTheme,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Resolve which theme to use based on brightness and high contrast.
    final mode = themeMode ?? ThemeMode.system;
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final useDarkTheme = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && platformBrightness == Brightness.dark);
    final highContrast = MediaQuery.highContrastOf(context);
    ThemeData theme;

    if (useDarkTheme && highContrast && highContrastDarkTheme != null) {
      theme = highContrastDarkTheme;
    } else if (useDarkTheme && darkTheme != null) {
      theme = darkTheme;
    } else if (highContrast && highContrastTheme != null) {
      theme = highContrastTheme;
    }
    theme ??= this.theme ?? ThemeData.light();

    return ShapeThemeSwitcher(
      theme: theme,
      borderTween: ShapeBorderTween(
        begin: const WobblyBorder().toOutlinedBorder(),
        end: const WobblyBorder(initialAngle: pi / 4).toOutlinedBorder(),
      ),
      child: child,
      duration: Duration(milliseconds: 800),
    );
  }
}
