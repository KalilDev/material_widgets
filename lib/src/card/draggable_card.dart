import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import '../monadic_value_listenable.dart';

class InheritedDraggableCardInformation extends InheritedWidget {
  const InheritedDraggableCardInformation({
    Key key,
    @required this.isBeingDragged,
    @required Widget child,
  }) : super(key: key, child: child);

  final bool isBeingDragged;

  @override
  bool updateShouldNotify(InheritedDraggableCardInformation oldWidget) =>
      isBeingDragged != oldWidget.isBeingDragged;

  static Widget shadow({@required Widget child}) =>
      InheritedDraggableCardInformation(
        isBeingDragged: false,
        child: child,
      );

  static bool maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<InheritedDraggableCardInformation>()
      ?.isBeingDragged;
}

class DraggableCard<T extends Object> extends StatefulWidget {
  const DraggableCard({
    Key key,
    @required this.child,
    this.data,
    this.axis,
    this.dragAnchorStrategy,
    this.affinity,
    this.maxSimultaneousDrags,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
    this.rootOverlay = false,
    this.hitTestBehavior = HitTestBehavior.deferToChild,
    this.canDrag = true,
  })  : assert(child != null),
        assert(maxSimultaneousDrags == null || maxSimultaneousDrags >= 0),
        super(key: key);

  final T data;

  final Axis axis;

  final Widget child;

  final DragAnchorStrategy dragAnchorStrategy;

  final Axis affinity;

  final int maxSimultaneousDrags;

  final VoidCallback onDragStarted;

  final DragUpdateCallback onDragUpdate;

  final DraggableCanceledCallback onDraggableCanceled;

  final VoidCallback onDragCompleted;

  final DragEndCallback onDragEnd;

  final bool rootOverlay;

  final HitTestBehavior hitTestBehavior;
  final bool canDrag;

  @override
  State<DraggableCard<T>> createState() => _DraggableCardState<T>();
}

class _DraggableSizedChild extends StatefulWidget {
  _DraggableSizedChild({
    @required this.size,
    @required this.duration,
    @required this.child,
  }) : super(key: ObjectKey(size));
  final ValueNotifier<Size> size;
  final Duration duration;
  final Widget child;

  @override
  __DraggableSizedChildState createState() => __DraggableSizedChildState();
}

class __DraggableSizedChildState extends State<_DraggableSizedChild>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Size _size;
  Animation<Size> _sizeAnimation;

  void _onSizeChange() {
    if (_size == null) {
      _size = widget.size.value;
      _sizeAnimation = AlwaysStoppedAnimation(_size);

      setState(() {});
      return;
    }
    // If we already had an size, animate to the new size
    final tween =
        SizeTween(begin: _sizeAnimation.value, end: widget.size.value);
    _size = widget.size.value;
    _sizeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
            .drive(tween);
    _controller.forward(from: 0);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    widget.size.addListener(_onSizeChange);
    _size = widget.size.value;
    _sizeAnimation = AlwaysStoppedAnimation(_size);
  }

  void didUpdateWidget(_DraggableSizedChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration == widget.duration) {
      return;
    }
    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    widget.size.removeListener(_onSizeChange);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Size>(
      valueListenable: _sizeAnimation,
      builder: (context, size, _) => SizedBox.fromSize(
        size: size ?? Size.zero,
        child: widget.child,
      ),
    );
  }
}

class _DraggableReturnFlightWidget extends StatefulWidget {
  const _DraggableReturnFlightWidget({
    Key key,
    @required this.initialOffset,
    @required this.initialVelocity,
    @required this.target,
    @required this.close,
    @required this.child,
  }) : super(key: key);
  final Offset initialOffset;
  final Offset initialVelocity;
  final Offset target;
  final VoidCallback close;
  final Widget child;

  @override
  __DraggableReturnFlightWidgetState createState() =>
      __DraggableReturnFlightWidgetState();
}

class __DraggableReturnFlightWidgetState
    extends State<_DraggableReturnFlightWidget>
    with SingleTickerProviderStateMixin {
  Offset velocity;

  AnimationController _controller;
  static const double kPixelsPerSecond = 800;
  static const double kVelocityPerPixel = 1 / kPixelsPerSecond;
  Animation<Offset> p0;
  //Animation<Offset> p1;
  Animation<Offset> p2;
  ValueListenable<Offset> point;

  @override
  void initState() {
    super.initState();
    p0 = AlwaysStoppedAnimation(widget.initialOffset);
    p2 = AlwaysStoppedAnimation(widget.target);
    final p0ToP2 = p2.value - p0.value;
    final duration = Duration(seconds: 1) * kVelocityPerPixel * p0ToP2.distance;
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    /*final point1Distance =
        widget.initialVelocity * 0.5 * (duration.inMilliseconds / 1000);*/
    //p1 = AlwaysStoppedAnimation(widget.initialOffset + point1Distance);
    point = buildPoint(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward().whenCompleteOrCancel(widget.close);
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ValueListenable<Offset> buildPoint(Animation<double> parent) => parent.bind(
        (t) => p0.bind(
          (p0) => /*p1.bind(
            (p1) =>*/
              p2.map(
            (p2) {
              /*final p0ToP1 = p1 - p0;
                final p1ToP2 = p2 - p1;*/
              final p0ToP2 = p2 - p0;

              //return p0 + (p0ToP1 * t) + (p1ToP2 * t);
              return p0 + (p0ToP2 * t);
            },
          ),
          //),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: point,
      builder: (context, position, _) => Positioned(
        top: position.dy,
        left: position.dx,
        child: widget.child,
      ),
    );
  }
}

class _DraggableCardState<T extends Object> extends State<DraggableCard<T>>
    with SingleTickerProviderStateMixin {
  final _childKey = GlobalKey();
  final _referenceChildKey = GlobalKey();
  bool _isBeingDragged = false;
  final _childSize = ValueNotifier<Size>(null);

  bool _isReturning = false;

  void _setDragged(bool isBeingDragged) {
    if (_isBeingDragged == isBeingDragged) {
      return;
    }
    setState(() => _isBeingDragged = isBeingDragged);
  }

  Offset _getChildOrigin() {
    final childKey = _isBeingDragged ? _referenceChildKey : _childKey;
    final renderBox = childKey.currentContext.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  Size _getChildSize() {
    final childKey = _isBeingDragged ? _referenceChildKey : _childKey;
    final renderBox = childKey.currentContext.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  void _onDragStarted() {
    _updateChildSize();
    _setDragged(true);
    widget.onDragStarted?.call();
  }

  void _startReturn(DraggableDetails details) {
    setState(() => _isReturning = true);
    final target = _getChildOrigin();
    final manager = Overlay.of(context);
    OverlayEntry overlay;
    void close() {
      overlay.remove();
      setState(() => _isReturning = false);
      _setDragged(false);
    }

    Widget _returnBuilder(BuildContext context) {
      return _DraggableReturnFlightWidget(
        initialOffset: details.offset,
        initialVelocity: details.velocity.pixelsPerSecond,
        target: target,
        close: close,
        child: _DraggableSizedChild(
          size: _childSize,
          duration: Duration(milliseconds: 400),
          child: InheritedDraggableCardInformation(
            isBeingDragged: true,
            child: KeyedSubtree(
              key: _childKey,
              child: widget.child,
            ),
          ),
        ),
      );
    }

    manager.insert(overlay = OverlayEntry(builder: _returnBuilder));
  }

  void _onDragEnd(DraggableDetails details) {
    widget.onDragEnd?.call(details);
    _startReturn(details);
  }

  void _updateChildSize() {
    final newSize = _getChildSize();
    if (newSize == _childSize) {
      return;
    }

    // We need to set state because if there was no size, and [_onDragStarted]
    // is called, even tho we call setState, the feedback widget will still have
    // the old size.
    // TODO: Maybe an size ValueNotifier in an child, in order to avoid some
    // rebuilds?
    setState(() => _childSize.value = newSize);
  }

  void _scheduleChildSizeUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateChildSize());
  }

  @override
  Widget build(BuildContext context) {
    _scheduleChildSizeUpdate();
    final referenceChild = KeyedSubtree(
      key: _referenceChildKey,
      child: widget.child,
    );
    final keyedChild = KeyedSubtree(
      key: _childKey,
      child: widget.child,
    );
    final hiddenChild = Opacity(
      opacity: 0.0,
      child: referenceChild,
    );
    return Draggable<T>(
      data: widget.data,
      axis: widget.axis,
      dragAnchorStrategy: widget.dragAnchorStrategy,
      affinity: widget.affinity,
      maxSimultaneousDrags: widget.canDrag ? 1 : 0,
      onDragStarted: _onDragStarted,
      onDragUpdate: widget.onDragUpdate,
      onDraggableCanceled: widget.onDraggableCanceled,
      onDragEnd: _onDragEnd,
      onDragCompleted: widget.onDragCompleted,
      ignoringFeedbackSemantics: true,
      rootOverlay: widget.rootOverlay,
      feedback: _DraggableSizedChild(
        size: _childSize,
        duration: Duration(milliseconds: 800),
        child: InheritedDraggableCardInformation(
          isBeingDragged: true,
          child: keyedChild,
        ),
      ),
      childWhenDragging: hiddenChild,
      hitTestBehavior: widget.hitTestBehavior,
      child: _isReturning
          ? hiddenChild
          : InheritedDraggableCardInformation(
              isBeingDragged: false,
              child: keyedChild,
            ),
    );
  }
}
