import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/src/card/card_style_card.dart';
import 'package:material_you/material_you.dart';

class FilledCard extends CardStyleCard {
  const FilledCard({
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
    Color? foregroundColor,
    MaterialStateProperty<MD3ElevationLevel>? elevation,
    MD3StateLayerOpacityTheme? stateLayerOpacity,
    Color? shadowColor,
    EdgeInsetsGeometry? padding,
    OutlinedBorder? shape,
  }) {
    if (stateLayerOpacity != null) {
      ArgumentError.checkNotNull(foregroundColor, 'foregroundColor');
    }
    return CardStyle(
      backgroundColor: ButtonStyleButton.allOrNull(backgroundColor),
      elevation: elevation,
      mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
      shadowColor: ButtonStyleButton.allOrNull(shadowColor),
      stateLayerColor: stateLayerOpacity == null
          ? null
          : MD3StateOverlayColor(
              foregroundColor!,
              stateLayerOpacity,
            ),
      foregroundColor: ButtonStyleButton.allOrNull(foregroundColor),
      shape: ButtonStyleButton.allOrNull(shape),
      padding: ButtonStyleButton.allOrNull(padding),
    );
  }

  @override
  CardStyle defaultStyleOf(BuildContext context) {
    final theme = context.theme;
    final scheme = context.colorScheme;
    final elevation = context.elevation;
    return styleFrom(
      backgroundColor: scheme.surfaceVariant,
      foregroundColor: scheme.onSurface,
      elevation: MD3MaterialStateElevation(
        elevation.level0,
        elevation.level1,
        focused: elevation.level1,
        dragged: elevation.level3,
      ),
      stateLayerOpacity: context.stateOverlayOpacity,
      shadowColor: theme.shadowColor,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  CardStyle themeStyleOf(BuildContext context) =>
      FilledCardTheme.of(context).style ?? CardStyle();
}

@immutable
class FilledCardThemeData with Diagnosticable {
  const FilledCardThemeData({this.style});

  final CardStyle? style;

  /*static FilledCardThemeData lerp(
      FilledCardThemeData a, FilledCardThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return FilledCardThemeData(
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
    return other is FilledCardThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<CardStyle>('style', style, defaultValue: null),
    );
  }
}

class FilledCardTheme extends InheritedTheme {
  const FilledCardTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final FilledCardThemeData data;

  static FilledCardThemeData of(BuildContext context) {
    final FilledCardTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<FilledCardTheme>();
    return buttonTheme?.data ?? const FilledCardThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FilledCardTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledCardTheme oldWidget) => data != oldWidget.data;
}
