import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import 'card_style.dart';
import 'draggable_card.dart';

abstract class CardStyleCard extends StatefulWidget {
  const CardStyleCard({
    Key? key,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.style,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final CardStyle? style;
  final Widget child;

  CardStyle defaultStyleOf(BuildContext context);
  CardStyle? themeStyleOf(BuildContext context);

  @override
  State<CardStyleCard> createState() => _CardStyleCardState();
}

class _CardStyleCardState extends State<CardStyleCard>
    with MaterialStateMixin, SingleTickerProviderStateMixin {
  AnimationController? _controller;
  MD3ElevationLevel? _elevation;
  Color? _backgroundColor;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isBeingDragged =
        InheritedDraggableCardInformation.maybeOf(context) ?? false;
    setMaterialState(MaterialState.dragged, isBeingDragged);
  }

  bool get _isInteractive =>
      widget.onPressed != null || widget.onLongPress != null;

  static const _kInteractiveStates = [
    MaterialState.focused,
    MaterialState.hovered,
    MaterialState.pressed,
    MaterialState.selected,
  ];

  @override
  Widget build(BuildContext context) {
    final widgetStyle = widget.style;
    final themeStyle = widget.themeStyleOf(context);
    final defaultStyle = widget.defaultStyleOf(context);
    assert(defaultStyle != null);

    final effectiveMaterialStates = materialStates.toSet()
      ..removeAll(_isInteractive ? const [] : _kInteractiveStates);

    T? effectiveValue<T>(T? Function(CardStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    T? resolve<T>(
        MaterialStateProperty<T>? Function(CardStyle? style) getProperty) {
      return effectiveValue(
        (CardStyle? style) =>
            getProperty(style)?.resolve(effectiveMaterialStates),
      );
    }

    final elevation =
        resolve((s) => s?.elevation) ?? const MD3ElevationLevel.from(0, 0);
    final stateLayer = MaterialStateProperty.resolveWith(
        (states) => effectiveValue((s) => s?.stateLayerColor?.resolve(states)));
    final shape = resolve((s) => s?.shape) ?? const RoundedRectangleBorder();
    var backgroundColor = resolve((s) => s?.backgroundColor);
    final shadowColor = resolve((s) => s?.shadowColor);
    final tintColor = resolve((s) => s?.elevationTintColor);
    final foreground = resolve((s) => s?.foregroundColor);
    final padding = resolve((s) => s?.padding);
    final interactiveMouseCursor = resolve((s) => s?.interactiveMouseCursor);
    final borderSide = resolve((s) => s?.side);
    final clipBehavior = effectiveValue((s) => s?.clipBehavior);
    final animationDuration = effectiveValue((s) => s?.animationDuration);
    final enableFeedback = effectiveValue((s) => s?.enableFeedback);
    final splashFactory = effectiveValue((s) => s?.splashFactory);
    final splashColor = effectiveValue((s) => s?.splashColor);

    // If an opaque button's background is becoming translucent while its
    // elevation is changing, change the elevation first. Material implicitly
    // animates its elevation but not its color. SKIA renders non-zero
    // elevations as a shadow colored fill behind the Material's background.
    if (animationDuration! > Duration.zero &&
        _elevation != null &&
        _backgroundColor != null &&
        _elevation != elevation &&
        _backgroundColor!.value != backgroundColor!.value &&
        _backgroundColor!.opacity == 1 &&
        backgroundColor.opacity < 1 &&
        elevation.value == 0) {
      if (_controller?.duration != animationDuration) {
        _controller?.dispose();
        _controller = AnimationController(
          duration: animationDuration,
          vsync: this,
        )..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {}); // Rebuild with the final background color.
            }
          });
      }
      backgroundColor =
          _backgroundColor; // Defer changing the background color.
      _controller!.value = 0;
      _controller!.forward();
    }
    _elevation = elevation;
    _backgroundColor = backgroundColor;

    return Material(
      color: tintColor == null || backgroundColor == null
          ? backgroundColor
          : elevation.overlaidColor(
              backgroundColor,
              tintColor,
            ),
      animationDuration: animationDuration,
      elevation: elevation.value,
      shape: shape.copyWith(side: borderSide),
      shadowColor: shadowColor,
      clipBehavior: clipBehavior ?? Clip.none,
      child: InkWell(
        focusNode: widget.focusNode,
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        mouseCursor:
            _isInteractive ? interactiveMouseCursor : MouseCursor.defer,
        onHighlightChanged: updateMaterialState(MaterialState.pressed),
        onHover: updateMaterialState(
          MaterialState.hovered,
          onChanged: widget.onHover,
        ),
        onFocusChange: updateMaterialState(
          MaterialState.focused,
          onChanged: widget.onFocusChange,
        ),
        overlayColor: stateLayer,
        splashColor: splashColor,
        customBorder: shape,
        enableFeedback: enableFeedback,
        splashFactory: splashFactory,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: _foreground(
            foreground,
            child: InheritedDraggableCardInformation.shadow(
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _foreground(Color? color, {required Widget child}) =>
      DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: IconTheme.merge(
          data: IconThemeData(
            color: color,
          ),
          child: child,
        ),
      );
}
