import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_size_class_property.dart';
import 'package:material_you/material_you.dart';

const MD3SizeClassProperty<double> _kMinMargin = MD3SizeClassProperty.every(
  compact: 16,
  medium: 32,
  expanded: 32,
);

const MD3SizeClassProperty<double> _kMaxMargin = MD3SizeClassProperty.every(
  compact: 32,
  medium: 32,
  expanded: 200,
);

class InheritedMD3BodyMargin extends InheritedWidget {
  const InheritedMD3BodyMargin({
    Key? key,
    required this.margin,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  final double margin;
  EdgeInsets get padding => EdgeInsets.symmetric(horizontal: margin);

  @override
  bool updateShouldNotify(InheritedMD3BodyMargin oldWidget) =>
      margin != oldWidget.margin;
  static InheritedMD3BodyMargin of(BuildContext context) => maybeOf(context)!;
  static InheritedMD3BodyMargin? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedMD3BodyMargin>();
}

/// Body region
/// The body region is used for displaying most of the content in an app. It
/// typically contains components such as lists, cards, buttons, and images.
///
/// The body region uses scaling values for the following three parameters:
/// * Vertical and horizontal dimensions
/// * Number of columns
/// * Margins
///
/// At extra small breakpoints, margins have a value of 16dp. As the layout
/// increases in size, the body section expands relative to the width of the
/// screen. Upon reaching the first breakpoint (small; 600dp wide) the margins
/// increase to 32dp.
///
/// When the width of the body reaches 840dp, margins increase to a maximum
/// width of 200dp. After this maximum width is met, the body region once again
/// becomes responsive, continuing to scale horizontally.
class MD3ScaffoldBody extends StatelessWidget {
  const MD3ScaffoldBody({
    Key? key,
    this.minimumMargin,
    this.maximumMargin,
    this.applyMargin = const MD3SizeClassProperty.all(true),
    required this.child,
  }) : super(key: key);

  const MD3ScaffoldBody.noMargin({
    Key? key,
    this.minimumMargin,
    this.maximumMargin,
    required this.child,
  })  : applyMargin = const MD3SizeClassProperty.all(false),
        super(key: key);

  static Widget maybeWrap({required Widget child}) => child is MD3ScaffoldBody
      ? child
      : MD3ScaffoldBody(
          child: child,
        );

  // Used to add further widgets between the scaffold and the body without
  // losing the properties set by the [MD3ScaffoldBody]
  static Widget rewrap({
    required Widget Function(Widget) builder,
    required Widget child,
  }) =>
      child is MD3ScaffoldBody
          ? MD3ScaffoldBody(
              key: child.key,
              child: builder(child.child),
            )
          : builder(child);

  final MD3SizeClassProperty<double?>? minimumMargin;
  final MD3SizeClassProperty<double?>? maximumMargin;
  final MD3SizeClassProperty<bool> applyMargin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sizeClass = context.sizeClass;
    final minMargin =
        minimumMargin?.resolve(sizeClass) ?? _kMinMargin.resolve(sizeClass);
    final maxMargin =
        maximumMargin?.resolve(sizeClass) ?? _kMaxMargin.resolve(sizeClass);
    final applyMargin = this.applyMargin.resolve(sizeClass);
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final double margin;
        switch (sizeClass) {
          case MD3WindowSizeClass.compact:
            const breakpointMin = 0;
            const breakpointMax = 600;
            const breakpointDt = breakpointMax - breakpointMin;
            final breakpointT = (size.width - breakpointMin) / breakpointDt;
            margin = lerpDouble(minMargin, maxMargin, breakpointT)!;
            break;
          case MD3WindowSizeClass.medium:
            const breakpointMin = 600;
            const breakpointMax = 840;
            const breakpointDt = breakpointMax - breakpointMin;
            final breakpointT = (size.width - breakpointMin) / breakpointDt;
            margin = lerpDouble(minMargin, maxMargin, breakpointT)!;
            break;
          case MD3WindowSizeClass.expanded:
            const breakpointBodyMin = 840;
            final widthAvailableForMargins = size.width - breakpointBodyMin;
            final maxMarginWidth = widthAvailableForMargins / 2;
            margin = maxMarginWidth.clamp(minMargin, maxMargin);
            break;
        }
        return InheritedMD3BodyMargin(
          margin: margin,
          child: Padding(
            padding: applyMargin
                ? EdgeInsets.symmetric(horizontal: margin)
                : EdgeInsets.zero,
            child: child,
          ),
        );
      },
    );
  }
}
