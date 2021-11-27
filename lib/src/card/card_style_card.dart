import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_you/material_you.dart';

import 'draggable_card.dart';
import 'outlined_card.dart';

class CardStyle {
  CardStyle({
    this.elevation,
    this.stateLayerColor,
    this.shape,
    this.backgroundColor,
    this.shadowColor,
    this.elevationTintColor,
    this.foregroundColor,
    this.padding,
    this.mouseCursor,
    this.borderSide,
    this.clipBehavior,
  });

  final MaterialStateProperty<MD3ElevationLevel>? elevation;
  final MaterialStateProperty<Color>? stateLayerColor;
  final MaterialStateProperty<OutlinedBorder>? /*?*/ shape;
  final MaterialStateProperty<Color>? backgroundColor;
  final MaterialStateProperty<Color>? shadowColor;
  final MaterialStateProperty<Color>? elevationTintColor;
  final MaterialStateProperty<Color>? foregroundColor;
  final MaterialStateProperty<EdgeInsetsGeometry>? padding;
  final MaterialStateProperty<MouseCursor>? mouseCursor;
  final MaterialStateProperty<BorderSide>? borderSide;
  final Clip? clipBehavior;

  CardStyle merge(CardStyle other) => CardStyle(
        elevation: other.elevation ?? elevation,
        stateLayerColor: other.stateLayerColor ?? stateLayerColor,
        shape: other.shape ?? shape,
        backgroundColor: other.backgroundColor ?? backgroundColor,
        shadowColor: other.shadowColor ?? shadowColor,
        elevationTintColor: other.elevationTintColor ?? elevationTintColor,
        foregroundColor: other.foregroundColor ?? foregroundColor,
        padding: other.padding ?? padding,
        mouseCursor: other.mouseCursor ?? mouseCursor,
        borderSide: other.borderSide ?? borderSide,
        clipBehavior: other.clipBehavior ?? clipBehavior,
      );

  static const double kHorizontalPadding = 16;
  static const double kMaxCardSpacing = 8;

  CardStyle copyWith({
    MaterialStateProperty<MD3ElevationLevel>? elevation,
    MaterialStateProperty<Color>? stateLayerColor,
    MaterialStateProperty<OutlinedBorder>? shape,
    MaterialStateProperty<Color>? backgroundColor,
    MaterialStateProperty<Color>? shadowColor,
    MaterialStateProperty<Color>? elevationTintColor,
    MaterialStateProperty<Color>? foregroundColor,
    MaterialStateProperty<EdgeInsetsGeometry>? padding,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MaterialStateProperty<BorderSide>? borderSide,
    Clip? clipBehavior,
  }) =>
      CardStyle(
        elevation: elevation ?? this.elevation,
        stateLayerColor: stateLayerColor ?? this.stateLayerColor,
        shape: shape ?? this.shape,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        shadowColor: shadowColor ?? this.shadowColor,
        elevationTintColor: elevationTintColor ?? this.elevationTintColor,
        foregroundColor: foregroundColor ?? this.foregroundColor,
        padding: padding ?? this.padding,
        mouseCursor: mouseCursor ?? this.mouseCursor,
        borderSide: borderSide ?? this.borderSide,
        clipBehavior: clipBehavior ?? this.clipBehavior,
      );
}

abstract class CardStyleCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final CardStyle? style;
  final Widget child;

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

  CardStyle defaultStyleOf(BuildContext context);
  CardStyle? themeStyleOf(BuildContext context);

  @override
  State<CardStyleCard> createState() => _CardStyleCardState();
}

class _CardStyleCardState extends State<CardStyleCard> with MaterialStateMixin {
  FocusNode? focus;

  @override
  void initState() {
    super.initState();
    focus = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(CardStyleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) {
      return;
    }
    focus!.dispose();
    focus = widget.focusNode ?? FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isBeingDragged =
        InheritedDraggableCardInformation.maybeOf(context) ?? false;
    if (isBeingDragged) {
      materialStates.add(MaterialState.dragged);
    } else {
      materialStates.remove(MaterialState.dragged);
    }
  }

  int _activeMouses = 0;
  bool _wasHovering = false;
  bool get _isHovering => _activeMouses > 0;

  void _onMouseEnter(PointerEvent e) {
    _activeMouses++;
    if (!_isInteractive) {
      _activeMouses = 0;
    }
    if (_wasHovering != _isHovering) {
      _onHoverChange(_isHovering);
    }
  }

  void _onMouseExit(PointerEvent e) {
    _activeMouses--;
    if (!_isInteractive) {
      _activeMouses = 0;
    }
    if (_wasHovering != _isHovering) {
      _onHoverChange(_isHovering);
    }
  }

  int _activeLongPresses = 0;
  void _onLongPressDown(LongPressStartDetails e) {
    _activeLongPresses++;
    if (!_isInteractive) {
      _activeLongPresses = 0;
    }
    setMaterialState(MaterialState.pressed, _activeLongPresses > 0);
  }

  void _onHoverChange(bool hover) {
    setMaterialState(MaterialState.hovered, hover);
    _wasHovering = hover;
    widget.onHover?.call(hover);
  }

  void _onFocusChange(bool focus) {
    setMaterialState(MaterialState.focused, focus);
    widget.onFocusChange?.call(focus);
  }

  void _onLongPressUp(LongPressEndDetails e) {
    _activeLongPresses--;
    if (!_isInteractive) {
      _activeLongPresses = 0;
    }
    setMaterialState(MaterialState.pressed, _activeLongPresses > 0);
  }

  bool get _isInteractive =>
      widget.onPressed != null || widget.onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final style = widget
        .defaultStyleOf(context)
        .merge(widget.themeStyleOf(context)!)
        .merge(widget.style ?? CardStyle());
    return GestureDetector(
      onLongPressStart: _onLongPressDown,
      onLongPressEnd: _onLongPressUp,
      behavior: HitTestBehavior.translucent,
      child: MouseRegion(
        onEnter: _onMouseEnter,
        onExit: _onMouseExit,
        cursor: style.mouseCursor?.resolve(materialStates) ?? MouseCursor.defer,
        child: Focus(
          focusNode: focus,
          onFocusChange: _onFocusChange,
          child: _buildCard(style),
        ),
      ),
    );
  }

  Widget _foreground(Color color, {required Widget child}) =>
      DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: IconTheme.merge(
          data: IconThemeData(
            color: color,
          ),
          child: child,
        ),
      );

  Card _buildCard(CardStyle style) {
    final shape = style.shape!.resolve(materialStates);
    final elevation = style.elevation!.resolve(materialStates);
    final foreground = style.foregroundColor!.resolve(materialStates);
    final backgroundColor = style.backgroundColor!.resolve(materialStates);
    final tintColor = style.elevationTintColor?.resolve(materialStates);
    final borderSide = style.borderSide?.resolve(materialStates);

    return Card(
      color: tintColor == null
          ? backgroundColor
          : elevation.overlaidColor(
              backgroundColor,
              tintColor,
            ),
      elevation: elevation.value,
      shape: shape.copyWith(side: borderSide),
      shadowColor: style.shadowColor!.resolve(materialStates),
      margin: EdgeInsets.zero,
      clipBehavior: style.clipBehavior ?? Clip.none,
      child: InkWell(
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        overlayColor: style.stateLayerColor,
        highlightColor: Colors.transparent,
        customBorder: shape,
        child: Padding(
          padding: style.padding?.resolve(materialStates) ?? EdgeInsets.zero,
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
}
