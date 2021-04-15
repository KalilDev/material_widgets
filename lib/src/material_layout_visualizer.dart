import 'package:flutter/material.dart';

import 'material_layout.dart';
import 'material_layout_data.dart';

class _MaterialLayoutPaperPainter extends CustomPainter {
  const _MaterialLayoutPaperPainter(
      {this.columnColor,
      this.marginColor,
      this.gutter,
      this.margin,
      this.columnCount});

  final Color columnColor;
  final Color marginColor;
  final double gutter;
  final double margin;
  final int columnCount;

  @override
  void paint(Canvas canvas, Size size) {
    final columnPaint = Paint()..color = columnColor;
    final marginPaint = Paint()..color = marginColor;

    // Columns
    var columns = size.width;
    columns -= 2 * margin;
    columns -= (columnCount - 1) * gutter;
    final column = columns / columnCount;
    for (var i = 0; i < columnCount; i++) {
      final startX = margin + (i * gutter) + (i * column);
      canvas.drawRect(
          Rect.fromLTWH(startX, 0, column, size.height), columnPaint);
    }

    // Margins
    canvas.drawRect(Rect.fromLTWH(0, 0, margin, size.height), marginPaint);
    canvas.drawRect(Rect.fromLTWH(size.width - margin, 0, margin, size.height),
        marginPaint);
  }

  @override
  bool shouldRepaint(_MaterialLayoutPaperPainter oldPainter) {
    return oldPainter.columnColor != columnColor ||
        oldPainter.marginColor != marginColor ||
        oldPainter.gutter != gutter ||
        oldPainter.margin != margin ||
        oldPainter.columnCount != columnCount;
  }

  @override
  bool hitTest(Offset position) => false;
}

class MaterialLayoutPaper extends StatelessWidget {
  const MaterialLayoutPaper({
    Key key,
    this.child,
    this.columnColor = const Color(0x3Ffe2c7f),
    this.marginColor = const Color(0x3fb2ff59),
    this.data,
  }) : super(key: key);

  /// The color to draw the columns in the layout.
  ///
  /// Defaults to a light pinkish color, just like in http://material.io website.
  final Color columnColor;

  /// The color to draw the margins in the layout.
  ///
  /// Defaults to a light green, just like in http://material.io.
  final Color marginColor;

  /// Defines an material layout with margins, gutters and columns for a good
  /// interface on all screen sizes.
  ///
  /// See more in:
  /// https://material.io/design/layout/responsive-layout-grid.html.
  ///
  /// Defaults to inheriting the layout from context.
  final MaterialLayoutData data;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var data = this.data ?? MaterialLayout.of(context);
    return CustomPaint(
      foregroundPainter: _MaterialLayoutPaperPainter(
          columnColor: columnColor,
          marginColor: marginColor,
          gutter: data.gutter,
          margin: data.margin,
          columnCount: data.columnCount),
      child: child,
    );
  }
}
