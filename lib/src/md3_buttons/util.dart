import 'package:flutter/material.dart';
import 'package:flutter_monet_theme/flutter_monet_theme.dart';

extension MD3MaterialStateElevationE
    on MaterialStateProperty<MD3ElevationLevel> {
  MaterialStateProperty<double> get value =>
      MaterialStateProperty.resolveWith((states) => resolve(states).value);
}

@immutable
class MD3ElevationTintableColor extends MaterialStateProperty<Color> {
  MD3ElevationTintableColor(
    this.color,
    this.tintColor,
    this.elevation,
  );

  final Color color;
  final Color tintColor;
  final MaterialStateProperty<MD3ElevationLevel> elevation;

  @override
  Color resolve(Set<MaterialState> states) {
    if (tintColor != null) {
      return elevation.resolve(states).overlaidColor(
            color,
            tintColor,
          );
    }
    return color;
  }
}
