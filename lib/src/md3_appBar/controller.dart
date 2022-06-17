import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_appBar/size_scope.dart';

class MD3AppBarScope extends InheritedWidget implements PreferredSizeWidget {
  const MD3AppBarScope({
    Key? key,
    required this.isScrolledUnder,
    required Widget child,
  }) : super(key: key, child: child);

  final ValueListenable<bool> isScrolledUnder;

  @override
  bool updateShouldNotify(MD3AppBarScope oldWidget) =>
      isScrolledUnder != oldWidget.isScrolledUnder;
  static MD3AppBarScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MD3AppBarScope>()!;

  static MD3AppBarScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MD3AppBarScope>();

  @override
  Size get preferredSize {
    final child = this.child;
    if (child is PreferredSizeWidget) {
      return child.preferredSize;
    }
    return Size.zero;
  }
}

class MD3AppBarControllerScope extends InheritedWidget {
  const MD3AppBarControllerScope({
    Key? key,
    required this.isTopScrolledUnder,
    required this.isBottomScrolledUnder,
    required this.isLeftScrolledUnder,
    required this.isRightScrolledUnder,
    required Widget child,
  }) : super(key: key, child: child);

  final ValueListenable<bool> isTopScrolledUnder;
  final ValueListenable<bool> isBottomScrolledUnder;
  final ValueListenable<bool> isLeftScrolledUnder;
  final ValueListenable<bool> isRightScrolledUnder;

  @override
  bool updateShouldNotify(MD3AppBarControllerScope oldWidget) =>
      isTopScrolledUnder != oldWidget.isTopScrolledUnder ||
      isBottomScrolledUnder != oldWidget.isBottomScrolledUnder ||
      isLeftScrolledUnder != oldWidget.isLeftScrolledUnder ||
      isRightScrolledUnder != oldWidget.isRightScrolledUnder;

  static MD3AppBarControllerScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MD3AppBarControllerScope>()!;
}

/// An controller installed at the scaffold that notifies wheter the managed
/// MD3Appbars are being scrolled under or not.
class MD3AppBarController extends StatefulWidget {
  const MD3AppBarController({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  MD3AppBarControllerState createState() => MD3AppBarControllerState();
}

class MD3AppBarControllerState extends State<MD3AppBarController> {
  final ValueNotifier<bool> _isTopScrolledUnder = ValueNotifier(false);
  final ValueNotifier<bool> _isBottomScrolledUnder = ValueNotifier(false);
  final ValueNotifier<bool> _isLeftScrolledUnder = ValueNotifier(false);
  final ValueNotifier<bool> _isRightScrolledUnder = ValueNotifier(false);

  /* 
   Expose only an view to the values. TODO: Wrap on an proper ValueListenable,
   so the values cannot be modified with an cast to ValueNotifier
   */

  late final ValueListenable<bool> isTopScrolledUnder = _isTopScrolledUnder;
  late final ValueListenable<bool> isBottomScrolledUnder =
      _isBottomScrolledUnder;
  late final ValueListenable<bool> isLeftScrolledUnder = _isLeftScrolledUnder;
  late final ValueListenable<bool> isRightScrolledUnder = _isRightScrolledUnder;

  final ScrollController _ownedScrollController = ScrollController();
  ScrollController? _primaryScrollController;

  /// Use this to update with the spy scroll controller because:
  /// 1. If we used only the scroll controller or position listener callbacks,
  ///    we would not be notified when the ScrollView is changed.
  /// 2. If we only used the scroll metrics notification, we would also act on
  ///    non-primary scrollable views.
  /// 3. If we used scroll metrics notification and the scroll controller, we
  ///    would not be notified when moving from a scrollable to an non
  ///    scrollable view (detaching every attached position).
  ///
  /// Therefore, the solution is forwarding every scroll position attach and
  /// detach event using an [_SpyScrollController], and listening to every
  /// position and positions list update with [_ScrollPositionNotifier]
  final _ScrollPositionNotifier scrollPositionNotifier =
      _ScrollPositionNotifier();
  late _SpyScrollController _spyScrollController;
  ScrollController get _baseController =>
      _primaryScrollController ?? _ownedScrollController;

  @override
  void initState() {
    super.initState();
    scrollPositionNotifier.addListener(_onScrollPositionUpdate);
    _spyScrollController =
        _SpyScrollController(scrollPositionNotifier, _baseController);
  }

  void _onScrollPositionUpdate() {
    _updateFromScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final primaryScrollController = PrimaryScrollController.of(context);
    if (_primaryScrollController == primaryScrollController) {
      return;
    }
    _primaryScrollController = primaryScrollController;
    _spyScrollController =
        _SpyScrollController(scrollPositionNotifier, _baseController);
    _updateFromScrollController();
  }

  @override
  void dispose() {
    _primaryScrollController = null;
    _ownedScrollController.dispose();
    scrollPositionNotifier.dispose();
    super.dispose();
  }

  static void _maybeSet(ValueNotifier<bool> notifier, bool value) {
    if (notifier.value == value) {
      return;
    }
    notifier.value = value;
  }

  void _updateFromMetrics(ScrollMetrics metrics) {
    final hasBefore = metrics.extentBefore > 0;
    final hasAfter = metrics.extentAfter > 0;
    switch (metrics.axisDirection) {
      case AxisDirection.up:
        _maybeSet(_isTopScrolledUnder, hasAfter);
        _maybeSet(_isBottomScrolledUnder, hasBefore);
        break;
      case AxisDirection.right:
        _maybeSet(_isLeftScrolledUnder, hasBefore);
        _maybeSet(_isRightScrolledUnder, hasAfter);
        break;
      case AxisDirection.down:
        _maybeSet(_isTopScrolledUnder, hasBefore);
        _maybeSet(_isBottomScrolledUnder, hasAfter);
        break;
      case AxisDirection.left:
        _maybeSet(_isLeftScrolledUnder, hasAfter);
        _maybeSet(_isRightScrolledUnder, hasBefore);
        break;
    }
  }

  void _setFalse() {
    _isLeftScrolledUnder.value = false;
    _isTopScrolledUnder.value = false;
    _isRightScrolledUnder.value = false;
    _isBottomScrolledUnder.value = false;
  }

  void _updateFromScrollController() {
    final scrollController = _baseController;
    if (scrollController == null || !scrollController.hasClients) {
      _setFalse();
      /* print(
          'DEBUG: Setting all to false because there is no position attached');*/
      return;
    }
    final positions = scrollController.positions;
    if (positions.length > 1) {
      _setFalse();
      /*print(
          'DEBUG: Setting all to false because there is more than one position attached');*/
      return;
    }
    final position = positions.single;
    _updateFromMetrics(position);
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryScrollController(
      controller: _spyScrollController,
      child: MD3AppBarControllerScope(
        isBottomScrolledUnder: _isBottomScrolledUnder,
        isLeftScrolledUnder: _isLeftScrolledUnder,
        isRightScrolledUnder: _isRightScrolledUnder,
        isTopScrolledUnder: _isTopScrolledUnder,
        child: widget.child,
      ),
    );
  }
}

class _ScrollPositionNotifier extends ChangeNotifier {
  final Set<ScrollPosition> positions = {};

  void setFrom(Iterable<ScrollPosition> positions) {
    final didChange = this.positions.isNotEmpty || positions.isNotEmpty;
    for (final p in this.positions) {
      p.removeListener(notifyListeners);
    }
    this.positions.clear();
    this.positions.addAll(positions);
    for (final p in positions) {
      p.addListener(notifyListeners);
    }
    if (didChange) {
      notifyListeners();
    }
  }

  void attach(ScrollPosition position) {
    if (positions.add(position)) {
      position.addListener(notifyListeners);
      notifyListeners();
    }
  }

  void detach(ScrollPosition position) {
    if (positions.remove(position)) {
      position.removeListener(notifyListeners);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    positions.clear();
  }
}

// An scroll controller which notifies an _ScrollPositionNotifier of the
// scroll position related actions on _base. This is an const object to ensure
// that changing the base recreates the spy controller and propagates the info
// down the tree, as there is an equality check on PrimaryScrollController.
class _SpyScrollController implements ScrollController {
  const _SpyScrollController(this.scrollPositionNotifier, this._base);

  final ScrollController _base;
  final _ScrollPositionNotifier scrollPositionNotifier;

  @override
  void addListener(VoidCallback listener) => _base.addListener(listener);

  @override
  Future<void> animateTo(double offset,
          {required Duration duration, required Curve curve}) =>
      _base.animateTo(offset, duration: duration, curve: curve);

  @override
  void attach(ScrollPosition position) {
    _base.attach(position);
    scrollPositionNotifier.attach(position);
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return _base.createScrollPosition(physics, context, oldPosition);
  }

  @override
  void debugFillDescription(List<String> description) =>
      _base.debugFillDescription(description);

  @override
  String? get debugLabel => _base.debugLabel;

  @override
  void detach(ScrollPosition position) {
    _base.detach(position);
    scrollPositionNotifier.detach(position);
  }

  @override
  void dispose() {
    _base.dispose();
  }

  @override
  bool get hasClients => _base.hasClients;

  @override
  bool get hasListeners => _base.hasListeners;

  @override
  double get initialScrollOffset => _base.initialScrollOffset;

  @override
  void jumpTo(double value) => _base.jumpTo(value);

  @override
  bool get keepScrollOffset => _base.keepScrollOffset;

  @override
  void notifyListeners() => _base.notifyListeners();

  @override
  double get offset => _base.offset;

  @override
  ScrollPosition get position => _base.position;

  @override
  Iterable<ScrollPosition> get positions => _base.positions;

  @override
  void removeListener(VoidCallback listener) => _base.removeListener(listener);
}
