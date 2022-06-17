import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MD3SwitchStyle with Diagnosticable {
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final MaterialStateProperty<Color?>? stateLayerColor;
  final MaterialStateProperty<Color?>? foregroundColor;
  final MaterialStateProperty<BorderSide?>? trackBorder;
  final MaterialStateProperty<MouseCursor?>? mouseCursor;
  final MaterialStateProperty<OutlinedBorder?>? trackShape;
  final MaterialStateProperty<OutlinedBorder?>? thumbShape;
  final MaterialStateProperty<OutlinedBorder?>? stateLayerShape;
  final MaterialTapTargetSize? materialTapTargetSize;
  const MD3SwitchStyle({
    this.thumbColor,
    this.trackColor,
    this.stateLayerColor,
    this.foregroundColor,
    this.trackBorder,
    this.mouseCursor,
    this.trackShape,
    this.thumbShape,
    this.stateLayerShape,
    this.materialTapTargetSize,
  });

  @override
  int get hashCode => Object.hashAll([
        thumbColor,
        trackColor,
        stateLayerColor,
        foregroundColor,
        trackBorder,
        mouseCursor,
        trackShape,
        thumbShape,
        stateLayerShape,
        materialTapTargetSize,
      ]);

  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! MD3SwitchStyle) {
      return false;
    }
    return true &&
        thumbColor == other.thumbColor &&
        trackColor == other.trackColor &&
        stateLayerColor == other.stateLayerColor &&
        foregroundColor == other.foregroundColor &&
        trackBorder == other.trackBorder &&
        mouseCursor == other.mouseCursor &&
        trackShape == other.trackShape &&
        thumbShape == other.thumbShape &&
        stateLayerShape == other.stateLayerShape &&
        materialTapTargetSize == other.materialTapTargetSize;
  }

  MD3SwitchStyle copyWith({
    MaterialStateProperty<Color?>? thumbColor,
    MaterialStateProperty<Color?>? trackColor,
    MaterialStateProperty<Color?>? stateLayerColor,
    MaterialStateProperty<Color?>? foregroundColor,
    MaterialStateProperty<BorderSide?>? trackBorder,
    MaterialStateProperty<MouseCursor?>? mouseCursor,
    MaterialStateProperty<OutlinedBorder?>? trackShape,
    MaterialStateProperty<OutlinedBorder?>? thumbShape,
    MaterialStateProperty<OutlinedBorder?>? stateLayerShape,
    MaterialTapTargetSize? materialTapTargetSize,
  }) =>
      MD3SwitchStyle(
        thumbColor: thumbColor ?? this.thumbColor,
        trackColor: trackColor ?? this.trackColor,
        stateLayerColor: stateLayerColor ?? this.stateLayerColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        trackBorder: trackBorder ?? this.trackBorder,
        mouseCursor: mouseCursor ?? this.mouseCursor,
        trackShape: trackShape ?? this.trackShape,
        thumbShape: thumbShape ?? this.thumbShape,
        stateLayerShape: stateLayerShape ?? this.stateLayerShape,
        materialTapTargetSize:
            materialTapTargetSize ?? this.materialTapTargetSize,
      );

  /// Returns a copy of this MD3SwitchStyle where the non-null fields in [other]
  /// have replaced the corresponding null fields in this MD3SwitchStyle.
  ///
  /// In other words, [other] is used to fill in unspecified (null) fields
  /// this MD3SwitchStyle.
  MD3SwitchStyle merge(
    MD3SwitchStyle? other,
  ) {
    if (other == null) {
      return this;
    }
    return copyWith(
      thumbColor: thumbColor ?? other.thumbColor,
      trackColor: trackColor ?? other.trackColor,
      stateLayerColor: stateLayerColor ?? other.stateLayerColor,
      foregroundColor: foregroundColor ?? other.foregroundColor,
      trackBorder: trackBorder ?? other.trackBorder,
      mouseCursor: mouseCursor ?? other.mouseCursor,
      trackShape: trackShape ?? other.trackShape,
      thumbShape: thumbShape ?? other.thumbShape,
      stateLayerShape: stateLayerShape ?? other.stateLayerShape,
      materialTapTargetSize:
          materialTapTargetSize ?? other.materialTapTargetSize,
    );
  }

  static MD3SwitchStyle? lerp(MD3SwitchStyle? a, MD3SwitchStyle? b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return MD3SwitchStyle(
      thumbColor:
          _lerpProperties<Color?>(a?.thumbColor, b?.thumbColor, t, Color.lerp),
      trackColor:
          _lerpProperties<Color?>(a?.trackColor, b?.trackColor, t, Color.lerp),
      stateLayerColor: _lerpProperties<Color?>(
          a?.stateLayerColor, b?.stateLayerColor, t, Color.lerp),
      foregroundColor: _lerpProperties<Color?>(
          a?.foregroundColor, b?.foregroundColor, t, Color.lerp),
      trackBorder: _lerpSides(a?.trackBorder, b?.trackBorder, t),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      trackShape: _lerpShapes(a?.trackShape, b?.trackShape, t),
      thumbShape: _lerpShapes(a?.thumbShape, b?.thumbShape, t),
      stateLayerShape: _lerpShapes(a?.stateLayerShape, b?.stateLayerShape, t),
      materialTapTargetSize:
          t < 0.5 ? a?.materialTapTargetSize : b?.materialTapTargetSize,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'thumbColor', thumbColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'trackColor', trackColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'stateLayerColor', stateLayerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'foregroundColor', foregroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<BorderSide?>>(
        'trackBorder', trackBorder,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor?>>(
        'mouseCursor', mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<OutlinedBorder?>>(
        'trackShape', trackShape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<OutlinedBorder?>>(
        'thumbShape', thumbShape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<OutlinedBorder?>>(
        'stateLayerShape', stateLayerShape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>(
        'materialTapTargetSize', materialTapTargetSize,
        defaultValue: null));
  }

  static MaterialStateProperty<T?>? _lerpProperties<T>(
      MaterialStateProperty<T>? a,
      MaterialStateProperty<T>? b,
      double t,
      T? Function(T?, T?, double) lerpFunction) {
    // Avoid creating a _LerpProperties object for a common case.
    if (a == null && b == null) return null;
    return _LerpProperties<T>(a, b, t, lerpFunction);
  }

  static MaterialStateProperty<BorderSide?>? _lerpSides(
      MaterialStateProperty<BorderSide?>? a,
      MaterialStateProperty<BorderSide?>? b,
      double t) {
    if (a == null && b == null) return null;
    return _LerpSides(a, b, t);
  }

  // TODO(hansmuller): OutlinedBorder needs a lerp method - https://github.com/flutter/flutter/issues/60555.
  static MaterialStateProperty<OutlinedBorder?>? _lerpShapes(
      MaterialStateProperty<OutlinedBorder?>? a,
      MaterialStateProperty<OutlinedBorder?>? b,
      double t) {
    if (a == null && b == null) return null;
    return _LerpShapes(a, b, t);
  }
}

class _LerpProperties<T> implements MaterialStateProperty<T?> {
  const _LerpProperties(this.a, this.b, this.t, this.lerpFunction);

  final MaterialStateProperty<T>? a;
  final MaterialStateProperty<T>? b;
  final double t;
  final T? Function(T?, T?, double) lerpFunction;

  @override
  T? resolve(Set<MaterialState> states) {
    final T? resolvedA = a?.resolve(states);
    final T? resolvedB = b?.resolve(states);
    return lerpFunction(resolvedA, resolvedB, t);
  }
}

class _LerpSides implements MaterialStateProperty<BorderSide?> {
  const _LerpSides(this.a, this.b, this.t);

  final MaterialStateProperty<BorderSide?>? a;
  final MaterialStateProperty<BorderSide?>? b;
  final double t;

  @override
  BorderSide? resolve(Set<MaterialState> states) {
    final BorderSide? resolvedA = a?.resolve(states);
    final BorderSide? resolvedB = b?.resolve(states);
    if (resolvedA == null && resolvedB == null) return null;
    if (resolvedA == null)
      return BorderSide.lerp(
          BorderSide(width: 0, color: resolvedB!.color.withAlpha(0)),
          resolvedB,
          t);
    if (resolvedB == null)
      return BorderSide.lerp(resolvedA,
          BorderSide(width: 0, color: resolvedA.color.withAlpha(0)), t);
    return BorderSide.lerp(resolvedA, resolvedB, t);
  }
}

class _LerpShapes implements MaterialStateProperty<OutlinedBorder?> {
  const _LerpShapes(this.a, this.b, this.t);

  final MaterialStateProperty<OutlinedBorder?>? a;
  final MaterialStateProperty<OutlinedBorder?>? b;
  final double t;

  @override
  OutlinedBorder? resolve(Set<MaterialState> states) {
    final OutlinedBorder? resolvedA = a?.resolve(states);
    final OutlinedBorder? resolvedB = b?.resolve(states);
    return ShapeBorder.lerp(resolvedA, resolvedB, t) as OutlinedBorder?;
  }
}
