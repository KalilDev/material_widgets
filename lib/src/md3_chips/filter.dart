import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

@immutable
class MD3FilterChipThemeData with Diagnosticable {
  const MD3FilterChipThemeData({this.style});

  final ChipStyle? style;

  /*static MD3FilterChipThemeData lerp(
      MD3FilterChipThemeData a, MD3FilterChipThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return MD3FilterChipThemeData(
      style: ChipStyle.lerp(a?.style, b?.style, t),
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
    return other is MD3FilterChipThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ChipStyle>('style', style, defaultValue: null),
    );
  }
}

class MD3FilterChipTheme extends InheritedTheme {
  const MD3FilterChipTheme({
    Key? key,
    required this.data,
    required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final MD3FilterChipThemeData data;

  static MD3FilterChipThemeData of(BuildContext context) {
    final MD3FilterChipTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MD3FilterChipTheme>();
    return buttonTheme?.data ?? MD3FilterChipThemeData(style: ChipStyle());
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MD3FilterChipTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MD3FilterChipTheme oldWidget) =>
      data != oldWidget.data;
}

class MD3FilterChip extends MD3ChipStyleChip {
  final bool selected;
  final bool elevated;

  MD3FilterChip({
    Key? key,
    required VoidCallback onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    ChipStyle? chipStyle,
    this.selected = false,
    this.elevated = false,
    Widget? leading,
    required Widget label,
    Widget? trailing,
  })  : assert(label != null),
        super(
          key: key,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          style: style,
          focusNode: focusNode,
          autofocus: autofocus,
          chipStyle: chipStyle,
          clipBehavior: clipBehavior,
          leading: (selected && leading == null) ? const Icon(Icons.check) : leading,
          label: label,
          trailing: trailing,
        );

  @override
  ChipStyle defaultChipStyleOf(BuildContext context) => ChipStyle.chipStyleFor(
        context.colorScheme,
        context.elevation,
        selected: selected,
        elevated: elevated,
      );

  @override
  ChipStyle? themeChipStyleOf(BuildContext context) =>
      MD3FilterChipTheme.of(context).style;
}
