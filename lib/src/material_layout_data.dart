import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'material_breakpoint.dart';

class MaterialLayoutData with Diagnosticable {
  final int columnCount;
  final double margin;
  final double gutter;
  final MaterialBreakpoint breakpoint;

  MaterialLayoutData({this.margin, this.gutter, this.breakpoint})
      : assert(margin != null && gutter != null && breakpoint != null),
        columnCount = breakpoint.columns;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('gutter', gutter));
    properties.add(DoubleProperty('margin', margin));
    properties.add(IntProperty('columnCount', columnCount));
    properties.add(DiagnosticsProperty<MaterialBreakpoint>(
        'breakpoint', breakpoint,
        expandableValue: true));
  }

  MaterialLayoutData removeMargin([double remaining = 0]) {
    assert(remaining <= margin);
    return MaterialLayoutData(
        margin: remaining, gutter: gutter, breakpoint: breakpoint);
  }

  List<Widget> padVertical(List<Widget> children,
      {bool padMargins, bool padGutters}) {
    final gutter = padGutters ? 0.0 : this.gutter;
    final margin = padMargins ? 0.0 : this.margin;
    final halfGutter = gutter / 2;
    final result = <Widget>[]..length = children.length;
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      EdgeInsetsGeometry padding;
      if (i == 0) {
        padding = EdgeInsets.only(
          left: margin,
          right: margin,
          top: gutter,
          bottom: children.length == 1 ? margin : halfGutter,
        );
      } else if (i == children.length - 1) {
        padding = EdgeInsets.only(
          left: margin,
          right: margin,
          top: halfGutter,
          bottom: gutter,
        );
      }
      padding ??= EdgeInsets.symmetric(
        vertical: halfGutter,
        horizontal: margin,
      );
      result[i] = Padding(padding: padding, child: child);
    }
    return result;
  }
}
