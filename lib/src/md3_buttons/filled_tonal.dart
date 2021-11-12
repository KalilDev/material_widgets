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
  ButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.symmetric(horizontal: 24),
      const EdgeInsets.symmetric(horizontal: 16),
      const EdgeInsets.symmetric(horizontal: 8),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );

    final scheme = context.colorScheme;
    final elevation = context.elevation;

    return ButtonStyle(
      backgroundColor: _FilledTonalButtonDefaultBackground(scheme),
      foregroundColor: _FilledTonalButtonDefaultForeground(scheme),
      shadowColor: MaterialStateProperty.all(theme.shadowColor),
      elevation: _FilledTonalButtonDefaultElevation(elevation),
      textStyle: MaterialStateProperty.all(theme.textTheme.button),
      padding: MaterialStateProperty.all(scaledPadding),
      minimumSize: MaterialStateProperty.all(const Size(0, 40)),
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(40)),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      overlayColor: _FilledTonalButtonDefaultOverlay(scheme),
      shape: MaterialStateProperty.all(const StadiumBorder()),
      mouseCursor: _FilledTonalButtonDefaultMouseCursor(
          SystemMouseCursors.click, SystemMouseCursors.forbidden),
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: Alignment.center,
      splashFactory: InkRipple.splashFactory,
    );
  }

  @override
  ButtonStyle themeStyleOf(BuildContext context) {
    return FilledTonalButtonTheme.of(context).style;
  }
}

@immutable
class _FilledTonalButtonDefaultElevation extends MaterialStateProperty<double>
    with Diagnosticable {
  _FilledTonalButtonDefaultElevation(this.elevation);

  final MD3ElevationTheme elevation;

  @override
  double resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return elevation.level1.value;
    }
    return elevation.level0.value;
  }
}

@immutable
class _FilledTonalButtonDefaultBackground extends MaterialStateProperty<Color>
    with Diagnosticable {
  _FilledTonalButtonDefaultBackground(this.scheme);

  final MonetColorScheme scheme;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return scheme.onSurface.withOpacity(0.12);
    }

    return scheme.secondaryContainer;
  }
}

@immutable
class _FilledTonalButtonDefaultForeground extends MaterialStateProperty<Color>
    with Diagnosticable {
  _FilledTonalButtonDefaultForeground(this.scheme);

  final MonetColorScheme scheme;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return scheme.onSurface.withOpacity(0.38);
    }
    return scheme.onSecondaryContainer;
  }
}

@immutable
class _FilledTonalButtonDefaultOverlay extends MaterialStateProperty<Color>
    with Diagnosticable {
  _FilledTonalButtonDefaultOverlay(this.scheme);

  final MonetColorScheme scheme;

  @override
  Color resolve(Set<MaterialState> states) {
    final color = scheme.onSecondaryContainer;
    if (states.contains(MaterialState.hovered)) {
      return color.withOpacity(0.08);
    }
    if (states.contains(MaterialState.focused)) {
      return color.withOpacity(0.24);
    }
    if (states.contains(MaterialState.pressed)) {
      return color.withOpacity(0.24);
    }

    return Colors.transparent;
  }
}

@immutable
class _FilledTonalButtonDefaultMouseCursor
    extends MaterialStateProperty<MouseCursor> with Diagnosticable {
  _FilledTonalButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return disabledCursor;
    return enabledCursor;
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
