import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

@immutable
class FilledTonalButtonThemeData with Diagnosticable {
  const FilledTonalButtonThemeData({this.style});

  final ButtonStyle style;

  static FilledTonalButtonThemeData lerp(
      FilledTonalButtonThemeData a, FilledTonalButtonThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return FilledTonalButtonThemeData(
      style: ButtonStyle.lerp(a?.style, b?.style, t),
    );
  }

  @override
  int get hashCode {
    return style.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is FilledTonalButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class FilledTonalButtonTheme extends InheritedTheme {
  const FilledTonalButtonTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final FilledTonalButtonThemeData data;

  static FilledTonalButtonThemeData of(BuildContext context) {
    final FilledTonalButtonTheme buttonTheme =
        context.dependOnInheritedWidgetOfExactType<FilledTonalButtonTheme>();
    return buttonTheme?.data ??
        FilledTonalButtonThemeData(style: ButtonStyle());
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FilledTonalButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledTonalButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class FilledTonalButton extends ButtonStyleButton {
  const FilledTonalButton({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    @required Widget child,
  }) : super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child,
        );

  factory FilledTonalButton.icon({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus,
    Clip clipBehavior,
    @required Widget icon,
    @required Widget label,
  }) = _FilledTonalButtonWithIcon;

  @override
  static ButtonStyle styleFrom({
    @required Color backgroundColor,
    @required Color foregroundColor,
    @required Color disabledColor,
    @required MD3StateLayerOpacityTheme stateLayerOpacityTheme,
    Color shadowColor,
    MaterialStateProperty<MD3ElevationLevel> md3Elevation,
    TextStyle labelStyle,
    MouseCursor disabledCursor,
    MouseCursor enabledCursor,
    VisualDensity visualDensity,
    MaterialTapTargetSize tapTargetSize,
    InteractiveInkFeatureFactory splashFactory,
    OutlinedBorder shape,
  }) {
    ArgumentError.checkNotNull(backgroundColor);
    ArgumentError.checkNotNull(foregroundColor);
    ArgumentError.checkNotNull(disabledColor);
    ArgumentError.checkNotNull(stateLayerOpacityTheme);

    return ButtonStyle(
      backgroundColor: MD3DisablableColor(
        backgroundColor,
        disabledColor: disabledColor,
        disabledOpacity: 0.12,
      ),
      foregroundColor: MD3DisablableColor(
        foregroundColor,
        disabledColor: disabledColor,
      ),
      shadowColor: ButtonStyleButton.allOrNull(shadowColor),
      elevation: md3Elevation?.value,
      textStyle: ButtonStyleButton.allOrNull(labelStyle),
      minimumSize: MaterialStateProperty.all(const Size(0, 40)),
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(40)),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      overlayColor: MD3StateOverlayColor(
        foregroundColor,
        stateLayerOpacityTheme,
      ),
      shape: ButtonStyleButton.allOrNull(shape),
      mouseCursor: MD3DisablableCursor(
        enabledCursor ?? SystemMouseCursors.click,
        disabledCursor ?? SystemMouseCursors.forbidden,
      ),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: Alignment.center,
      splashFactory: splashFactory,
    );
  }

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.symmetric(horizontal: 24),
      const EdgeInsets.symmetric(horizontal: 16),
      const EdgeInsets.symmetric(horizontal: 8),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );

    final scheme = context.colorScheme;
    final elevation = context.elevation;
    final md3Elevation =
        MD3MaterialStateElevation(elevation.level0, elevation.level1);

    return styleFrom(
      backgroundColor: scheme.secondaryContainer,
      foregroundColor: scheme.onSecondaryContainer,
      disabledColor: scheme.onSurface,
      shadowColor: theme.shadowColor,
      md3Elevation: md3Elevation,
      labelStyle: context.textTheme.labelLarge,
      stateLayerOpacityTheme: context.stateOverlayOpacity,
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      splashFactory: theme.splashFactory,
      shape: const StadiumBorder(),
    ).copyWith(
      padding: MaterialStateProperty.all(scaledPadding),
    );
  }

  @override
  ButtonStyle themeStyleOf(BuildContext context) {
    return FilledTonalButtonTheme.of(context).style;
  }
}

class _FilledTonalButtonWithIcon extends FilledTonalButton {
  _FilledTonalButtonWithIcon({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus,
    Clip clipBehavior,
    @required Widget icon,
    @required Widget label,
  })  : assert(icon != null),
        assert(label != null),
        super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: _FilledTonalButtonWithIconChild(icon: icon, label: label),
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsetsDirectional.fromSTEB(12, 0, 16, 0),
      const EdgeInsets.symmetric(horizontal: 8),
      const EdgeInsetsDirectional.fromSTEB(8, 0, 4, 0),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );
    return super.defaultStyleOf(context).copyWith(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(scaledPadding),
        );
  }
}

class _FilledTonalButtonWithIconChild extends StatelessWidget {
  const _FilledTonalButtonWithIconChild(
      {Key key, @required this.label, @required this.icon})
      : super(key: key);

  final Widget label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
    final double gap =
        scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, SizedBox(width: gap), Flexible(child: label)],
    );
  }
}
