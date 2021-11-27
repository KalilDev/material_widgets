import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

import 'utils.dart';

@immutable
class MD3ChipThemeData with Diagnosticable {
  const MD3ChipThemeData({this.style});

  final ButtonStyle? style;

  static MD3ChipThemeData? lerp(
      MD3ChipThemeData a, MD3ChipThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return MD3ChipThemeData(
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
    return other is MD3ChipThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ButtonStyle>('style', style, defaultValue: null),
    );
  }
}

class MD3ChipTheme extends InheritedTheme {
  const MD3ChipTheme({
    Key? key,
    required this.data,
    required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final MD3ChipThemeData data;

  static MD3ChipThemeData of(BuildContext context) {
    final MD3ChipTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MD3ChipTheme>();
    return buttonTheme?.data ?? const MD3ChipThemeData(style: ButtonStyle());
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MD3ChipTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MD3ChipTheme oldWidget) => data != oldWidget.data;
}

class ChipStyle {
  ChipStyle({
    this.backgroundColor,
    this.backgroundTintColor,
    this.labelColor,
    this.stateLayerColor,
    this.borderSide,
    this.md3Elevation,
  });

  final MaterialStateProperty<Color>? backgroundColor;
  final MaterialStateProperty<Color>? backgroundTintColor;
  final MaterialStateProperty<Color>? labelColor;
  final MaterialStateProperty<Color>? stateLayerColor;
  final MaterialStateProperty<BorderSide>? borderSide;
  final MaterialStateProperty<MD3ElevationLevel>? md3Elevation;

  static const double paddingBetweenElements = 8.0;

  ChipStyle merge(ChipStyle other) => ChipStyle(
        backgroundColor: other.backgroundColor ?? backgroundColor,
        backgroundTintColor: other.backgroundTintColor ?? backgroundTintColor,
        labelColor: other.labelColor ?? labelColor,
        stateLayerColor: other.stateLayerColor ?? stateLayerColor,
        borderSide: other.borderSide ?? borderSide,
        md3Elevation: other.md3Elevation ?? md3Elevation,
      );

  ChipStyle copyWith({
    MaterialStateProperty<Color>? backgroundColor,
    MaterialStateProperty<Color>? backgroundTintColor,
    MaterialStateProperty<Color>? labelColor,
    MaterialStateProperty<Color>? stateLayerColor,
    MaterialStateProperty<BorderSide>? borderSide,
    MaterialStateProperty<MD3ElevationLevel>? md3Elevation,
  }) =>
      ChipStyle(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundTintColor: backgroundTintColor ?? this.backgroundTintColor,
        labelColor: labelColor ?? this.labelColor,
        stateLayerColor: stateLayerColor ?? this.stateLayerColor,
        borderSide: borderSide ?? this.borderSide,
        md3Elevation: md3Elevation ?? this.md3Elevation,
      );

  static ChipStyle selected({
    required Color backgroundColor,
    required Color foregroundColor,
    Color? disabledColor,
    MaterialStateProperty<MD3ElevationLevel>? md3elevation,
  }) {
    final background = MD3DisablableColor(
      backgroundColor,
      disabledColor: disabledColor,
      disabledOpacity: 0.12,
    );
    final foreground = MD3DisablableColor(
      foregroundColor,
      disabledColor: disabledColor,
    );
    return ChipStyle(
      backgroundColor: background,
      backgroundTintColor: null,
      labelColor: foreground,
      stateLayerColor: ButtonStyleButton.allOrNull(foregroundColor),
      borderSide: null,
      md3Elevation: md3elevation,
    );
  }

  static ChipStyle normal({
    required Color backgroundColor,
    Color? backgroundTintColor,
    required Color foregroundColor,
    Color? disabledColor,
    required Color outlineColor,
    required double outlineWidth,
    MaterialStateProperty<MD3ElevationLevel>? md3elevation,
  }) {
    final hasOutline = outlineWidth <= 0.0;
    final background = MD3DisablableColor(
      backgroundColor,
      disabledColor: disabledColor,
      disabledOpacity: hasOutline ? 0 : 0.12,
    );
    final foreground = MD3DisablableColor(
      foregroundColor,
      disabledColor: disabledColor,
    );
    final outline = MD3DisablableColor(
      outlineColor,
      disabledOpacity: 0.0,
    ).map(
      (outlineColor) => BorderSide(
        color: outlineColor,
        width: outlineWidth,
      ),
    );
    return ChipStyle(
      backgroundColor: background,
      backgroundTintColor: ButtonStyleButton.allOrNull(backgroundTintColor),
      labelColor: foreground,
      stateLayerColor: ButtonStyleButton.allOrNull(foregroundColor),
      borderSide: hasOutline ? outline : null,
      md3Elevation: md3elevation,
    );
  }

  static MD3MaterialStateElevation elevatedElevation(
    MD3ElevationTheme elevation,
  ) =>
      MD3MaterialStateElevation(
        elevation.level1,
        elevation.level2,
        disabled: elevation.level0,
        focused: elevation.level1,
        dragged: elevation.level4,
      );
  static MD3MaterialStateElevation loweredElevation(
    MD3ElevationTheme elevation,
  ) =>
      MD3DraggableElevation(
        elevation.level0,
        elevation.level4,
      );
  static MD3MaterialStateElevation elevationFor(
    MD3ElevationTheme elevation, {
    required bool isElevated,
  }) =>
      isElevated ? elevatedElevation(elevation) : loweredElevation(elevation);

  static ChipStyle chipStyleFor(
    MonetColorScheme scheme,
    MD3ElevationTheme elevation, {
    required bool elevated,
    required bool selected,
  }) {
    final md3Elevation = elevationFor(
      elevation,
      isElevated: elevated,
    );

    if (selected) {
      return ChipStyle.selected(
        backgroundColor: scheme.secondaryContainer,
        foregroundColor: scheme.onSecondaryContainer,
        disabledColor: scheme.onSurface,
        md3elevation: md3Elevation,
      );
    }
    return ChipStyle.normal(
      backgroundColor: scheme.surface,
      backgroundTintColor: MD3ElevationLevel.surfaceTint(scheme),
      disabledColor: scheme.onSurface,
      foregroundColor: scheme.onSurfaceVariant,
      outlineColor: scheme.outline,
      outlineWidth: elevated ? 1.0 : 0.0,
      md3elevation: md3Elevation,
    );
  }

  ButtonStyle toButtonStyle(MD3StateLayerOpacityTheme stateLayerOpacityTheme) {
    final MaterialStateProperty<Color>? background = backgroundTintColor != null
        ? MD3ElevationTintableColor(
            backgroundColor!.cast(),
            backgroundTintColor!.cast(),
            md3Elevation!,
          )
        : backgroundColor;
    final foregroundColor = labelColor;
    final side = borderSide;

    return ButtonStyle(
      side: side,
      backgroundColor: background,
      foregroundColor: foregroundColor,
      elevation: md3Elevation!.value,
      overlayColor: MD3StateOverlayColor(
        stateLayerColor!.cast(),
        stateLayerOpacityTheme,
      ),
    );
  }
}

abstract class MD3ChipStyleChip extends ButtonStyleButton {
  MD3ChipStyleChip({
    Key? key,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    this.chipStyle,
    Widget? leading,
    required Widget label,
    Widget? trailing,
    this.leadingAvatar = false,
  })  : assert(
          chipStyle == null || style == null,
          'ChipStyle contains an subset of the settings of the ButtonStyle. '
          'If you wish to change more stuff, use style, otherwise stick to '
          'chipStyle, but never use both!',
        ),
        assert(label != null, 'According to MD3, every chip needs an label'),
        super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: _MD3ChipStyleChipChild(
            leading: leading,
            label: label,
            trailing: trailing,
            isDisabled: onPressed == null && onLongPress == null,
          ),
        );
  final ChipStyle? chipStyle;
  final bool leadingAvatar;

  ButtonStyle styleFrom({
    required ChipStyle chipStyle,
    required MD3StateLayerOpacityTheme stateLayerOpacityTheme,
    Color? shadowColor,
    TextStyle? labelStyle,
    MouseCursor? disabledCursor,
    MouseCursor? enabledCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    InteractiveInkFeatureFactory? splashFactory,
    OutlinedBorder? shape,
  }) {
    ArgumentError.checkNotNull(chipStyle);
    ArgumentError.checkNotNull(stateLayerOpacityTheme);

    final chipButtonStyle = chipStyle.toButtonStyle(stateLayerOpacityTheme);

    return ButtonStyle(
      shadowColor: ButtonStyleButton.allOrNull(shadowColor),
      textStyle: ButtonStyleButton.allOrNull(labelStyle),
      minimumSize: MaterialStateProperty.all(
        const Size(16.0 + 24.0 + 16.0, 32),
      ),
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(32)),
      maximumSize: MaterialStateProperty.all(Size.infinite),
      shape: ButtonStyleButton.allOrNull(shape),
      mouseCursor: MD3DisablableCursor(
        SystemMouseCursors.click,
        SystemMouseCursors.forbidden,
      ),
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: kThemeChangeDuration,
      enableFeedback: true,
      alignment: Alignment.center,
      splashFactory: splashFactory,
    ).merge(chipButtonStyle);
  }

  static EdgeInsetsGeometry outerPaddingFor(
    BuildContext context, {
    bool leadingAvatar = false,
  }) =>
      leadingAvatar
          ? ButtonStyleButton.scaledPadding(
              const EdgeInsetsDirectional.fromSTEB(4, 0, 8, 0),
              const EdgeInsetsDirectional.fromSTEB(2, 0, 4, 0),
              const EdgeInsetsDirectional.fromSTEB(1, 0, 2, 0),
              MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
            )
          : ButtonStyleButton.scaledPadding(
              const EdgeInsets.symmetric(horizontal: 8),
              const EdgeInsets.symmetric(horizontal: 4),
              const EdgeInsets.symmetric(horizontal: 2),
              MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
            );
  static EdgeInsetsGeometry innerPaddingFor(BuildContext context) =>
      ButtonStyleButton.scaledPadding(
        const EdgeInsets.symmetric(horizontal: 8),
        const EdgeInsets.symmetric(horizontal: 4),
        const EdgeInsets.symmetric(horizontal: 2),
        MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
      );

  ChipStyle defaultChipStyleOf(BuildContext context);
  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final theme = context.theme;
    var effectiveChipStyle = defaultChipStyleOf(context);
    if (chipStyle != null) {
      effectiveChipStyle = effectiveChipStyle.merge(chipStyle!);
    }
    return styleFrom(
      chipStyle: effectiveChipStyle,
      stateLayerOpacityTheme: context.stateOverlayOpacity,
      shadowColor: theme.shadowColor,
      labelStyle: context.textTheme.labelLarge,
      visualDensity: theme.visualDensity,
      tapTargetSize: theme.materialTapTargetSize,
      splashFactory: theme.splashFactory,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ).copyWith(
      padding: MaterialStateProperty.all(
        outerPaddingFor(context, leadingAvatar: leadingAvatar),
      ),
    );
  }

  @override
  ChipStyle? themeChipStyleOf(BuildContext context);
  @override
  ButtonStyle? themeStyleOf(BuildContext context) =>
      MD3ChipTheme.of(context).style;
}

class MD3ChipPrimaryIcon extends StatelessWidget {
  const MD3ChipPrimaryIcon(
    this.icon, {
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  static Widget? wrap({Widget? child, bool? isSelected}) => child == null
      ? null
      : MD3ChipPrimaryIcon(
          child,
          isSelected: isSelected,
        );

  final Widget icon;
  final bool? isSelected;

  @override
  Widget build(BuildContext context) {
    final scope = _MD3ChipIconScope.of(context)!;
    return IconTheme.merge(
      data: IconThemeData(
        color:
            scope.isDisabled || isSelected! ? null : context.colorScheme.primary,
      ),
      child: icon,
    );
  }
}

class MD3ChipIcon extends StatelessWidget {
  const MD3ChipIcon(
    this.icon, {
    Key? key,
    required this.enabledColor,
  }) : super(key: key);

  final Widget icon;
  final Color enabledColor;

  @override
  Widget build(BuildContext context) => IconTheme.merge(
        data: IconThemeData(
          color: _MD3ChipIconScope.of(context)!.isDisabled ? null : enabledColor,
        ),
        child: icon,
      );
}

class _MD3ChipIconScope extends InheritedWidget {
  const _MD3ChipIconScope({
    Key? key,
    required this.isDisabled,
    required Widget child,
  }) : super(key: key, child: child);

  final bool isDisabled;

  @override
  bool updateShouldNotify(_MD3ChipIconScope oldWidget) =>
      oldWidget.isDisabled != isDisabled;

  static _MD3ChipIconScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MD3ChipIconScope>();
}

class _MD3ChipStyleChipChild extends StatelessWidget {
  const _MD3ChipStyleChipChild({
    Key? key,
    required this.leading,
    required this.label,
    required this.trailing,
    required this.isDisabled,
  }) : super(key: key);

  final Widget? leading;
  final Widget label;
  final Widget? trailing;
  final bool isDisabled;

  Widget _wrapIcon({required Widget child}) => IconTheme.merge(
        data: const IconThemeData(size: 18),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    // Use half outside the child and half on the label, so that together it is
    // one padding unit.
    final scaledPadding = MD3ChipStyleChip.innerPaddingFor(context);
    return _MD3ChipIconScope(
      isDisabled: isDisabled,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (leading != null) _wrapIcon(child: leading!),
          Flexible(
            child: Padding(
              padding: scaledPadding,
              child: label,
            ),
          ),
          if (trailing != null) _wrapIcon(child: trailing!),
        ],
      ),
    );
  }
}
