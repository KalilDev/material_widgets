import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

const double _kTrackHeight = 28.0;
const double _kTrackWidth = 56.0;
const double _kTrackRadius = _kTrackHeight / 2.0;
const double _kThumbRadius = 10.0;
const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;
const double _kSwitchWidth = _kTrackWidth - 2 * _kTrackRadius + _kSwitchMinSize;
const double _kSwitchHeight = _kSwitchMinSize + 8.0;
const double _kSwitchHeightCollapsed = _kSwitchMinSize;

class MD3Switch extends StatelessWidget {
  const MD3Switch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.thumbColor,
    this.trackColor,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false,
  })  : assert(dragStartBehavior != null),
        super(key: key);

  final bool value;

  final ValueChanged<bool>? onChanged;

  final MaterialStateProperty<Color?>? thumbColor;

  final MaterialStateProperty<Color?>? trackColor;

  final MaterialTapTargetSize? materialTapTargetSize;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  final MouseCursor? mouseCursor;

  final MaterialStateProperty<Color?>? overlayColor;

  final double? splashRadius;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  Size _getSwitchSize(ThemeData theme) {
    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        materialTapTargetSize ??
            theme.switchTheme.materialTapTargetSize ??
            theme.materialTapTargetSize;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        return const Size(_kSwitchWidth, _kSwitchHeight);
      case MaterialTapTargetSize.shrinkWrap:
        return const Size(_kSwitchWidth, _kSwitchHeightCollapsed);
    }
  }

  Widget _buildMaterialSwitch(BuildContext context) {
    return _Switch(
      value: value,
      onChanged: onChanged,
      size: _getSwitchSize(Theme.of(context)),
      thumbColor: thumbColor,
      trackColor: trackColor,
      materialTapTargetSize: materialTapTargetSize,
      dragStartBehavior: dragStartBehavior,
      mouseCursor: mouseCursor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMaterialSwitch(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value',
        value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
  }
}

class _Switch extends StatefulWidget {
  const _Switch({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.size,
    this.thumbColor,
    this.trackColor,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false,
  })  : assert(dragStartBehavior != null),
        super(key: key);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final MaterialStateProperty<Color?>? thumbColor;
  final MaterialStateProperty<Color?>? trackColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final DragStartBehavior dragStartBehavior;
  final MouseCursor? mouseCursor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;
  final Size size;

  @override
  State<StatefulWidget> createState() => _SwitchState();
}

class _SwitchState extends State<_Switch>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _SwitchPainter _painter = _SwitchPainter();

  @override
  void didUpdateWidget(_Switch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      // During a drag we may have modified the curve, reset it if its possible
      // to do without visual discontinuation.
      if (position.value == 0.0 || position.value == 1.0) {
        position
          ..curve = Curves.easeIn
          ..reverseCurve = Curves.easeOut;
      }
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  MaterialStateProperty<Color> get _defaultThumbColor {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final colorScheme = context.colorScheme;

    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return colorScheme.onSurface.withOpacity(0.38);
      }
      if (states.contains(MaterialState.selected)) {
        return colorScheme.onPrimary;
      }
      return colorScheme.onPrimary.withOpacity(0.8);
    });
  }

  MaterialStateProperty<Color> get _defaultTrackColor {
    final colorScheme = context.colorScheme;

    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return colorScheme.onSurface.withOpacity(0.12);
      }
      if (states.contains(MaterialState.selected)) {
        return colorScheme.primary;
      }
      return colorScheme.surfaceVariant;
    });
  }

  double get _trackInnerLength => widget.size.width - _kSwitchMinSize;

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta = details.primaryDelta! / _trackInnerLength;
      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          positionController.value -= delta;
          break;
        case TextDirection.ltr:
          positionController.value += delta;
          break;
      }
    }
  }

  bool _needsPositionAnimation = false;

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged!(!widget.value);
      // Wait with finishing the animation until widget.value has changed to
      // !widget.value as part of the widget.onChanged call above.
      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }
    reactionController.reverse();
  }

  void _handleChanged(bool? value) {
    assert(value != null);
    assert(widget.onChanged != null);
    widget.onChanged!(value!);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));

    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final ThemeData theme = Theme.of(context);

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states
      ..remove(MaterialState.selected);
    final Color effectiveActiveThumbColor =
        widget.thumbColor?.resolve(activeStates) ??
            theme.switchTheme.thumbColor?.resolve(activeStates) ??
            _defaultThumbColor.resolve(activeStates);
    final Color effectiveInactiveThumbColor =
        widget.thumbColor?.resolve(inactiveStates) ??
            theme.switchTheme.thumbColor?.resolve(inactiveStates) ??
            _defaultThumbColor.resolve(inactiveStates);
    final Color effectiveActiveTrackColor =
        widget.trackColor?.resolve(activeStates) ??
            theme.switchTheme.trackColor?.resolve(activeStates) ??
            _defaultTrackColor.resolve(activeStates);
    final Color effectiveInactiveTrackColor =
        widget.trackColor?.resolve(inactiveStates) ??
            theme.switchTheme.trackColor?.resolve(inactiveStates) ??
            _defaultTrackColor.resolve(inactiveStates);

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor =
        widget.overlayColor?.resolve(focusedStates) ??
            theme.switchTheme.overlayColor?.resolve(focusedStates) ??
            theme.focusColor;

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor =
        widget.overlayColor?.resolve(hoveredStates) ??
            theme.switchTheme.overlayColor?.resolve(hoveredStates) ??
            theme.hoverColor;

    final Set<MaterialState> activePressedStates = activeStates
      ..add(MaterialState.pressed);
    final Color effectiveActivePressedOverlayColor =
        widget.overlayColor?.resolve(activePressedStates) ??
            theme.switchTheme.overlayColor?.resolve(activePressedStates) ??
            effectiveActiveThumbColor.withAlpha(kRadialReactionAlpha);

    final Set<MaterialState> inactivePressedStates = inactiveStates
      ..add(MaterialState.pressed);
    final Color effectiveInactivePressedOverlayColor =
        widget.overlayColor?.resolve(inactivePressedStates) ??
            theme.switchTheme.overlayColor?.resolve(inactivePressedStates) ??
            effectiveActiveThumbColor.withAlpha(kRadialReactionAlpha);

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor =
        MaterialStateProperty.resolveWith<MouseCursor>(
            (Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(
              widget.mouseCursor, states) ??
          theme.switchTheme.mouseCursor?.resolve(states) ??
          MaterialStateProperty.resolveAs<MouseCursor>(
              MaterialStateMouseCursor.clickable, states);
    });

    return Semantics(
      toggled: widget.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        dragStartBehavior: widget.dragStartBehavior,
        child: buildToggleable(
          mouseCursor: effectiveMouseCursor,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          size: widget.size,
          painter: _painter
            ..position = position
            ..reaction = reaction
            ..reactionFocusFade = reactionFocusFade
            ..reactionHoverFade = reactionHoverFade
            ..inactiveReactionColor = effectiveInactivePressedOverlayColor
            ..reactionColor = effectiveActivePressedOverlayColor
            ..hoverColor = effectiveHoverOverlayColor
            ..focusColor = effectiveFocusOverlayColor
            ..splashRadius = widget.splashRadius ??
                theme.switchTheme.splashRadius ??
                kRadialReactionRadius
            ..downPosition = downPosition
            ..isFocused = states.contains(MaterialState.focused)
            ..isHovered = states.contains(MaterialState.hovered)
            ..activeColor = effectiveActiveThumbColor
            ..inactiveColor = effectiveInactiveThumbColor
            ..activeTrackColor = effectiveActiveTrackColor
            ..inactiveTrackColor = effectiveInactiveTrackColor
            ..isInteractive = isInteractive
            ..trackInnerLength = _trackInnerLength
            ..textDirection = Directionality.of(context)
            ..surfaceColor = theme.colorScheme.surface,
        ),
      ),
    );
  }
}

class _SwitchPainter extends ToggleablePainter {
  Color get activeTrackColor => _activeTrackColor!;
  Color? _activeTrackColor;
  set activeTrackColor(Color value) {
    assert(value != null);
    if (value == _activeTrackColor) return;
    _activeTrackColor = value;
    notifyListeners();
  }

  Color get inactiveTrackColor => _inactiveTrackColor!;
  Color? _inactiveTrackColor;
  set inactiveTrackColor(Color value) {
    assert(value != null);
    if (value == _inactiveTrackColor) return;
    _inactiveTrackColor = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;
  set textDirection(TextDirection value) {
    assert(value != null);
    if (_textDirection == value) return;
    _textDirection = value;
    notifyListeners();
  }

  Color get surfaceColor => _surfaceColor!;
  Color? _surfaceColor;
  set surfaceColor(Color value) {
    assert(value != null);
    if (value == _surfaceColor) return;
    _surfaceColor = value;
    notifyListeners();
  }

  bool get isInteractive => _isInteractive!;
  bool? _isInteractive;
  set isInteractive(bool value) {
    if (value == _isInteractive) {
      return;
    }
    _isInteractive = value;
    notifyListeners();
  }

  double get trackInnerLength => _trackInnerLength!;
  double? _trackInnerLength;
  set trackInnerLength(double value) {
    if (value == _trackInnerLength) {
      return;
    }
    _trackInnerLength = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double currentValue = position.value;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    final Color trackColor =
        Color.lerp(inactiveTrackColor, activeTrackColor, currentValue)!;
    final Color lerpedThumbColor =
        Color.lerp(inactiveColor, activeColor, currentValue)!;
    // Blend the thumb color against a `surfaceColor` background in case the
    // thumbColor is not opaque. This way we do not see through the thumb to the
    // track underneath.
    final Color thumbColor = Color.alphaBlend(lerpedThumbColor, surfaceColor);

    final Paint paint = Paint()..color = trackColor;

    final Offset trackPaintOffset =
        _computeTrackPaintOffset(size, _kTrackWidth, _kTrackHeight);
    final Offset thumbPaintOffset =
        _computeThumbPaintOffset(trackPaintOffset, visualPosition);
    final Offset radialReactionOrigin =
        Offset(thumbPaintOffset.dx + _kThumbRadius, size.height / 2);

    _paintTrackWith(canvas, paint, trackPaintOffset);
    paintRadialReaction(canvas: canvas, origin: radialReactionOrigin);
    _paintThumbWith(
      thumbPaintOffset,
      canvas,
      currentValue,
      thumbColor,
    );
  }

  /// Computes canvas offset for track's upper left corner
  Offset _computeTrackPaintOffset(
      Size canvasSize, double trackWidth, double trackHeight) {
    final double horizontalOffset = (canvasSize.width - _kTrackWidth) / 2.0;
    final double verticalOffset = (canvasSize.height - _kTrackHeight) / 2.0;

    return Offset(horizontalOffset, verticalOffset);
  }

  /// Computes canvas offset for thumb's upper left corner as if it were a
  /// square
  Offset _computeThumbPaintOffset(
      Offset trackPaintOffset, double visualPosition) {
    // How much thumb radius extends beyond the track
    const double additionalThumbRadius = _kThumbRadius - _kTrackRadius;

    final double horizontalProgress = visualPosition * trackInnerLength;
    final double thumbHorizontalOffset =
        trackPaintOffset.dx - additionalThumbRadius + horizontalProgress;
    final double thumbVerticalOffset =
        trackPaintOffset.dy - additionalThumbRadius;

    return Offset(thumbHorizontalOffset, thumbVerticalOffset);
  }

  void _paintTrackWith(Canvas canvas, Paint paint, Offset trackPaintOffset) {
    final Rect trackRect = Rect.fromLTWH(
      trackPaintOffset.dx,
      trackPaintOffset.dy,
      _kTrackWidth,
      _kTrackHeight,
    );
    final RRect trackRRect = RRect.fromRectAndRadius(
      trackRect,
      const Radius.circular(_kTrackRadius),
    );

    canvas.drawRRect(trackRRect, paint);
  }

  void _paintThumbWith(
    Offset thumbPaintOffset,
    Canvas canvas,
    double currentValue,
    Color thumbColor,
  ) {
    const radius = _kThumbRadius;
    canvas.drawCircle(
      thumbPaintOffset + Offset(0 + radius, radius),
      radius,
      Paint()..color = thumbColor,
    );
  }
}
