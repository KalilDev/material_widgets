// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import 'menu_entry.dart';
// Examples can assume:
// enum Commands { heroAndScholar, hurricaneCame }
// late bool _heroAndScholar;
// late dynamic _selection;
// late BuildContext context;
// void setState(VoidCallback fn) { }

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 196;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;

class InheritedMD3PopupMenuScope<T> extends InheritedWidget {
  const InheritedMD3PopupMenuScope({
    Key? key,
    this.selectedItem,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  final T? selectedItem;

  @override
  bool updateShouldNotify(InheritedMD3PopupMenuScope<T> oldWidget) =>
      selectedItem != oldWidget.selectedItem;

  static InheritedMD3PopupMenuScope<T> of<T>(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedMD3PopupMenuScope<T>>()!;
}

const double kMenuMinWidth = 196.0;

enum MD3PopupMenuKind {
  selection,
  regular,
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    Key? key,
    required this.route,
    required this.semanticLabel,
  }) : super(key: key);

  final _PopupMenuRoute<T> route;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    final textDirection = Directionality.of(context);
    final menuKind = route.menuKind ?? MD3PopupMenuKind.regular;
    final growthDirection = _PopupMenuRouteLayout.growthDirectionForPosition(
      route.position,
      textDirection,
    );

    final CurveTween opacity = CurveTween(curve: Curves.linear);

    final Rect begginingClipRect;
    switch (growthDirection) {
      case _PopupMenuGrowDirection.left:
        begginingClipRect = const Rect.fromLTRB(0.5, 0, 1, 0);
        break;
      case _PopupMenuGrowDirection.right:
        begginingClipRect = const Rect.fromLTRB(0, 0, 0.5, 0);
        break;
    }
    final List<MD3PopupMenuEntry<T>> items;
    switch (menuKind) {
      case MD3PopupMenuKind.regular:
        items = route.items;
        break;
      case MD3PopupMenuKind.selection:
        final value = route.initialValue;
        if (value == null) {
          items = route.items;
        } else {
          items = route.items
              .where((entry) => entry.represents(value))
              .followedBy(
                route.items.where((entry) => !entry.represents(value)),
              )
              .toList();
        }
        break;
    }

    final bool hasVerticalPadding = menuKind != MD3PopupMenuKind.selection;

    final body = InheritedMD3PopupMenuScope<T>(
      selectedItem: route.initialValue,
      child: Semantics(
        scopesRoute: true,
        namesRoute: true,
        explicitChildNodes: true,
        label: semanticLabel,
        child: SingleChildScrollView(
          padding: hasVerticalPadding
              ? const EdgeInsets.symmetric(
                  vertical: _kMenuVerticalPadding,
                )
              : EdgeInsets.zero,
          child: ListBody(children: items),
        ),
      ),
    );

    final Widget child;
    switch (menuKind) {
      case MD3PopupMenuKind.selection:
        child = ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: _kMenuMaxWidth,
          ),
          child: IntrinsicWidth(child: body),
        );
        break;
      case MD3PopupMenuKind.regular:
        child = ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: _kMenuMinWidth,
            maxWidth: _kMenuMaxWidth,
          ),
          child: IntrinsicWidth(stepWidth: _kMenuWidthStep, child: body),
        );
        break;
    }

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        final entranceAnimation = CurvedAnimation(
          parent: route.animation!,
          curve: Curves.easeInOut,
          // stay at 1.0
          reverseCurve: const Threshold(0.0),
        );
        final exitAnimation = CurvedAnimation(
          parent: route.animation!,
          // stay at 1.0
          curve: const Threshold(0.0),
          reverseCurve: Curves.linear,
        );
        return _TranslateAndClip(
          clipRectAnimation: entranceAnimation,
          begginingClipRect: begginingClipRect,
          child: FadeTransition(
            opacity: opacity.animate(exitAnimation),
            child: Material(
              shape: route.shape ?? popupMenuTheme.shape,
              color: route.color ?? popupMenuTheme.color,
              type: MaterialType.card,
              elevation: route.elevation ??
                  popupMenuTheme.elevation ??
                  context.elevation.level2.value,
              clipBehavior: route.clipBehavior ??
                  popupMenuTheme.clipBehavior ??
                  Clip.none,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _TranslateAndClipLayoutInfo {
  _TranslateAndClipLayoutInfo(this.start, this.clipRect);

  final Offset start;
  final Rect clipRect;
}

class _TranslateAndClip extends SingleChildRenderObjectWidget {
  const _TranslateAndClip({
    Key? key,
    required this.begginingClipRect,
    required this.clipRectAnimation,
    required Widget child,
  }) : super(key: key, child: child);

  final Rect begginingClipRect;
  final Animation<double> clipRectAnimation;

  @override
  _RenderTranslateAndClip createRenderObject(BuildContext context) =>
      _RenderTranslateAndClip(
        begginingClipRect: begginingClipRect,
        clipRectAnimation: clipRectAnimation,
      );
  @override
  _TranslateAndClipElement createElement() => _TranslateAndClipElement(this);
}

class _TranslateAndClipElement extends SingleChildRenderObjectElement {
  _TranslateAndClipElement(_TranslateAndClip widget) : super(widget);
  _TranslateAndClip get widget => super.widget as _TranslateAndClip;
  _RenderTranslateAndClip get renderObject =>
      super.renderObject as _RenderTranslateAndClip;
  @override
  void update(_TranslateAndClip newWidget) {
    super.update(newWidget);
    renderObject
      ..begginingClipRect = newWidget.begginingClipRect
      ..clipRectAnimation = newWidget.clipRectAnimation;
  }
}

class _RenderTranslateAndClip extends RenderProxyBox {
  _RenderTranslateAndClip({
    RenderBox? child,
    required Rect begginingClipRect,
    required Animation<double> clipRectAnimation,
  })  : _begginingClipRect = begginingClipRect,
        super(child) {
    this.clipRectAnimation = clipRectAnimation;
  }

  RectTween? _clipRectTween;

  Rect? _begginingClipRect;
  Rect get begginingClipRect => _begginingClipRect!;
  set begginingClipRect(Rect value) {
    if (_begginingClipRect == value) {
      return;
    }
    _begginingClipRect = value;
    // the clip rect tween is dirty. recreate it on the next paint.
    _clipRectTween = null;
    markNeedsPaint();
  }

  RectTween createRectTween() => MaterialRectArcTween(
        begin: Rect.fromLTRB(
          begginingClipRect.left * size.width,
          begginingClipRect.top * size.height,
          begginingClipRect.right * size.width,
          begginingClipRect.bottom * size.height,
        ),
        end: (Offset.zero & size).inflate(4.0),
      );

  Animation<double>? _clipRectAnimation;
  Animation<double> get clipRectAnimation => _clipRectAnimation!;
  set clipRectAnimation(Animation<double> value) {
    if (_clipRectAnimation == value) {
      return;
    }
    if (_clipRectAnimation != null) {
      _clipRectAnimation!.removeListener(markNeedsPaint);
    }
    _clipRectAnimation = value;
    value.addListener(markNeedsPaint);
  }

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    final newChildSize = child!.size;
    if (hasSize && size != newChildSize) {
      // the clip rect tween is dirty. recreate it on the next paint.
      _clipRectTween = null;
    }
    size = newChildSize;
  }

  _TranslateAndClipLayoutInfo computeLayoutInfo(Offset start) {
    final clipRectTween = _clipRectTween ??= createRectTween();
    final clipRect = clipRectTween.evaluate(clipRectAnimation)!;
    final startPoint =
        clipRect.center - Offset(size.width / 2, size.height / 2);
    return _TranslateAndClipLayoutInfo(startPoint, clipRect);
  }

  @override
  // TODO: implement needsCompositing
  bool get needsCompositing => true;

  void _paintClipped(
    PaintingContext context,
    Offset offset,
    Rect clip,
    void Function(PaintingContext, Offset) paint,
  ) {
    layer = context.pushClipRect(
      needsCompositing,
      offset,
      clip,
      paint,
      oldLayer: layer as ClipRectLayer?,
      clipBehavior: Clip.antiAlias,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final layoutInfo = computeLayoutInfo(offset);
    _paintClipped(
      context,
      offset,
      layoutInfo.clipRect,
      (context, offset) => super.paint(context, offset + layoutInfo.start),
    );
  }
}

enum _PopupMenuGrowDirection {
  left,
  right,
}

// Positioning of the menu on the screen.
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position,
    this.textDirection,
    this.padding,
  );

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  EdgeInsets padding;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  static _PopupMenuGrowDirection growthDirectionForPosition(
      RelativeRect position, TextDirection textDirection) {
    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      return _PopupMenuGrowDirection.left;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      return _PopupMenuGrowDirection.right;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      assert(textDirection != null);
      switch (textDirection) {
        case TextDirection.rtl:
          return _PopupMenuGrowDirection.left;
        case TextDirection.ltr:
          return _PopupMenuGrowDirection.right;
      }
    }
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.
    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    double x;
    final growDirection = growthDirectionForPosition(position, textDirection);
    switch (growDirection) {
      case _PopupMenuGrowDirection.left:
        // Grow to the left, aligned to the right edge.
        x = size.width - position.right - childSize.width;
        break;
      case _PopupMenuGrowDirection.right:
        // Grow to the right, aligned to the left edge.
        x = position.left;
        break;
    }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    if (x < _kMenuScreenPadding + padding.left)
      x = _kMenuScreenPadding + padding.left;
    else if (x + childSize.width >
        size.width - _kMenuScreenPadding - padding.right)
      x = size.width - childSize.width - _kMenuScreenPadding - padding.right;
    if (y < _kMenuScreenPadding + padding.top)
      y = _kMenuScreenPadding + padding.top;
    else if (y + childSize.height >
        size.height - _kMenuScreenPadding - padding.bottom)
      y = size.height - padding.bottom - _kMenuScreenPadding - childSize.height;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position ||
        textDirection != oldDelegate.textDirection ||
        padding != oldDelegate.padding;
  }
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    required this.position,
    required this.items,
    this.initialValue,
    this.elevation,
    required this.barrierLabel,
    this.semanticLabel,
    this.shape,
    this.color,
    required this.capturedThemes,
    this.clipBehavior,
    this.menuKind,
  });

  final RelativeRect position;
  final List<MD3PopupMenuEntry<T>> items;
  final T? initialValue;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;
  final Clip? clipBehavior;
  final MD3PopupMenuKind? menuKind;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget menu =
        _PopupMenu<T>(route: this, semanticLabel: semanticLabel);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              position,
              Directionality.of(context),
              mediaQuery.padding,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

/// Show a popup menu that contains the `items` at `position`.
///
/// `items` should be non-null and not empty.
///
/// If `initialValue` is specified then the first item with a matching value
/// will be highlighted and the value of `position` gives the rectangle whose
/// vertical center will be aligned with the vertical center of the highlighted
/// item (when possible).
///
/// If `initialValue` is not specified then the top of the menu will be aligned
/// with the top of the `position` rectangle.
///
/// In both cases, the menu position will be adjusted if necessary to fit on the
/// screen.
///
/// Horizontally, the menu is positioned so that it grows in the direction that
/// has the most room. For example, if the `position` describes a rectangle on
/// the left edge of the screen, then the left edge of the menu is aligned with
/// the left edge of the `position`, and the menu grows to the right. If both
/// edges of the `position` are equidistant from the opposite edge of the
/// screen, then the ambient [Directionality] is used as a tie-breaker,
/// preferring to grow in the reading direction.
///
/// The positioning of the `initialValue` at the `position` is implemented by
/// iterating over the `items` to find the first whose
/// [MD3PopupMenuEntry.represents] method returns true for `initialValue`, and then
/// summing the values of [MD3PopupMenuEntry.height] for all the preceding widgets
/// in the list.
///
/// The `elevation` argument specifies the z-coordinate at which to place the
/// menu. The elevation defaults to 8, the appropriate elevation for popup
/// menus.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the menu. It is only used when the method is called. Its corresponding
/// widget can be safely removed from the tree before the popup menu is closed.
///
/// The `useRootNavigator` argument is used to determine whether to push the
/// menu to the [Navigator] furthest from or nearest to the given `context`. It
/// is `false` by default.
///
/// The `semanticLabel` argument is used by accessibility frameworks to
/// announce screen transitions when the menu is opened and closed. If this
/// label is not provided, it will default to
/// [MaterialLocalizations.popupMenuLabel].
///
/// See also:
///
///  * [PopupMenuItem], a popup menu entry for a single value.
///  * [PopupMenuDivider], a popup menu entry that is just a horizontal line.
///  * [CheckedPopupMenuItem], a popup menu item with a checkmark.
///  * [PopupMenuButton], which provides an [IconButton] that shows a menu by
///    calling this method automatically.
///  * [SemanticsConfiguration.namesRoute], for a description of edge triggered
///    semantics.
Future<T?> showMD3Menu<T>({
  required BuildContext context,
  required RelativeRect position,
  required List<MD3PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
  Clip? clipBehavior,
  MD3PopupMenuKind? menuKind,
}) {
  assert(context != null);
  assert(position != null);
  assert(useRootNavigator != null);
  assert(items != null && items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_PopupMenuRoute<T>(
    position: position,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    shape: shape,
    color: color,
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
    clipBehavior: clipBehavior,
    menuKind: menuKind,
  ));
}
