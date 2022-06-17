import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_switch/md3_switch_style.dart';
import 'package:material_you/material_you.dart';

const double _kTrackHeight = 32.0;
const double _kTrackWidth = 52.0;
const double _kTrackOutlineWidth = 2.0;

const double _kThumbStateLayerSize = 40.0;

const double _kThumbUnselectedHeight = 16.0;
const double _kThumbUnselectedWidth = _kThumbUnselectedHeight;

const double _kThumbSelectedHeightWithIcon = 24.0;
const double _kThumbSelectedWidthWithIcon = _kThumbSelectedHeightWithIcon;

const double _kThumbUnselectedHeightWithIcon = _kThumbSelectedHeightWithIcon;
const double _kThumbUnselectedWidthWithIcon = _kThumbUnselectedHeightWithIcon;

const double _kThumbSelectedHeight = 24.0;
const double _kThumbSelectedWidth = _kThumbSelectedHeight;

const double _kThumbPressedHeight = 28.0;
const double _kThumbPressedWidth = _kThumbPressedHeight;

const double _kSwitchWidth = _kTrackWidth;
const double _kSwitchHeight = _kTrackHeight;

class MD3SwitchTheme extends InheritedWidget {
  MD3SwitchTheme({Key? key, required this.style, required Widget child})
      : super(key: key, child: child);

  final MD3SwitchStyle style;

  @override
  bool updateShouldNotify(MD3SwitchTheme oldWidget) => oldWidget.style != style;

  static MD3SwitchStyle of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MD3SwitchTheme>()?.style ??
      MD3SwitchStyle();
}

class MD3Switch extends StatefulWidget {
  MD3Switch({
    Key? key,
    required this.value,
    required this.onChanged,
    MaterialStateProperty<Color?>? thumbColor,
    MaterialStateProperty<Color?>? trackColor,
    MaterialStateProperty<Color?>? stateLayerColor,
    MaterialStateProperty<Color?>? foregroundColor,
    MaterialStateProperty<BorderSide?>? trackBorder,
    MaterialStateProperty<MouseCursor?>? mouseCursor,
    MaterialStateProperty<OutlinedBorder?>? trackShape,
    MaterialStateProperty<OutlinedBorder?>? thumbShape,
    MaterialStateProperty<OutlinedBorder?>? stateLayerShape,
    MaterialTapTargetSize? materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.autofocus = false,
    this.iconBuilder,
  })  : style = MD3SwitchStyle(
          thumbColor: thumbColor,
          trackColor: trackColor,
          stateLayerColor: stateLayerColor,
          foregroundColor: foregroundColor,
          trackBorder: trackBorder,
          trackShape: trackShape,
          thumbShape: thumbShape,
          stateLayerShape: stateLayerShape,
          mouseCursor: mouseCursor,
          materialTapTargetSize: materialTapTargetSize,
        ),
        assert(dragStartBehavior != null),
        super(key: key);

  final bool value;
  final ValueChanged<bool>? onChanged;
  final MD3SwitchStyle style;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  final Widget Function(BuildContext, Animation<double>)? iconBuilder;

  @override
  State<StatefulWidget> createState() => _MD3SwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('value',
        value: value, ifTrue: 'on', ifFalse: 'off', showName: true));
    properties.add(ObjectFlagProperty<ValueChanged<bool>>(
        'onChanged', onChanged,
        ifNull: 'disabled'));
    properties.add(DiagnosticsProperty<MD3SwitchStyle>("style", style));
  }
}

class _MD3SwitchState extends State<MD3Switch>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _SwitchPainter _painter = _SwitchPainter();
  late Size size;
  bool isPressed = false;

  Size _getSwitchSize(BuildContext context) {
    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        widget.style.materialTapTargetSize ??
            MD3SwitchTheme.of(context).materialTapTargetSize ??
            Theme.of(context).materialTapTargetSize;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        return const Size(_kSwitchWidth, kMinInteractiveDimension);
      case MaterialTapTargetSize.shrinkWrap:
        return const Size(_kSwitchWidth, _kSwitchHeight);
    }
  }

  void didChangeDependencies() {
    size = _getSwitchSize(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MD3Switch oldWidget) {
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

  void _handleDragStart(DragStartDetails details) {
    _onTapDown();
    if (isInteractive) reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = Curves.linear
        ..reverseCurve = null;
      final double delta =
          details.primaryDelta! / (size.width - _kSwitchHeight);
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

  void _onTapDown() {
    setState(() => isPressed = true);
  }

  void _onTapStop() {
    setState(() => isPressed = false);
  }

  void _handleDragEnd(DragEndDetails details) {
    _onTapStop();
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

  MD3SwitchStyle _defaultStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = context.colorScheme;
    return MD3SwitchStyle(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return states.contains(MaterialState.selected)
              ? colorScheme.surface
              : colorScheme.onSurface.withOpacity(0.38);
        }
        return states.contains(MaterialState.selected)
            ? colorScheme.onPrimary
            : colorScheme.outline;
      }),
      trackColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return (states.contains(MaterialState.selected)
                    ? colorScheme.onSurface
                    : colorScheme.surfaceVariant)
                .withOpacity(0.12);
          }
          return states.contains(MaterialState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceVariant;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return (states.contains(MaterialState.selected)
                  ? colorScheme.onSurface
                  : colorScheme.surfaceVariant)
              .withOpacity(0.38);
        }
        return states.contains(MaterialState.selected)
            ? colorScheme.onPrimaryContainer
            : colorScheme.surfaceVariant;
      }),
      stateLayerColor: MD3StateOverlayColor(
        MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.selected)
                ? colorScheme.primary
                : colorScheme.onSurface),
        context.stateOverlayOpacity,
      ),
      trackBorder: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return BorderSide(
              width: _kTrackOutlineWidth,
              color: colorScheme.onSurface.withOpacity(0.12),
            );
          }
          return states.contains(MaterialState.selected)
              ? BorderSide.none
              : BorderSide(
                  width: _kTrackOutlineWidth,
                  color: colorScheme.outline,
                );
        },
      ),
      mouseCursor: MD3DisablableCursor(
        SystemMouseCursors.click,
        SystemMouseCursors.forbidden,
      ),
      trackShape: MaterialStateProperty.all(StadiumBorder()),
      thumbShape: MaterialStateProperty.all(CircleBorder()),
      stateLayerShape: MaterialStateProperty.all(CircleBorder()),
      materialTapTargetSize: theme.materialTapTargetSize,
    );
  }

  MaterialStateProperty<double> get thumbHeight =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return _kThumbPressedHeight;
        }
        if (states.contains(MaterialState.selected)) {
          return widget.iconBuilder != null
              ? _kThumbSelectedHeightWithIcon
              : _kThumbSelectedHeight;
        }
        return widget.iconBuilder != null
            ? _kThumbUnselectedHeightWithIcon
            : _kThumbUnselectedHeight;
      });
  MaterialStateProperty<double> get thumbWidth =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return _kThumbPressedWidth;
        }
        if (states.contains(MaterialState.selected)) {
          return widget.iconBuilder != null
              ? _kThumbSelectedWidthWithIcon
              : _kThumbSelectedWidth;
        }
        return widget.iconBuilder != null
            ? _kThumbUnselectedWidthWithIcon
            : _kThumbUnselectedWidth;
      });

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    final ThemeData theme = Theme.of(context);
    final widgetStyle = widget.style;
    final themeStyle = MD3SwitchTheme.of(context);
    final defaultStyle = _defaultStyle(context);
    T resolve<T extends Object>(
      Set<MaterialState> states,
      MaterialStateProperty<T?>? widget,
      MaterialStateProperty<T?>? theme,
      MaterialStateProperty<T?>? default_,
    ) =>
        (widget?.resolve(states) ??
            theme?.resolve(states) ??
            default_?.resolve(states))!;
    final states = {
      ...this.states,
      if (isPressed && !this.states.contains(MaterialState.disabled))
        MaterialState.pressed,
    };

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states.toSet()
      ..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states.toSet()
      ..remove(MaterialState.selected);

    final activeProperties = _MD3SwitchResolvedProperties(
      thumbColor: resolve(activeStates, widgetStyle.thumbColor,
          themeStyle.thumbColor, defaultStyle.thumbColor),
      trackColor: resolve(activeStates, widgetStyle.trackColor,
          themeStyle.trackColor, defaultStyle.trackColor),
      foregroundColor: resolve(activeStates, widgetStyle.foregroundColor,
          themeStyle.foregroundColor, defaultStyle.foregroundColor),
      thumbWidth: thumbWidth.resolve(activeStates),
      thumbHeight: thumbHeight.resolve(activeStates),
      trackShape: resolve(
        activeStates,
        widgetStyle.trackShape,
        themeStyle.trackShape,
        defaultStyle.trackShape,
      ).copyWith(
          side: resolve(
        activeStates,
        widgetStyle.trackBorder,
        themeStyle.trackBorder,
        defaultStyle.trackBorder,
      )),
      thumbShape: resolve(activeStates, widgetStyle.thumbShape,
          themeStyle.thumbShape, defaultStyle.thumbShape),
      stateLayerShape: resolve(activeStates, widgetStyle.stateLayerShape,
          themeStyle.stateLayerShape, defaultStyle.stateLayerShape),
    );
    final inactiveProperties = _MD3SwitchResolvedProperties(
      thumbColor: resolve(inactiveStates, widgetStyle.thumbColor,
          themeStyle.thumbColor, defaultStyle.thumbColor),
      trackColor: resolve(inactiveStates, widgetStyle.trackColor,
          themeStyle.trackColor, defaultStyle.trackColor),
      foregroundColor: resolve(inactiveStates, widgetStyle.foregroundColor,
          themeStyle.foregroundColor, defaultStyle.foregroundColor),
      thumbWidth: thumbWidth.resolve(inactiveStates),
      thumbHeight: thumbHeight.resolve(inactiveStates),
      trackShape: resolve(
        inactiveStates,
        widgetStyle.trackShape,
        themeStyle.trackShape,
        defaultStyle.trackShape,
      ).copyWith(
          side: resolve(
        inactiveStates,
        widgetStyle.trackBorder,
        themeStyle.trackBorder,
        defaultStyle.trackBorder,
      )),
      thumbShape: resolve(inactiveStates, widgetStyle.thumbShape,
          themeStyle.thumbShape, defaultStyle.thumbShape),
      stateLayerShape: resolve(inactiveStates, widgetStyle.stateLayerShape,
          themeStyle.stateLayerShape, defaultStyle.stateLayerShape),
    );

    final Set<MaterialState> focusedStates = states.toSet()
      ..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor = resolve(
        focusedStates,
        widgetStyle.stateLayerColor,
        themeStyle.stateLayerColor,
        defaultStyle.stateLayerColor);

    final Set<MaterialState> hoveredStates = states.toSet()
      ..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor = resolve(
        hoveredStates,
        widgetStyle.stateLayerColor,
        themeStyle.stateLayerColor,
        defaultStyle.stateLayerColor);

    final Set<MaterialState> activePressedStates = activeStates.toSet()
      ..add(MaterialState.pressed);
    final Color effectiveActivePressedOverlayColor = resolve(
        activePressedStates,
        widgetStyle.stateLayerColor,
        themeStyle.stateLayerColor,
        defaultStyle.stateLayerColor);

    final Set<MaterialState> inactivePressedStates = inactiveStates.toSet()
      ..add(MaterialState.pressed);
    final Color effectiveInactivePressedOverlayColor = resolve(
        inactivePressedStates,
        widgetStyle.stateLayerColor,
        themeStyle.stateLayerColor,
        defaultStyle.stateLayerColor);

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor =
        MaterialStateProperty.resolveWith<MouseCursor>(
            (Set<MaterialState> states) {
      return resolve(states, widgetStyle.mouseCursor, themeStyle.mouseCursor,
          defaultStyle.mouseCursor);
    });

    return Semantics(
      toggled: widget.value,
      child: GestureDetector(
        excludeFromSemantics: true,
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        dragStartBehavior: widget.dragStartBehavior,
        child: _MD3SwitchPropertiesAnimator(
          active: activeProperties,
          inactive: inactiveProperties,
          builder: (context, activeProperties, inactiveProperties) =>
              _SwitchAndIconLayout(
            switch_: buildToggleable(
              mouseCursor: effectiveMouseCursor,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              size: size,
              painter: _painter
                ..position = position
                ..reaction = reaction
                ..reactionFocusFade = reactionFocusFade
                ..reactionHoverFade = reactionHoverFade
                ..inactiveReactionColor = effectiveInactivePressedOverlayColor
                ..reactionColor = effectiveActivePressedOverlayColor
                ..hoverColor = effectiveHoverOverlayColor
                ..focusColor = effectiveFocusOverlayColor
                ..splashRadius = _kThumbStateLayerSize / 2
                ..downPosition = downPosition
                ..isFocused = states.contains(MaterialState.focused)
                ..isHovered = states.contains(MaterialState.hovered)
                ..isInteractive = isInteractive
                ..textDirection = Directionality.of(context)
                ..surfaceColor = theme.colorScheme.surface
                ..activeProperties = activeProperties
                ..inactiveProperties = inactiveProperties,
            ),
            position: position,
            size: size,
            thumbWidth: SizeTween(
              begin: Size(
                inactiveProperties.thumbWidth,
                inactiveProperties.thumbHeight,
              ),
              end: Size(
                activeProperties.thumbWidth,
                activeProperties.thumbHeight,
              ),
            ),
            foregroundColor: ColorTween(
                begin: inactiveProperties.foregroundColor,
                end: activeProperties.foregroundColor),
            icon: widget.iconBuilder?.call(context, position),
          ),
        ),
      ),
    );
  }
}

enum _LayoutId {
  switch_,
  icon,
}

class _SwitchAndIconLayout extends StatelessWidget {
  const _SwitchAndIconLayout({
    Key? key,
    required this.switch_,
    this.icon,
    required this.position,
    required this.thumbWidth,
    required this.size,
    required this.foregroundColor,
  }) : super(key: key);
  final Widget switch_;
  final Size size;
  final Animation<double> position;
  final Tween<Color?> foregroundColor;
  final Tween<Size?> thumbWidth;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return switch_;
    }
    return AnimatedBuilder(
      animation: position,
      builder: (context, _) => CustomMultiChildLayout(
        delegate: _SwitchAndIconLayoutDelegate(
          position.value,
          thumbWidth.evaluate(position)!,
          size,
        ),
        children: [
          LayoutId(id: _LayoutId.switch_, child: switch_),
          LayoutId(
            id: _LayoutId.icon,
            child: IconTheme(
              data: IconThemeData(
                color: foregroundColor.evaluate(position),
              ),
              child: IgnorePointer(child: icon!),
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchAndIconLayoutDelegate extends MultiChildLayoutDelegate {
  _SwitchAndIconLayoutDelegate(this.position, this.thumbSize, this.size);

  final double position;
  final Size thumbSize;
  final Size size;

  @override
  Size getSize(BoxConstraints constraints) => constraints.constrain(size);

  @override
  void performLayout(Size size) {
    final realIconSize = layoutChild(
      _LayoutId.icon,
      BoxConstraints.tight(thumbSize),
    );
    final switchSize =
        layoutChild(_LayoutId.switch_, BoxConstraints.tight(size));

    final trackWidth =
        (this.size.width - _kSwitchHeight / 2 + thumbSize.width / 8) / 2;
    final dy = (this.size.height - thumbSize.height) / 2;
    positionChild(_LayoutId.switch_, Offset.zero);
    positionChild(
      _LayoutId.icon,
      Offset(
        trackWidth * position + (this.size.height - thumbSize.width) / 2,
        dy,
      ),
    );
  }

  @override
  bool shouldRelayout(_SwitchAndIconLayoutDelegate oldDelegate) =>
      position != oldDelegate.position ||
      thumbSize != oldDelegate.thumbSize ||
      size != oldDelegate.size;
}

class _MD3SwitchPropertiesAnimator extends StatelessWidget {
  const _MD3SwitchPropertiesAnimator({
    Key? key,
    required this.active,
    required this.inactive,
    required this.builder,
    this.duration = kThemeAnimationDuration,
  }) : super(key: key);

  final _MD3SwitchResolvedProperties active;
  final _MD3SwitchResolvedProperties inactive;
  final Widget Function(
    BuildContext,
    _MD3SwitchResolvedProperties,
    _MD3SwitchResolvedProperties,
  ) builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) =>
      TweenAnimationBuilder<_MD3SwitchResolvedProperties>(
        tween: _MD3SwitchPropertiesTween(end: active),
        duration: duration,
        builder: (context, active, _) =>
            TweenAnimationBuilder<_MD3SwitchResolvedProperties>(
          tween: _MD3SwitchPropertiesTween(end: inactive),
          duration: duration,
          builder: (context, inactive, _) => builder(context, active, inactive),
        ),
      );
}

class _MD3SwitchPropertiesTween extends Tween<_MD3SwitchResolvedProperties> {
  _MD3SwitchPropertiesTween(
      {_MD3SwitchResolvedProperties? begin, _MD3SwitchResolvedProperties? end})
      : super(begin: begin, end: end);
  @override
  _MD3SwitchResolvedProperties transform(double t) =>
      _MD3SwitchResolvedProperties.lerp(begin, end, t)!;
}

class _SwitchPainter extends ToggleablePainter {
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

  _MD3SwitchResolvedProperties get inactiveProperties => _inactiveProperties!;
  _MD3SwitchResolvedProperties? _inactiveProperties;
  set inactiveProperties(_MD3SwitchResolvedProperties value) {
    if (value == _inactiveProperties) {
      return;
    }
    _inactiveProperties = value;
    inactiveColor = value.thumbColor;
    notifyListeners();
  }

  _MD3SwitchResolvedProperties get activeProperties => _activeProperties!;
  _MD3SwitchResolvedProperties? _activeProperties;
  set activeProperties(_MD3SwitchResolvedProperties value) {
    if (value == _activeProperties) {
      return;
    }
    _activeProperties = value;
    activeColor = value.thumbColor;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double currentValue = position.value;
    final properties = _MD3SwitchResolvedProperties.lerp(
      inactiveProperties,
      activeProperties,
      currentValue,
    )!;

    final double visualPosition;
    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
        break;
      case TextDirection.ltr:
        visualPosition = currentValue;
        break;
    }

    // Blend the thumb color against a `surfaceColor` background in case the
    // thumbColor is not opaque. This way we do not see through the thumb to the
    // track underneath.
    final Color thumbColor =
        Color.alphaBlend(properties.thumbColor, surfaceColor);

    final Paint paint = Paint()..color = properties.trackColor;

    final Offset trackPaintOffset = Offset.zero;
    final Offset thumbPaintOffset =
        _computeThumbPaintOffset(trackPaintOffset, visualPosition, properties);
    final Offset radialReactionOrigin = Offset(
      thumbPaintOffset.dx + properties.thumbWidth / 2,
      size.height / 2,
    );

    _paintTrackWith(canvas, paint, properties.trackShape);
    _paintThumbWith(
      thumbPaintOffset,
      Size(properties.thumbWidth, properties.thumbHeight),
      properties.thumbShape,
      canvas,
      thumbColor,
    );
    paintRadialReaction(
      canvas: canvas,
      origin: radialReactionOrigin,
      shape: properties.stateLayerShape,
    );
  }

  @override
  void paintRadialReaction({
    required Canvas canvas,
    Offset offset = Offset.zero,
    required Offset origin,
    OutlinedBorder shape = const CircleBorder(),
  }) {
    if (reaction.isDismissed &&
        reactionFocusFade.isDismissed &&
        reactionHoverFade.isDismissed) {
      return;
    }
    final paint = Paint()
      ..color = Color.lerp(
        Color.lerp(
          Color.lerp(inactiveReactionColor, reactionColor, position.value),
          hoverColor,
          reactionHoverFade.value,
        ),
        focusColor,
        reactionFocusFade.value,
      )!;
    final Offset center =
        Offset.lerp(downPosition ?? origin, origin, reaction.value)!;
    final Animatable<double> radialReactionRadiusTween = Tween<double>(
      begin: 0.0,
      end: splashRadius,
    );
    final double reactionRadius = isFocused || isHovered
        ? splashRadius
        : radialReactionRadiusTween.evaluate(reaction);
    if (reactionRadius > 0.0) {
      final reactionCenter = center + offset;
      final reactionRect =
          Rect.fromCircle(center: reactionCenter, radius: reactionRadius);
      canvas.drawPath(
        shape.getInnerPath(
          reactionRect,
          textDirection: textDirection,
        ),
        paint,
      );
      shape.paint(
        canvas,
        reactionRect,
        textDirection: textDirection,
      );
    }
  }

  /// Computes canvas offset for thumb's upper left corner as if it were a
  /// square
  Offset _computeThumbPaintOffset(
    Offset trackPaintOffset,
    double visualPosition,
    _MD3SwitchResolvedProperties properties,
  ) {
    final start = Offset(
      (_kTrackHeight - properties.thumbWidth) / 2,
      (_kTrackHeight - properties.thumbHeight) / 2,
    );
    final trackInnerLength =
        _kTrackWidth - 2 * start.dx - properties.thumbWidth;

    final double horizontalProgress = visualPosition * trackInnerLength;

    return start.translate(horizontalProgress, 0);
  }

  void _paintTrackWith(
    Canvas canvas,
    Paint paint,
    OutlinedBorder shape,
  ) {
    final Rect trackRect = Rect.fromLTWH(
      0,
      0,
      _kTrackWidth,
      _kTrackHeight,
    );
    canvas.drawPath(
      shape.getInnerPath(
        trackRect,
        textDirection: textDirection,
      ),
      paint,
    );
    shape.paint(
      canvas,
      trackRect,
      textDirection: textDirection,
    );
  }

  void _paintThumbWith(
    Offset thumbPaintOffset,
    Size thumbSize,
    OutlinedBorder thumbShape,
    Canvas canvas,
    Color thumbColor,
  ) {
    final thumbRect = thumbPaintOffset & thumbSize;
    canvas.drawPath(
      thumbShape.getInnerPath(
        thumbRect,
        textDirection: textDirection,
      ),
      Paint()..color = thumbColor,
    );
    thumbShape.paint(
      canvas,
      thumbRect,
      textDirection: textDirection,
    );
  }
}

class _MD3SwitchResolvedProperties {
  final Color thumbColor;
  final Color trackColor;
  final Color foregroundColor;
  final double thumbWidth;
  final double thumbHeight;
  final OutlinedBorder trackShape;
  final OutlinedBorder thumbShape;
  final OutlinedBorder stateLayerShape;
  const _MD3SwitchResolvedProperties({
    required this.thumbColor,
    required this.trackColor,
    required this.foregroundColor,
    required this.thumbWidth,
    required this.thumbHeight,
    required this.trackShape,
    required this.thumbShape,
    required this.stateLayerShape,
  });

  @override
  int get hashCode => Object.hashAll([
        thumbColor,
        trackColor,
        foregroundColor,
        thumbWidth,
        thumbHeight,
        trackShape,
        thumbShape,
        stateLayerShape,
      ]);

  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! _MD3SwitchResolvedProperties) {
      return false;
    }
    return true &&
        thumbColor == other.thumbColor &&
        trackColor == other.trackColor &&
        foregroundColor == other.foregroundColor &&
        thumbWidth == other.thumbWidth &&
        thumbHeight == other.thumbHeight &&
        trackShape == other.trackShape &&
        thumbShape == other.thumbShape &&
        stateLayerShape == other.stateLayerShape;
  }

  static _MD3SwitchResolvedProperties? lerp(_MD3SwitchResolvedProperties? a,
      _MD3SwitchResolvedProperties? b, double t) {
    assert(t != null);
    if (a == null && b == null) return null;
    if (a == null || b == null) return null;
    return _MD3SwitchResolvedProperties(
      thumbColor: Color.lerp(a.thumbColor, b.thumbColor, t)!,
      trackColor: Color.lerp(a.trackColor, b.trackColor, t)!,
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t)!,
      thumbWidth: lerpDouble(a.thumbWidth, b.thumbWidth, t)!,
      thumbHeight: lerpDouble(a.thumbHeight, b.thumbHeight, t)!,
      trackShape: _lerpShape(a.trackShape, b.trackShape, t),
      thumbShape: _lerpShape(a.thumbShape, b.thumbShape, t),
      stateLayerShape: _lerpShape(a.stateLayerShape, b.stateLayerShape, t),
    );
  }

  static OutlinedBorder _lerpShape(
      OutlinedBorder a, OutlinedBorder b, double t) {
    final aToB = a.lerpTo(b, t);
    final bFromA = b.lerpFrom(a, t);
    if (aToB == null && bFromA == null) {
      return t < 0.5 ? a : b;
    }
    if (aToB != null) {
      return aToB as OutlinedBorder;
    }
    return bFromA as OutlinedBorder;
  }
}
