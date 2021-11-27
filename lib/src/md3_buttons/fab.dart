import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

enum MD3FABColorScheme {
  primary,
  surface,
  secondary,
  tertiary,
}

class MD3FloatingActionButton extends ButtonStyleButton {
  const MD3FloatingActionButton({
    Key? key,
    this.fabColorScheme = MD3FABColorScheme.primary,
    this.isLowered = false,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    this.colorScheme,
    required Widget? child,
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
    Key? key,
    bool isLowered,
    MD3FABColorScheme fabColorScheme,
    bool isExpanded,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    CustomColorScheme? colorScheme,
    Widget? icon,
    required Widget label,
  }) = _ExpandedFAB;

  const factory MD3FloatingActionButton.small({
    Key? key,
    MD3FABColorScheme fabColorScheme,
    bool isLowered,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    CustomColorScheme? colorScheme,
    Widget? child,
  }) = _SmallFAB;

  factory MD3FloatingActionButton.large({
    Key? key,
    MD3FABColorScheme fabColorScheme,
    bool isLowered,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    CustomColorScheme? colorScheme,
    required Widget child,
  }) = _LargeFAB;

  final MD3FABColorScheme fabColorScheme;
  final bool isLowered;
  final CustomColorScheme? colorScheme;

  CustomColorScheme _customColorFromFABScheme(BuildContext context) {
    final scheme = context.colorScheme;
    switch (fabColorScheme) {
      case MD3FABColorScheme.primary:
        return scheme.primaryScheme;
      case MD3FABColorScheme.surface:
        return CustomColorScheme(
          color: scheme.surface,
          onColor: scheme.primary,
          colorContainer: scheme.surface,
          onColorContainer: scheme.primary,
        );
      case MD3FABColorScheme.tertiary:
        return scheme.tertiaryScheme;
      case MD3FABColorScheme.secondary:
        return scheme.secondaryScheme;
      default:
        throw StateError('err');
    }
  }

  static ButtonStyle primaryStyle(
    BuildContext context, {
    Color? shadowColor,
    TextStyle? labelStyle,
    MouseCursor? enabledCursor,
    MouseCursor? disabledCursor,
    required MaterialStateProperty<MD3ElevationLevel> md3Elevation,
    bool? enableFeedback,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    InteractiveInkFeatureFactory? splashFactory,
    OutlinedBorder? shape,
  }) =>
      styleFrom(
        backgroundColor: context.colorScheme.primaryContainer,
        foregroundColor: context.colorScheme.onPrimaryContainer,
        stateLayerOpacityTheme: context.stateOverlayOpacity,
        shadowColor: shadowColor,
        labelStyle: labelStyle,
        enabledCursor: enabledCursor,
        disabledCursor: disabledCursor,
        md3Elevation: md3Elevation,
        enableFeedback: enableFeedback,
        visualDensity: visualDensity,
        tapTargetSize: tapTargetSize,
        splashFactory: splashFactory,
        shape: shape,
      );

  static ButtonStyle secondaryStyle(
    BuildContext context, {
    Color? shadowColor,
    TextStyle? labelStyle,
    MouseCursor? enabledCursor,
    MouseCursor? disabledCursor,
    required MaterialStateProperty<MD3ElevationLevel> md3Elevation,
    bool? enableFeedback,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    InteractiveInkFeatureFactory? splashFactory,
    OutlinedBorder? shape,
  }) =>
      styleFrom(
        backgroundColor: context.colorScheme.secondaryContainer,
        foregroundColor: context.colorScheme.onSecondaryContainer,
        stateLayerOpacityTheme: context.stateOverlayOpacity,
        shadowColor: shadowColor,
        labelStyle: labelStyle,
        enabledCursor: enabledCursor,
        disabledCursor: disabledCursor,
        md3Elevation: md3Elevation,
        enableFeedback: enableFeedback,
        visualDensity: visualDensity,
        tapTargetSize: tapTargetSize,
        splashFactory: splashFactory,
        shape: shape,
      );

  static ButtonStyle tertiaryStyle(
    BuildContext context, {
    Color? shadowColor,
    TextStyle? labelStyle,
    MouseCursor? enabledCursor,
    MouseCursor? disabledCursor,
    required MaterialStateProperty<MD3ElevationLevel> md3Elevation,
    bool? enableFeedback,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    InteractiveInkFeatureFactory? splashFactory,
    OutlinedBorder? shape,
  }) =>
      styleFrom(
        backgroundColor: context.colorScheme.tertiaryContainer,
        foregroundColor: context.colorScheme.onTertiaryContainer,
        stateLayerOpacityTheme: context.stateOverlayOpacity,
        shadowColor: shadowColor,
        labelStyle: labelStyle,
        enabledCursor: enabledCursor,
        disabledCursor: disabledCursor,
        md3Elevation: md3Elevation,
        enableFeedback: enableFeedback,
        visualDensity: visualDensity,
        tapTargetSize: tapTargetSize,
        splashFactory: splashFactory,
        shape: shape,
      );

  static ButtonStyle surfaceStyle(
    BuildContext context, {
    Color? shadowColor,
    TextStyle? labelStyle,
    MouseCursor? enabledCursor,
    MouseCursor? disabledCursor,
    required MaterialStateProperty<MD3ElevationLevel> md3Elevation,
    bool? enableFeedback,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    InteractiveInkFeatureFactory? splashFactory,
    OutlinedBorder? shape,
  }) =>
      styleFrom(
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.primary,
        tintColor: MD3ElevationLevel.surfaceTint(context.colorScheme),
        stateLayerOpacityTheme: context.stateOverlayOpacity,
        shadowColor: shadowColor,
        labelStyle: labelStyle,
        enabledCursor: enabledCursor,
        disabledCursor: disabledCursor,
        md3Elevation: md3Elevation,
        enableFeedback: enableFeedback,
        visualDensity: visualDensity,
        tapTargetSize: tapTargetSize,
        splashFactory: splashFactory,
        shape: shape,
      );

  static ButtonStyle styleFrom({
    required Color backgroundColor,
    required Color foregroundColor,
    required MD3StateLayerOpacityTheme stateLayerOpacityTheme,
    Color? tintColor,
    Color? shadowColor,
    TextStyle? labelStyle,
    MouseCursor? enabledCursor,
    MouseCursor? disabledCursor,
    required MaterialStateProperty<MD3ElevationLevel> md3Elevation,
    bool? enableFeedback,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    InteractiveInkFeatureFactory? splashFactory,
    OutlinedBorder? shape,
  }) {
    ArgumentError.checkNotNull(backgroundColor);
    ArgumentError.checkNotNull(foregroundColor);
    ArgumentError.checkNotNull(stateLayerOpacityTheme);
    if (tintColor != null) {
      ArgumentError.checkNotNull(md3Elevation, 'md3Elevation');
    }

    return ButtonStyle(
      textStyle: ButtonStyleButton.allOrNull(labelStyle),
      minimumSize: MaterialStateProperty.all(Size.zero),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      backgroundColor: MD3ElevationTintableColor(
        backgroundColor,
        tintColor!,
        md3Elevation,
      ),
      foregroundColor: MaterialStateProperty.all(foregroundColor),
      overlayColor: MD3StateOverlayColor(
        foregroundColor,
        stateLayerOpacityTheme,
      ),
      shadowColor: ButtonStyleButton.allOrNull(shadowColor),
      elevation: md3Elevation?.value,
      padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
      fixedSize: MaterialStateProperty.all(const Size.square(56)),
      shape: ButtonStyleButton.allOrNull(shape),
      mouseCursor: MD3DisablableCursor(
        enabledCursor ?? SystemMouseCursors.click,
        disabledCursor ?? SystemMouseCursors.forbidden,
      ),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: enableFeedback,
      splashFactory: splashFactory,
      alignment: Alignment.center,
    );
  }

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    if (colorScheme != null && fabColorScheme != MD3FABColorScheme.primary) {
      throw StateError('You can only use one of MD3FABColorScheme or'
          ' MD3FloatingActionButton.colorScheme to theme yor FAB!');
    }
    final color = colorScheme ?? _customColorFromFABScheme(context);
    final elevationTheme = context.elevation;

    final ThemeData theme = Theme.of(context);

    return styleFrom(
      backgroundColor: color.colorContainer,
      foregroundColor: color.onColorContainer,
      labelStyle: context.textTheme.labelLarge,
      tintColor: fabColorScheme == MD3FABColorScheme.surface
          ? MD3ElevationLevel.surfaceTint(context.colorScheme)
          : null,
      stateLayerOpacityTheme: context.stateOverlayOpacity,
      md3Elevation: MD3MaterialStateElevation(
        isLowered ? elevationTheme.level1 : elevationTheme.level2,
        isLowered ? elevationTheme.level3 : elevationTheme.level4,
      ),
      shadowColor: Colors.black,
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      splashFactory: theme.splashFactory,
      enableFeedback: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }

  @override
  ButtonStyle? themeStyleOf(BuildContext context) {
    return MD3FloatingActionButtonTheme.of(context).style;
  }
}

@immutable
class MD3FloatingActionButtonThemeData with Diagnosticable {
  const MD3FloatingActionButtonThemeData({this.style});

  final ButtonStyle? style;

  static MD3FloatingActionButtonThemeData? lerp(
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
    Key? key,
    required this.data,
    required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final MD3FloatingActionButtonThemeData data;

  static MD3FloatingActionButtonThemeData of(BuildContext context) {
    final MD3FloatingActionButtonTheme? buttonTheme = context
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

class _SmallFAB extends MD3FloatingActionButton {
  const _SmallFAB({
    Key? key,
    MD3FABColorScheme fabColorScheme = MD3FABColorScheme.primary,
    bool isLowered = false,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    CustomColorScheme? colorScheme,
    Widget? child,
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
          colorScheme: colorScheme,
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
    Key? key,
    MD3FABColorScheme fabColorScheme = MD3FABColorScheme.primary,
    bool isLowered = false,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    CustomColorScheme? colorScheme,
    required Widget child,
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
          colorScheme: colorScheme,
          child: IconTheme.merge(
            data: const IconThemeData(size: 36),
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
  _ExpandedFAB({
    Key? key,
    bool isLowered = false,
    MD3FABColorScheme fabColorScheme = MD3FABColorScheme.primary,
    this.isExpanded = true,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    CustomColorScheme? colorScheme,
    Widget? icon,
    required Widget label,
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
          colorScheme: colorScheme,
          child: _ExpandedFabChild(
            isExpanded: isExpanded,
            icon: icon,
            label: label,
          ),
        );
  final bool isExpanded;

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
    Key? key,
    required this.isExpanded,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final bool isExpanded;
  final Widget label;
  final Widget? icon;

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
        if (widget.icon != null) widget.icon!,
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
