import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import 'draggable_card.dart';

@immutable
class CardStyle with Diagnosticable {
  const CardStyle({
    this.elevation,
    this.stateLayerColor,
    this.shape,
    this.backgroundColor,
    this.shadowColor,
    this.elevationTintColor,
    this.foregroundColor,
    this.padding,
    this.interactiveMouseCursor,
    this.side,
    this.clipBehavior,
    this.animationDuration,
    this.enableFeedback,
    this.splashFactory,
    this.splashColor,
  });

  final MaterialStateProperty<MD3ElevationLevel?>? elevation;
  final MaterialStateProperty<Color?>? stateLayerColor;
  final MaterialStateProperty<OutlinedBorder?>? shape;
  final MaterialStateProperty<Color?>? backgroundColor;
  final MaterialStateProperty<Color?>? shadowColor;
  final MaterialStateProperty<Color?>? elevationTintColor;
  final MaterialStateProperty<Color?>? foregroundColor;
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;
  final MaterialStateProperty<MouseCursor?>? interactiveMouseCursor;
  final MaterialStateProperty<BorderSide?>? side;
  final Clip? clipBehavior;
  final Duration? animationDuration;
  final bool? enableFeedback;
  final InteractiveInkFeatureFactory? splashFactory;
  final Color? splashColor;

  static const double kHorizontalPadding = 16;
  static const double kMaxCardSpacing = 8;

  @override
  int get hashCode => Object.hashAll([
        elevation,
        stateLayerColor,
        shape,
        backgroundColor,
        shadowColor,
        elevationTintColor,
        foregroundColor,
        padding,
        interactiveMouseCursor,
        side,
        clipBehavior,
        animationDuration,
        enableFeedback,
        splashFactory,
        splashColor,
      ]);

  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! CardStyle) {
      return false;
    }
    return true &&
        elevation == other.elevation &&
        stateLayerColor == other.stateLayerColor &&
        shape == other.shape &&
        backgroundColor == other.backgroundColor &&
        shadowColor == other.shadowColor &&
        elevationTintColor == other.elevationTintColor &&
        foregroundColor == other.foregroundColor &&
        padding == other.padding &&
        interactiveMouseCursor == other.interactiveMouseCursor &&
        side == other.side &&
        clipBehavior == other.clipBehavior &&
        animationDuration == other.animationDuration &&
        enableFeedback == other.enableFeedback &&
        splashFactory == other.splashFactory &&
        splashColor == other.splashColor;
  }

  CardStyle copyWith({
    MaterialStateProperty<MD3ElevationLevel?>? elevation,
    MaterialStateProperty<Color?>? stateLayerColor,
    MaterialStateProperty<OutlinedBorder?>? shape,
    MaterialStateProperty<Color?>? backgroundColor,
    MaterialStateProperty<Color?>? shadowColor,
    MaterialStateProperty<Color?>? elevationTintColor,
    MaterialStateProperty<Color?>? foregroundColor,
    MaterialStateProperty<EdgeInsetsGeometry?>? padding,
    MaterialStateProperty<MouseCursor?>? interactiveMouseCursor,
    MaterialStateProperty<BorderSide?>? side,
    Clip? clipBehavior,
    Duration? animationDuration,
    bool? enableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
    Color? splashColor,
  }) =>
      CardStyle(
        elevation: elevation ?? this.elevation,
        stateLayerColor: stateLayerColor ?? this.stateLayerColor,
        shape: shape ?? this.shape,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        shadowColor: shadowColor ?? this.shadowColor,
        elevationTintColor: elevationTintColor ?? this.elevationTintColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        padding: padding ?? this.padding,
        interactiveMouseCursor:
            interactiveMouseCursor ?? this.interactiveMouseCursor,
        side: side ?? this.side,
        clipBehavior: clipBehavior ?? this.clipBehavior,
        animationDuration: animationDuration ?? this.animationDuration,
        enableFeedback: enableFeedback ?? this.enableFeedback,
        splashFactory: splashFactory ?? this.splashFactory,
        splashColor: splashColor ?? this.splashColor,
      );

  /// Returns a copy of this CardStyle where the non-null fields in [other]
  /// have replaced the corresponding null fields in this CardStyle.
  ///
  /// In other words, [other] is used to fill in unspecified (null) fields
  /// this CardStyle.
  CardStyle merge(
    CardStyle? other,
  ) {
    if (other == null) {
      return this;
    }
    return copyWith(
      elevation: elevation ?? other.elevation,
      stateLayerColor: stateLayerColor ?? other.stateLayerColor,
      shape: shape ?? other.shape,
      backgroundColor: backgroundColor ?? other.backgroundColor,
      shadowColor: shadowColor ?? other.shadowColor,
      elevationTintColor: elevationTintColor ?? other.elevationTintColor,
      foregroundColor: foregroundColor ?? other.foregroundColor,
      padding: padding ?? other.padding,
      interactiveMouseCursor:
          interactiveMouseCursor ?? other.interactiveMouseCursor,
      side: side ?? other.side,
      clipBehavior: clipBehavior ?? other.clipBehavior,
      animationDuration: animationDuration ?? other.animationDuration,
      enableFeedback: enableFeedback ?? other.enableFeedback,
      splashFactory: splashFactory ?? other.splashFactory,
      splashColor: splashColor ?? other.splashColor,
    );
  }

  static CardStyle? lerp(CardStyle? a, CardStyle? b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return CardStyle(
      elevation: _lerpMD3Elevation(a?.elevation, b?.elevation, t),
      stateLayerColor: _lerpProperties<Color?>(
          a?.stateLayerColor, b?.stateLayerColor, t, Color.lerp),
      shape: _lerpShapes(a?.shape, b?.shape, t),
      backgroundColor: _lerpProperties<Color?>(
          a?.backgroundColor, b?.backgroundColor, t, Color.lerp),
      shadowColor: _lerpProperties<Color?>(
          a?.shadowColor, b?.shadowColor, t, Color.lerp),
      elevationTintColor: _lerpProperties<Color?>(
          a?.elevationTintColor, b?.elevationTintColor, t, Color.lerp),
      foregroundColor: _lerpProperties<Color?>(
          a?.foregroundColor, b?.foregroundColor, t, Color.lerp),
      padding: _lerpProperties<EdgeInsetsGeometry?>(
          a?.padding, b?.padding, t, EdgeInsetsGeometry.lerp),
      interactiveMouseCursor:
          t < 0.5 ? a?.interactiveMouseCursor : b?.interactiveMouseCursor,
      side: _lerpSides(a?.side, b?.side, t),
      clipBehavior: t < 0.5 ? a?.clipBehavior : b?.clipBehavior,
      animationDuration: t < 0.5 ? a?.animationDuration : b?.animationDuration,
      enableFeedback: t < 0.5 ? a?.enableFeedback : b?.enableFeedback,
      splashFactory: t < 0.5 ? a?.splashFactory : b?.splashFactory,
      splashColor: Color.lerp(a?.splashColor, b?.splashColor, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<MaterialStateProperty<MD3ElevationLevel?>>(
            'elevation', elevation,
            defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'stateLayerColor', stateLayerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<OutlinedBorder?>>(
        'shape', shape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'backgroundColor', backgroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'shadowColor', shadowColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'elevationTintColor', elevationTintColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color?>>(
        'foregroundColor', foregroundColor,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<MaterialStateProperty<EdgeInsetsGeometry?>>(
            'padding', padding,
            defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor?>>(
        'interactiveMouseCursor', interactiveMouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<BorderSide?>>(
        'side', side,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>(
        'animationDuration', animationDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('enableFeedback', enableFeedback,
        defaultValue: null));
    properties.add(DiagnosticsProperty<InteractiveInkFeatureFactory>(
        'splashFactory', splashFactory,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('splashColor', splashColor,
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

  // Special case because BorderSide.lerp() doesn't support null arguments
  static MaterialStateProperty<MD3ElevationLevel?>? _lerpMD3Elevation(
    MaterialStateProperty<MD3ElevationLevel?>? a,
    MaterialStateProperty<MD3ElevationLevel?>? b,
    double t,
  ) {
    if (a == null && b == null) return null;
    return _LerpMD3Elevations(a, b, t);
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

class _LerpMD3Elevations implements MaterialStateProperty<MD3ElevationLevel?> {
  const _LerpMD3Elevations(this.a, this.b, this.t);

  final MaterialStateProperty<MD3ElevationLevel?>? a;
  final MaterialStateProperty<MD3ElevationLevel?>? b;
  final double t;

  @override
  MD3ElevationLevel? resolve(Set<MaterialState> states) {
    final resolvedA = a?.resolve(states);
    final resolvedB = b?.resolve(states);
    if (resolvedA == null && resolvedB == null) return null;
    if (resolvedA == null) {
      return MD3ElevationLevel.lerp(
        const MD3ElevationLevel.from(0, 0),
        resolvedB!,
        t,
      );
    }
    if (resolvedB == null) {
      return MD3ElevationLevel.lerp(
        resolvedA,
        const MD3ElevationLevel.from(0, 0),
        t,
      );
    }
    return MD3ElevationLevel.lerp(resolvedA, resolvedB, t);
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
