import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

@immutable
class MD3SuggestionChipThemeData with Diagnosticable {
  const MD3SuggestionChipThemeData({this.style});

  final ChipStyle style;

  /*static MD3SuggestionChipThemeData lerp(
      MD3SuggestionChipThemeData a, MD3SuggestionChipThemeData b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    return MD3SuggestionChipThemeData(
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
    return other is MD3SuggestionChipThemeData && other.style == style;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ChipStyle>('style', style, defaultValue: null),
    );
  }
}

class MD3SuggestionChipTheme extends InheritedTheme {
  const MD3SuggestionChipTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        super(key: key, child: child);

  final MD3SuggestionChipThemeData data;

  static MD3SuggestionChipThemeData of(BuildContext context) {
    final MD3SuggestionChipTheme buttonTheme =
        context.dependOnInheritedWidgetOfExactType<MD3SuggestionChipTheme>();
    return buttonTheme?.data ?? MD3SuggestionChipThemeData(style: ChipStyle());
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return MD3SuggestionChipTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(MD3SuggestionChipTheme oldWidget) =>
      data != oldWidget.data;
}

class MD3SuggestionChip extends MD3ChipStyleChip {
  final bool elevated;
  final bool selected;

  MD3SuggestionChip({
    Key key,
    @required VoidCallback onPressed,
    VoidCallback onLongPress,
    ValueChanged<bool> onHover,
    ValueChanged<bool> onFocusChange,
    ButtonStyle style,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    ChipStyle chipStyle,
    this.elevated = false,
    this.selected = false,
    Widget leading,
    @required Widget label,
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
        );

  @override
  ChipStyle defaultChipStyleOf(BuildContext context) => ChipStyle.chipStyleFor(
        context.colorScheme,
        context.elevation,
        elevated: elevated,
        selected: selected,
      );

  @override
  ChipStyle themeChipStyleOf(BuildContext context) =>
      MD3SuggestionChipTheme.of(context).style;
}
