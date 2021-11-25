import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

@immutable
class FilledButtonThemeData with Diagnosticable {
  const FilledButtonThemeData({this.style});

  final ButtonStyle style;

  static FilledButtonThemeData lerp(
      FilledButtonThemeData a, FilledButtonThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return FilledButtonThemeData(
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
    return other is FilledButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class FilledButtonTheme extends InheritedTheme {
  const FilledButtonTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final FilledButtonThemeData data;

  static FilledButtonThemeData of(BuildContext context) {
    final FilledButtonTheme buttonTheme =
        context.dependOnInheritedWidgetOfExactType<FilledButtonTheme>();
    return buttonTheme?.data ?? FilledButtonThemeData(style: ButtonStyle());
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FilledButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(FilledButtonTheme oldWidget) =>
      data != oldWidget.data;
}

class FilledButton extends ButtonStyleButton {
  const FilledButton({
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

  factory FilledButton.icon({
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
  }) = _FilledButtonWithIcon;

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
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
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
    return FilledButtonTheme.of(context).style;
  }
}

class _FilledButtonWithIcon extends FilledButton {
  _FilledButtonWithIcon({
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
          child: _FilledButtonWithIconChild(icon: icon, label: label),
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

class _FilledButtonWithIconChild extends StatelessWidget {
  const _FilledButtonWithIconChild(
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
