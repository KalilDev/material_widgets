import 'package:flutter/material.dart';

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

class _DraggableCardState<T extends Object> extends State<DraggableCard<T>> {
  final _childKey = GlobalKey();
  final _referenceChildKey = GlobalKey();
  bool _isBeingDragged = false;
  Size _childSize;

  void _setDragged(bool isBeingDragged) {
    if (_isBeingDragged == isBeingDragged) {
      return;
    }
    setState(() => _isBeingDragged = isBeingDragged);
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

  void _onDragEnd(DraggableDetails details) {
    _setDragged(false);
    widget.onDragEnd?.call(details);
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
    setState(() => _childSize = newSize);
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
      feedback: SizedBox.fromSize(
        size: _childSize ?? Size.zero,
        child: InheritedDraggableCardInformation(
          isBeingDragged: true,
          child: keyedChild,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.0,
        child: referenceChild,
      ),
      hitTestBehavior: widget.hitTestBehavior,
      child: InheritedDraggableCardInformation(
        isBeingDragged: false,
        child: keyedChild,
      ),
    );
  }
}
