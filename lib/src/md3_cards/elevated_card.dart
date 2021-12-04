import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import 'card_style.dart';
import 'card_style_card.dart';

class ElevatedCard extends CardStyleCard {
  const ElevatedCard({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    FocusNode? focusNode,
    CardStyle? style,
    required Widget child,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          focusNode: focusNode,
          style: style,
          child: child,
        );

  static CardStyle styleFrom({
    Color? backgroundColor,
    Color? backgroundTintColor,
    Color? foregroundColor,
    MaterialStateProperty<MD3ElevationLevel>? elevation,
    MD3StateLayerOpacityTheme? stateLayerOpacity,
    Color? shadowColor,
    EdgeInsetsGeometry? padding,
    OutlinedBorder? shape,
    Clip? clipBehavior,
    Duration? animationDuration,
    bool? enableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    if (stateLayerOpacity != null) {
      ArgumentError.checkNotNull(foregroundColor, 'foregroundColor');
    }
    return CardStyle(
      backgroundColor: ButtonStyleButton.allOrNull(backgroundColor),
      elevation: elevation,
      interactiveMouseCursor:
          MaterialStateProperty.all(SystemMouseCursors.click),
      shadowColor: ButtonStyleButton.allOrNull(shadowColor),
      stateLayerColor: stateLayerOpacity == null
          ? null
          : MD3StateOverlayColor(
              foregroundColor!,
              stateLayerOpacity,
            ),
      elevationTintColor: ButtonStyleButton.allOrNull(backgroundTintColor),
      foregroundColor: ButtonStyleButton.allOrNull(foregroundColor),
      shape: ButtonStyleButton.allOrNull(shape),
      padding: ButtonStyleButton.allOrNull(padding),
      clipBehavior: clipBehavior ?? Clip.none,
      animationDuration: animationDuration ?? kThemeChangeDuration,
      enableFeedback: enableFeedback ?? true,
      splashFactory: splashFactory,
    );
  }

  @override
  CardStyle defaultStyleOf(BuildContext context) {
    final theme = context.theme;
    final scheme = context.colorScheme;
    final elevation = context.elevation;
    return styleFrom(
      backgroundColor: scheme.surface,
      backgroundTintColor: scheme.primary,
      foregroundColor: scheme.onSurface,
      elevation: MD3MaterialStateElevation(
        elevation.level1,
        elevation.level2,
        dragged: elevation.level3,
      ),
      stateLayerOpacity: context.stateOverlayOpacity,
      shadowColor: theme.shadowColor,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      splashFactory: theme.splashFactory,
    );
  }

  @override
  CardStyle themeStyleOf(BuildContext context) =>
      ElevatedCardTheme.of(context).style ?? CardStyle();
}

@immutable
class ElevatedCardThemeData with Diagnosticable {
  const ElevatedCardThemeData({this.style});

  final CardStyle? style;

  /*static ElevatedCardThemeData lerp(
      ElevatedCardThemeData a, ElevatedCardThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return ElevatedCardThemeData(
      style: CardStyle.lerp(a?.style, b?.style, t),
    );
  }*/

  @override
  int get hashCode {
    return style.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ElevatedCardThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<CardStyle>('style', style, defaultValue: null),
    );
  }
}

class ElevatedCardTheme extends InheritedTheme {
  const ElevatedCardTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final ElevatedCardThemeData data;

  static ElevatedCardThemeData of(BuildContext context) {
    final ElevatedCardTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<ElevatedCardTheme>();
    return buttonTheme?.data ?? const ElevatedCardThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ElevatedCardTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(ElevatedCardTheme oldWidget) =>
      data != oldWidget.data;
}
