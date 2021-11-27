import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

@immutable
class MD3InputChipThemeData with Diagnosticable {
  const MD3InputChipThemeData({this.style});

  final ChipStyle? style;

  /*static MD3InputChipThemeData lerp(
      MD3InputChipThemeData a, MD3InputChipThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return MD3InputChipThemeData(
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
    return other is MD3InputChipThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ChipStyle>('style', style, defaultValue: null),
    );
  }
}

class MD3InputChipTheme extends InheritedTheme {
  const MD3InputChipTheme({
    Key? key,
    required this.data,
    required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final MD3InputChipThemeData data;

  static MD3InputChipThemeData of(BuildContext context) {
    final MD3InputChipTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MD3InputChipTheme>();
    return buttonTheme?.data ?? MD3InputChipThemeData(style: ChipStyle());
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MD3InputChipTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MD3InputChipTheme oldWidget) =>
      data != oldWidget.data;
}

class MD3InputChip extends MD3ChipStyleChip {
  final bool selected;

  MD3InputChip({
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
    bool leadingAvatar = false,
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
          leading: MD3ChipPrimaryIcon.wrap(
            child: leading,
            isSelected: selected,
          ),
          label: label,
          trailing: trailing,
          leadingAvatar: leadingAvatar,
        );

  @override
  ChipStyle defaultChipStyleOf(BuildContext context) => ChipStyle.chipStyleFor(
        context.colorScheme,
        context.elevation,
        elevated: false,
        selected: selected,
      );

  @override
  ChipStyle? themeChipStyleOf(BuildContext context) =>
      MD3InputChipTheme.of(context).style;
}
