import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

@immutable
class MD3AssistChipThemeData with Diagnosticable {
  const MD3AssistChipThemeData({this.style});

  final ChipStyle? style;

  /*static MD3AssistChipThemeData lerp(
      MD3AssistChipThemeData a, MD3AssistChipThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return MD3AssistChipThemeData(
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
    return other is MD3AssistChipThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ChipStyle>('style', style, defaultValue: null),
    );
  }
}

class MD3AssistChipTheme extends InheritedTheme {
  const MD3AssistChipTheme({
    Key? key,
    required this.data,
    required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final MD3AssistChipThemeData data;

  static MD3AssistChipThemeData of(BuildContext context) {
    final MD3AssistChipTheme? buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MD3AssistChipTheme>();
    return buttonTheme?.data ?? MD3AssistChipThemeData(style: ChipStyle());
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MD3AssistChipTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MD3AssistChipTheme oldWidget) =>
      data != oldWidget.data;
}

class MD3AssistChip extends MD3ChipStyleChip {
  final bool elevated;
  MD3AssistChip({
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
          leading: MD3ChipPrimaryIcon.wrap(
            child: leading,
            isSelected: false,
          ),
          label: label,
          trailing: trailing,
        );

  @override
  ChipStyle defaultChipStyleOf(BuildContext context) => ChipStyle.chipStyleFor(
        context.colorScheme,
        context.elevation,
        elevated: elevated,
        selected: false,
      );

  @override
  ChipStyle? themeChipStyleOf(BuildContext context) =>
      MD3AssistChipTheme.of(context).style;
}
