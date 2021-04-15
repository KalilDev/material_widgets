import 'package:flutter/material.dart';

import 'material_layout.dart';

class Whiteframe extends StatelessWidget {
  final Widget child;
  final Clip clip;

  const Whiteframe({
    Key key,
    this.child,
    this.clip,
  }) : super(key: key);

  static double kMaxTopPadding = 64.0;

  @override
  Widget build(BuildContext context) {
    final layout = MaterialLayout.of(context);
    final padding = layout.margin - layout.gutter;
    final topPadding = (padding / 2).clamp(0.0, kMaxTopPadding).toDouble();
    final hasPadding = padding != 0;
    return Card(
      margin: EdgeInsets.only(
          left: padding,
          right: padding,
          top: topPadding,
          bottom: padding > 0 ? layout.gutter : 0),
      elevation: hasPadding ? 2.0 : 0.0,
      shape: hasPadding ? null : RoundedRectangleBorder(),
      clipBehavior: clip,
      child: MaterialLayout.removeMargin(
        context: context,
        child: child,
        remaining: layout.gutter,
      ),
    );
  }
}
