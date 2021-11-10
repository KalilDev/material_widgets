import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:material_you/material_you.dart';

enum MD3FABColorScheme {
  primaryContainer,
  surface,
  secondary,
  tertiary,
}

class MD3FloatingActionButton extends ButtonStyleButton {
  final MD3FABColorScheme fabColorScheme;
  final bool isLowered;
  const MD3FloatingActionButton({
    Key key,
    this.fabColorScheme = MD3FABColorScheme.primaryContainer,
    this.isLowered = false,
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

  factory MD3FloatingActionButton.expanded({
    Key key,
    MD3FABColorScheme fabColorScheme,
    bool isLowered,
    bool isExpanded,
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
  }) = _ExpandedFAB;

  factory MD3FloatingActionButton.small({
    Key key,
    MD3FABColorScheme fabColorScheme,
    bool isLowered,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus,
    Clip clipBehavior,
    Widget child,
  }) = _SmallFAB;

  factory MD3FloatingActionButton.large({
    Key key,
    MD3FABColorScheme fabColorScheme,
    bool isLowered,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus,
    Clip clipBehavior,
    Widget child,
  }) = _LargeFAB;

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.all(8),
      const EdgeInsets.symmetric(horizontal: 8),
      const EdgeInsets.symmetric(horizontal: 4),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );

    final mouseCursor = _FabDefaultMouseCursor(
      SystemMouseCursors.click,
      SystemMouseCursors.forbidden,
    );

    final textTheme = context.textTheme;
    final scheme = context.colorScheme;
    final elevationTheme = context.elevation;
    final md3Elevation = _FabDefaultMD3Elevation(elevationTheme, isLowered);

    return ButtonStyle(
      textStyle: _FabDefaultTextStyle(textTheme),
      minimumSize: MaterialStateProperty.all(Size.zero),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      backgroundColor:
          _FabDefaultBackground(scheme, fabColorScheme, md3Elevation),
      foregroundColor:
          _FabDefaultForeground(scheme, fabColorScheme, md3Elevation),
      overlayColor: _FabDefaultOverlay(scheme, fabColorScheme, md3Elevation),
      shadowColor:
          ButtonStyleButton.allOrNull<Color>(context.monetTheme.neutral[0]),
      elevation: MaterialStateProperty.resolveWith(
        (states) => md3Elevation.resolve(states).value,
      ),
      padding:
          MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16)),
      fixedSize: MaterialStateProperty.all<Size>(Size.square(56)),
      side: ButtonStyleButton.allOrNull<BorderSide>(null),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)))),
      mouseCursor: mouseCursor,
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: Alignment.center,
      splashFactory: theme.splashFactory,
    );
  }

  @override
  ButtonStyle themeStyleOf(BuildContext context) {
    return MD3FloatingActionButtonTheme.of(context).style;
  }
}

@immutable
class MD3FloatingActionButtonThemeData with Diagnosticable {
  const MD3FloatingActionButtonThemeData({this.style});

  final ButtonStyle style;

  static MD3FloatingActionButtonThemeData lerp(
      MD3FloatingActionButtonThemeData a,
      MD3FloatingActionButtonThemeData b,
      double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return MD3FloatingActionButtonThemeData(
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
    return other is MD3FloatingActionButtonThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null));
  }
}

class MD3FloatingActionButtonTheme extends InheritedTheme {
  const MD3FloatingActionButtonTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final MD3FloatingActionButtonThemeData data;

  static MD3FloatingActionButtonThemeData of(BuildContext context) {
    final MD3FloatingActionButtonTheme buttonTheme = context
        .dependOnInheritedWidgetOfExactType<MD3FloatingActionButtonTheme>();
    return buttonTheme?.data ?? const MD3FloatingActionButtonThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MD3FloatingActionButtonTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MD3FloatingActionButtonTheme oldWidget) =>
      data != oldWidget.data;
}

@immutable
class _FabDefaultBackground extends MaterialStateProperty<Color> {
  _FabDefaultBackground(this.scheme, this.fabColorScheme, this.elevation);

  final MonetColorScheme scheme;
  final MD3FABColorScheme fabColorScheme;
  final MaterialStateProperty<MD3ElevationLevel> elevation;

  Color _resolvePrimaryContainer(Set<MaterialState> states) {
    return scheme.primaryContainer;
  }

  Color _resolveSurface(Set<MaterialState> states) {
    return elevation.resolve(states).overlaidColor(
          scheme.surface,
          MD3ElevationLevel.surfaceTint(scheme),
        );
  }

  Color _resolveSecondary(Set<MaterialState> states) {
    return scheme.secondaryContainer;
  }

  Color _resolveTertiary(Set<MaterialState> states) {
    return scheme.tertiaryContainer;
  }

  @override
  Color resolve(Set<MaterialState> states) {
    switch (fabColorScheme) {
      case MD3FABColorScheme.primaryContainer:
        return _resolvePrimaryContainer(states);
      case MD3FABColorScheme.surface:
        return _resolveSurface(states);
      case MD3FABColorScheme.secondary:
        return _resolveSecondary(states);
      case MD3FABColorScheme.tertiary:
        return _resolveTertiary(states);
      default:
        throw StateError('unreachable');
    }
  }
}

@immutable
class _FabDefaultForeground extends MaterialStateProperty<Color> {
  _FabDefaultForeground(this.scheme, this.fabColorScheme, this.elevation);

  final MonetColorScheme scheme;
  final MD3FABColorScheme fabColorScheme;
  final MaterialStateProperty<MD3ElevationLevel> elevation;

  Color _resolvePrimaryContainer(Set<MaterialState> states) {
    return scheme.onPrimaryContainer;
  }

  Color _resolveSurface(Set<MaterialState> states) {
    return scheme.primary;
  }

  Color _resolveSecondary(Set<MaterialState> states) {
    return scheme.onSecondaryContainer;
  }

  Color _resolveTertiary(Set<MaterialState> states) {
    return scheme.onTertiaryContainer;
  }

  @override
  Color resolve(Set<MaterialState> states) {
    switch (fabColorScheme) {
      case MD3FABColorScheme.primaryContainer:
        return _resolvePrimaryContainer(states);
      case MD3FABColorScheme.surface:
        return _resolveSurface(states);
      case MD3FABColorScheme.secondary:
        return _resolveSecondary(states);
      case MD3FABColorScheme.tertiary:
        return _resolveTertiary(states);
      default:
        throw StateError('unreachable');
    }
  }
}

@immutable
class _FabDefaultMD3Elevation extends MaterialStateProperty<MD3ElevationLevel> {
  _FabDefaultMD3Elevation(this.theme, this.lowered);

  final MD3ElevationTheme theme;
  final bool lowered;

  @override
  MD3ElevationLevel resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return lowered ? theme.level2 : theme.level4;
    }
    return lowered ? theme.level1 : theme.level3;
  }
}

@immutable
class _FabDefaultTextStyle extends MaterialStateProperty<TextStyle> {
  _FabDefaultTextStyle(this.textTheme);

  final MD3TextTheme textTheme;

  @override
  TextStyle resolve(Set<MaterialState> states) {
    return textTheme.labelLarge;
  }
}

@immutable
class _FabDefaultOverlay extends MaterialStateProperty<Color> {
  _FabDefaultOverlay(this.scheme, this.fabColorScheme, this.elevation);

  final MonetColorScheme scheme;
  final MD3FABColorScheme fabColorScheme;
  final MaterialStateProperty<MD3ElevationLevel> elevation;

  Color _resolvePrimaryContainer(Set<MaterialState> states) {
    return scheme.onPrimaryContainer;
  }

  Color _resolveSurface(Set<MaterialState> states) {
    return scheme.primary;
  }

  Color _resolveSecondary(Set<MaterialState> states) {
    return scheme.onSecondaryContainer;
  }

  Color _resolveTertiary(Set<MaterialState> states) {
    return scheme.onTertiaryContainer;
  }

  Color _resolveColor(Set<MaterialState> states) {
    switch (fabColorScheme) {
      case MD3FABColorScheme.primaryContainer:
        return _resolvePrimaryContainer(states);
      case MD3FABColorScheme.surface:
        return _resolveSurface(states);
      case MD3FABColorScheme.secondary:
        return _resolveSecondary(states);
      case MD3FABColorScheme.tertiary:
        return _resolveTertiary(states);
      default:
        throw StateError('unreachable');
    }
  }

  @override
  Color resolve(Set<MaterialState> states) {
    final color = _resolveColor(states);
    double opacity = 0.0;
    if (states.contains(MaterialState.hovered)) {
      opacity = 0.08;
    }
    if (states.contains(MaterialState.focused)) {
      opacity = 0.24;
    }
    if (states.contains(MaterialState.pressed)) {
      opacity = 0.24;
    }
    return color.withOpacity(opacity);
  }
}

@immutable
class _FabDefaultMouseCursor extends MaterialStateProperty<MouseCursor>
    with Diagnosticable {
  _FabDefaultMouseCursor(this.enabledCursor, this.disabledCursor);

  final MouseCursor enabledCursor;
  final MouseCursor disabledCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return disabledCursor;
    return enabledCursor;
  }
}

class _SmallFAB extends MD3FloatingActionButton {
  _SmallFAB({
    Key key,
    MD3FABColorScheme fabColorScheme = MD3FABColorScheme.primaryContainer,
    bool isLowered = false,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus,
    Clip clipBehavior,
    Widget child,
  }) : super(
          key: key,
          fabColorScheme: fabColorScheme,
          isLowered: isLowered,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: child,
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    return super.defaultStyleOf(context).copyWith(
          fixedSize: MaterialStateProperty.all(Size.square(40)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        );
  }
}

class _LargeFAB extends MD3FloatingActionButton {
  _LargeFAB({
    Key key,
    MD3FABColorScheme fabColorScheme = MD3FABColorScheme.primaryContainer,
    bool isLowered = false,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus,
    Clip clipBehavior,
    Widget child,
  }) : super(
          key: key,
          fabColorScheme: fabColorScheme,
          isLowered: isLowered,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: IconTheme.merge(
            data: IconThemeData(size: 36),
            child: child,
          ),
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    return super.defaultStyleOf(context).copyWith(
          fixedSize: MaterialStateProperty.all(Size.square(96)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
        );
  }
}

class _ExpandedFAB extends MD3FloatingActionButton {
  final bool isExpanded;
  _ExpandedFAB({
    Key key,
    bool isLowered = false,
    MD3FABColorScheme fabColorScheme = MD3FABColorScheme.primaryContainer,
    this.isExpanded = true,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus,
    Clip clipBehavior,
    Widget icon,
    @required Widget label,
  })  : assert(label != null),
        assert(isExpanded || icon != null),
        super(
          key: key,
          fabColorScheme: fabColorScheme,
          isLowered: isLowered,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: _ExpandedFabChild(
            isExpanded: isExpanded,
            icon: icon,
            label: label,
          ),
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final defaults = super.defaultStyleOf(context);

    return defaults.copyWith(
      fixedSize: MaterialStateProperty.all(Size(double.nan, 56)),
      // TODO: should be 80 according to the spec, but changing it with
      // isExpanded causes an jump, breaking the animation!!
      minimumSize: MaterialStateProperty.all(Size(56, 0)),
    );
  }
}

class _ExpandedFabChild extends StatefulWidget {
  const _ExpandedFabChild({
    Key key,
    @required this.isExpanded,
    @required this.label,
    @required this.icon,
  }) : super(key: key);

  final bool isExpanded;
  final Widget label;
  final Widget icon;

  @override
  State<_ExpandedFabChild> createState() => _ExpandedFabChildState();
}

class _ExpandedFabChildState extends State<_ExpandedFabChild>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.icon != null) widget.icon,
        Flexible(
          child: AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.centerLeft,
            child: widget.label == null || !widget.isExpanded
                ? SizedBox()
                : Padding(
                    padding:
                        EdgeInsets.only(left: widget.icon != null ? 12 : 0),
                    child: widget.label,
                  ),
          ),
        )
      ],
    );
  }
}
