import 'package:flutter/material.dart';

// TODO(eseidel): Draw width should vary based on device size:
// https://material.io/design/components/navigation-drawer.html#specs

// Mobile:
// Should not use the Standard drawer, but instead an modal drawer

// Desktop/Tablet:
// Width for a Standard drawer is 256dp.
// The right nav can vary depending on content.

const double _kWidth = 256.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

/// Provides interactive behavior for [Drawer] widgets conforming to the
/// material guidelines for a standard drawer.
///
/// Rarely used directly. Standard Drawer controllers are typically created
/// automatically
/// by [ResponsiveScaffold] widgets.
///
/// The draw controller provides the ability to open and close a drawer via an
/// animation.
///
/// See also:
///
///  * [Drawer], a container with the default width of a drawer.
///  * [Scaffold.drawer], the [Scaffold] slot for showing a drawer.
class StandardDrawerController extends StatefulWidget {
  /// Creates a controller for a [Drawer].
  ///
  /// Rarely used directly.
  ///
  /// The [child] argument must not be null and is typically a [Drawer].
  const StandardDrawerController({
    GlobalKey? key,
    required this.child,
    required this.alignment,
    this.drawerCallback,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Drawer].
  final Widget child;

  /// The alignment of the [Drawer].
  ///
  /// This controls the direction in which the user should swipe to open and
  /// close the drawer.
  final DrawerAlignment alignment;

  /// Optional callback that is called when a [Drawer] is opened or closed.
  final DrawerCallback? drawerCallback;

  @override
  StandardDrawerControllerState createState() =>
      StandardDrawerControllerState();
}

/// State for a [DrawerController].
///
/// Typically used by a [Scaffold] to [open] and [close] the drawer.
class StandardDrawerControllerState extends State<StandardDrawerController>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: _kBaseSettleDuration, vsync: this)
          ..addListener(_animationChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animationChanged() {
    setState(() {
      // The animation controller's state is our build state, and it changed
      // already.
    });
  }

  late AnimationController _controller;

  final GlobalKey _drawerKey = GlobalKey();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  /// Starts an animation to open the drawer.
  ///
  /// Typically called by [ScaffoldState.openDrawer].
  void open() {
    _controller.fling();
    widget.drawerCallback?.call(true);
  }

  /// Starts an animation to close the drawer.
  void close() {
    _controller.fling(velocity: -1.0);
    widget.drawerCallback?.call(false);
  }

  Alignment get _overflowBoxAlignment {
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return Alignment.centerRight;
      case DrawerAlignment.end:
        return Alignment.centerLeft;
    }
  }

  Tween<double> get _drawerSizeTween {
    switch (widget.alignment) {
      case DrawerAlignment.start:
        return Tween(begin: 0, end: _kWidth);
      case DrawerAlignment.end:
        return Tween(begin: 0, end: _kWidth);
    }
  }

  Widget _buildDrawer(BuildContext context) {
    if (_controller.status == AnimationStatus.dismissed) {
      return const SizedBox.shrink();
    } else {
      return RepaintBoundary(
        child: FocusScope(
          key: _drawerKey,
          node: _focusScopeNode,
          child: SizedBox(
            width: _drawerSizeTween.evaluate(_controller),
            child: OverflowBox(
              alignment: _overflowBoxAlignment,
              minWidth: _kWidth,
              maxWidth: _kWidth,
              child: widget.child,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: _buildDrawer(context),
    );
  }
}
