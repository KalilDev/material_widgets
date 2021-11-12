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
      backgroundColor: _FilledButtonDefaultBackground(scheme),
      foregroundColor: _FilledButtonDefaultForeground(scheme),
      shadowColor: MaterialStateProperty.all(theme.shadowColor),
      elevation: _FilledButtonDefaultElevation(elevation),
      textStyle: MaterialStateProperty.all(theme.textTheme.button),
      padding: MaterialStateProperty.all(scaledPadding),
      minimumSize: MaterialStateProperty.all(const Size(0, 40)),
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(40)),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      overlayColor: _FilledButtonDefaultOverlay(scheme),
      shape: MaterialStateProperty.all(const StadiumBorder()),
      mouseCursor: _FilledButtonDefaultMouseCursor(
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
    return FilledButtonTheme.of(context).style;
  }
}

@immutable
class _FilledButtonDefaultElevation extends MaterialStateProperty<double>
    with Diagnosticable {
  _FilledButtonDefaultElevation(this.elevation);

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
class _FilledButtonDefaultBackground extends MaterialStateProperty<Color>
    with Diagnosticable {
  _FilledButtonDefaultBackground(this.scheme);

  final MonetColorScheme scheme;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return scheme.onSurface;
    }
    return scheme.primary;
  }
}

@immutable
class _FilledButtonDefaultForeground extends MaterialStateProperty<Color>
    with Diagnosticable {
  _FilledButtonDefaultForeground(this.scheme);

  final MonetColorScheme scheme;

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return scheme.onSurface.withOpacity(0.38);
    }
    return scheme.onPrimary;
  }
}

@immutable
class _FilledButtonDefaultOverlay extends MaterialStateProperty<Color>
    with Diagnosticable {
  _FilledButtonDefaultOverlay(this.scheme);

  final MonetColorScheme scheme;

  @override
  Color resolve(Set<MaterialState> states) {
    final color = scheme.onPrimary;
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
class _FilledButtonDefaultMouseCursor extends MaterialStateProperty<MouseCursor>
    with Diagnosticable {
  _FilledButtonDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return disabledCursor;
    return enabledCursor;
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
