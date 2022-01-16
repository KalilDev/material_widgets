import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;

class MD3TabBar extends StatelessWidget implements PreferredSizeWidget {
  const MD3TabBar({
    Key? key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.indicator,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    this.unselectedUnderlineWidth = 1.0,
    this.unselectedUnderlineColor,
  }) : super(key: key);
  final List<Widget> tabs;
  final TabController? controller;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Decoration? indicator;
  final EdgeInsetsGeometry indicatorPadding;
  final TabBarIndicatorSize? indicatorSize;
  final MaterialStateProperty<Color?>? labelColor;
  final EdgeInsetsGeometry? labelPadding;
  final MaterialStateProperty<TextStyle?>? labelStyle;
  final MaterialStateProperty<Color?>? overlayColor;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final ValueChanged<int>? onTap;
  final ScrollPhysics? physics;
  final double unselectedUnderlineWidth;
  final Color? unselectedUnderlineColor;

  @override
  Size get preferredSize {
    double maxHeight = _kTabHeight;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight);
  }

  bool get tabHasTextAndIcon {
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        if (item.preferredSize.height == _kTextAndIconTabHeight) return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const selected = {MaterialState.selected};
    const none = <MaterialState>{};
    return DecoratedBox(
      decoration: UnderlineTabIndicator(
        borderSide: BorderSide(
          width: unselectedUnderlineWidth,
          color:
              unselectedUnderlineColor ?? context.colorScheme.primaryContainer,
        ),
      ),
      child: TabBar(
        tabs: tabs,
        controller: controller,
        isScrollable: isScrollable,
        padding: padding,
        indicatorPadding: indicatorPadding,
        indicatorSize: indicatorSize,
        labelColor: labelColor?.resolve(selected),
        labelStyle: labelStyle?.resolve(selected),
        labelPadding: labelPadding,
        unselectedLabelColor: labelColor?.resolve(none),
        unselectedLabelStyle: labelStyle?.resolve(none),
        dragStartBehavior: dragStartBehavior,
        overlayColor: overlayColor ??
            MD3StateOverlayColor(
              context.colorScheme.onSurface,
              context.stateOverlayOpacity,
            ),
        mouseCursor: mouseCursor,
        enableFeedback: enableFeedback,
        onTap: onTap,
        physics: physics,
      ),
    );
  }
}
