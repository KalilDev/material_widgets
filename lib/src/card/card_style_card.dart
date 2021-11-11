import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

class CardStyle {
  CardStyle({
    this.elevation,
    this.stateLayerColor,
    this.shape,
    this.backgroundColor,
    this.shadowColor,
    this.elevationTintColor,
    this.padding,
    this.mouseCursor,
  });

  final MaterialStateProperty<MD3ElevationLevel> elevation;
  final MaterialStateProperty<Color> stateLayerColor;
  final MaterialStateProperty<OutlinedBorder> shape;
  final MaterialStateProperty<Color> backgroundColor;
  final MaterialStateProperty<Color> shadowColor;
  final MaterialStateProperty<Color> elevationTintColor;
  final MaterialStateProperty<EdgeInsetsGeometry> padding;
  final MaterialStateProperty<MouseCursor> mouseCursor;

  CardStyle merge(CardStyle other) => CardStyle(
        elevation: other.elevation ?? elevation,
        stateLayerColor: other.stateLayerColor ?? stateLayerColor,
        shape: other.shape ?? shape,
        backgroundColor: other.backgroundColor ?? backgroundColor,
        shadowColor: other.shadowColor ?? shadowColor,
        elevationTintColor: other.elevationTintColor ?? elevationTintColor,
        padding: other.padding ?? padding,
        mouseCursor: other.mouseCursor ?? mouseCursor,
      );

  CardStyle copyWith({
    MaterialStateProperty<MD3ElevationLevel> elevation,
    MaterialStateProperty<Color> stateLayerColor,
    MaterialStateProperty<OutlinedBorder> shape,
    MaterialStateProperty<Color> backgroundColor,
    MaterialStateProperty<Color> shadowColor,
    MaterialStateProperty<Color> elevationTintColor,
    MaterialStateProperty<EdgeInsetsGeometry> padding,
    MaterialStateProperty<MouseCursor> mouseCursor,
  }) =>
      CardStyle(
        elevation: elevation ?? this.elevation,
        stateLayerColor: stateLayerColor ?? this.stateLayerColor,
        shape: shape ?? this.shape,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        shadowColor: shadowColor ?? this.shadowColor,
        elevationTintColor: elevationTintColor ?? this.elevationTintColor,
        padding: padding ?? this.padding,
        mouseCursor: mouseCursor ?? this.mouseCursor,
      );
}

abstract class CardStyleCard extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onHover;
  final ValueChanged<bool> onFocusChange;
  final FocusNode focusNode;
  final CardStyle style;
  final Widget child;

  const CardStyleCard({
    Key key,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.style,
    @required this.child,
  }) : super(key: key);

  CardStyle defaultStyleOf(BuildContext context);
  CardStyle themeStyleOf(BuildContext context);

  @override
  State<CardStyleCard> createState() => _CardStyleCardState();
}

class _CardStyleCardState extends State<CardStyleCard> with MaterialStateMixin {
  FocusNode focus;

  void initState() {
    super.initState();
    focus = widget.focusNode ?? FocusNode();
  }

  void didUpdateWidget(CardStyleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode == widget.focusNode) {
      return;
    }
    focus.dispose();
    focus = widget.focusNode ?? FocusNode();
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
    final style =
        widget.defaultStyleOf(context).merge(widget.themeStyleOf(context));
    return GestureDetector(
      onLongPressStart: _onLongPressDown,
      onLongPressEnd: _onLongPressUp,
      behavior: HitTestBehavior.translucent,
      child: MouseRegion(
        onEnter: _onMouseEnter,
        onExit: _onMouseExit,
        cursor: style.mouseCursor.resolve(materialStates),
        child: Focus(
          focusNode: focus,
          onFocusChange: _onFocusChange,
          child: _buildCard(style),
        ),
      ),
    );
  }

  Card _buildCard(CardStyle style) {
    final shape = style.shape.resolve(materialStates);
    final elevation = style.elevation.resolve(materialStates);

    return Card(
      color: elevation.overlaidColor(
        style.backgroundColor.resolve(materialStates),
        style.elevationTintColor.resolve(materialStates),
      ),
      elevation: elevation.value,
      shape: shape,
      shadowColor: style.shadowColor.resolve(materialStates),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: widget.onPressed,
        onLongPress: widget.onLongPress,
        overlayColor: style.stateLayerColor,
        highlightColor: Colors.transparent,
        customBorder: shape,
        child: Padding(
          padding: style.padding.resolve(materialStates),
          child: widget.child,
        ),
      ),
    );
  }
}
