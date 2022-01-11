import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

extension ColorMaterialState on Color {
  MaterialStateColor toMaterialState() {
    final self = this;
    return self is MaterialStateColor
        ? self
        : MaterialStateColor.resolveWith((_) => this);
  }
}

extension MaterialStatePropertyColor on MaterialStateProperty<Color> {
  MaterialStateColor cast() {
    final self = this;
    return self is MaterialStateColor
        ? self
        : MaterialStateColor.resolveWith(resolve);
  }
}

extension BorderSideMaterialState on BorderSide {
  MaterialStateBorderSide toMaterialState() {
    final self = this;
    return self is MaterialStateBorderSide
        ? self
        : MaterialStateBorderSide.resolveWith((_) => this);
  }
}

extension MaterialStatePropertyBorderSide on MaterialStateProperty<BorderSide> {
  MaterialStateBorderSide cast() {
    final self = this;
    return self is MaterialStateBorderSide
        ? self as MaterialStateBorderSide
        : MaterialStateBorderSide.resolveWith(resolve);
  }
}

extension MD3ElevationLevelMaterialState on MD3ElevationLevel {
  MD3MaterialStateElevation toMaterialState() {
    final self = this;
    return self is MD3MaterialStateElevation
        ? self
        : MD3MaterialStateElevation.resolveWith((_) => this);
  }
}

extension MaterialStatePropertyMD3ElevationLevel
    on MaterialStateProperty<MD3ElevationLevel> {
  MD3MaterialStateElevation cast() {
    final self = this;
    return self is MD3MaterialStateElevation
        ? self
        : MD3MaterialStateElevation.resolveWith(resolve);
  }
}

extension MonadicMaterialStateProperty<T> on MaterialStateProperty<T> {
  MaterialStateProperty<T1> map<T1>(T1 Function(T) fn) =>
      MaterialStateProperty.resolveWith((states) => fn(resolve(states)));
  MaterialStateProperty<T1> bind<T1>(
    MaterialStateProperty<T1> Function(T) fn,
  ) =>
      MaterialStateProperty.resolveWith(
        (states) => runMaterialStateProperty(fn(resolve(states)), states),
      );
}

T runMaterialStateProperty<T>(
  MaterialStateProperty<T> value,
  Set<MaterialState> states,
) =>
    value.resolve(states);
