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

  ScrollController? _primaryScrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollController = PrimaryScrollController.of(context);
    if (_primaryScrollController == scrollController) {
      return;
    }
    _primaryScrollController = scrollController;
    _updateFromScrollController();
  }

  @override
  void dispose() {
    _primaryScrollController = null;
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
    final scrollController = _primaryScrollController;
    if (scrollController == null || !scrollController.hasClients) {
      return;
    }
    final positions = scrollController.positions;
    if (positions.length > 1) {
      _setFalse();
      /* print(
          'DEBUG: Setting all to false because there is more than one position attached'); */
      return;
    }
    final position = positions.single;
    _updateFromMetrics(position);
  }

  /// Use this to update with the scroll controller because:
  /// 1. If we used only the scroll controller or position listener callbacks,
  ///    we would not be notified when the ScrollView is changed.
  /// 2. If we only used the notification, we would also act on non-primary
  ///    scrollable views.
  bool _onNotification(ScrollMetricsNotification notification) {
    _updateFromScrollController();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: _onNotification,
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
