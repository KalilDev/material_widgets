import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../navigation_drawer.dart';
import '../../standard_drawer_controller.dart';
import '../material_breakpoint.dart';
import '../material_layout.dart';
import 'navigation_spec.dart';
import 'responsive_scaffold_defaults.dart';

part 'resolver.dart';

// ignore_for_file: constant_identifier_names

@Deprecated(
    'Use the newer MD3AdaptativeScaffold or MD3NavigationScaffold instead')
enum ScaffoldBreakpoint {
  Mobile,
  SingleDrawer,
  DualDrawers,
}
@Deprecated(
    'Use the newer MD3AdaptativeScaffold or MD3NavigationScaffold instead')
enum DrawerType {
  Modal,
  Bottom,
  ModalOrBottom,
  StandardOrPersistent,
  Standard,
  Persistent
}

@Deprecated(
    'Use the newer MD3AdaptativeScaffold or MD3NavigationScaffold instead')
class ResponsiveScaffoldDrawer {
  final Widget child;
  final Map<MaterialBreakpoint, DrawerType> types;
  final bool isFullHeight;
  final DrawerType _resolvedType;

  const ResponsiveScaffoldDrawer._(
      {this.child, this.isFullHeight, DrawerType resolvedType})
      : _resolvedType = resolvedType,
        types = null;

  const ResponsiveScaffoldDrawer(
      {this.child,
      Map<MaterialBreakpoint, DrawerType> types,
      this.isFullHeight = true})
      : types = types ?? ResponsiveScaffoldDefaults.responsiveDrawerType,
        _resolvedType = null;

  ResponsiveScaffoldDrawer _resolved(DrawerType type) =>
      ResponsiveScaffoldDrawer._(
          child: child, isFullHeight: isFullHeight, resolvedType: type);
}

@Deprecated(
    'Use the newer MD3AdaptativeScaffold or MD3NavigationScaffold instead')
class ResponsiveScaffold extends StatefulWidget implements Scaffold {
  ResponsiveScaffold({
    Key key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocations =
        ResponsiveScaffoldDefaults.fabPositions,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    Widget drawer,
    ResponsiveScaffoldDrawer responsiveDrawer,
    ResponsiveScaffoldDrawer responsiveEndDrawer,
    Widget endDrawer,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.navigationSpec,
    this.scaffoldBreakpoints = ResponsiveScaffoldDefaults.scaffoldBreakpoints,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
    this.restorationId,
  })  : assert(primary != null),
        assert(extendBody != null),
        assert(extendBodyBehindAppBar != null),
        assert(drawerDragStartBehavior != null),
        assert(scaffoldBreakpoints != null),
        assert(
            drawer == null || responsiveDrawer == null,
            'You should use either one or the other, as the widget version will'
            ' be converted to a responsive one'),
        assert(
            endDrawer == null || responsiveEndDrawer == null,
            'You should use either one or the other, as the widget version will'
            ' be converted to a responsive one'),
        responsiveDrawer = responsiveDrawer ??
            (drawer == null ? null : ResponsiveScaffoldDrawer(child: drawer)),
        responsiveEndDrawer = responsiveEndDrawer ??
            (endDrawer == null
                ? null
                : ResponsiveScaffoldDrawer(
                    child: endDrawer, isFullHeight: false)),
        super(key: key);

  final bool extendBody;

  final bool extendBodyBehindAppBar;

  final PreferredSizeWidget appBar;

  final Widget body;

  final Widget floatingActionButton;

  final Map<MaterialBreakpoint, FloatingActionButtonLocation>
      floatingActionButtonLocations;

  final FloatingActionButtonAnimator floatingActionButtonAnimator;

  final List<Widget> persistentFooterButtons;

  final ResponsiveScaffoldDrawer responsiveDrawer;
  Widget get drawer => responsiveDrawer.child;

  final ResponsiveScaffoldDrawer responsiveEndDrawer;
  Widget get endDrawer => responsiveEndDrawer.child;

  final Color drawerScrimColor;

  final Color backgroundColor;

  final Widget bottomSheet;

  final bool resizeToAvoidBottomInset;

  final bool primary;

  final DragStartBehavior drawerDragStartBehavior;

  final double drawerEdgeDragWidth;

  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final NavigationSpec navigationSpec;
  final Map<MaterialBreakpoint, ScaffoldBreakpoint> scaffoldBreakpoints;
  @override
  ResponsiveScaffoldState createState() => ResponsiveScaffoldState();

  @override
  Widget get bottomNavigationBar => throw StateError(
      'Bottom navigation bar should NOT be used. Use an navigation spec'
      ' instead.');

  @override
  FloatingActionButtonLocation get floatingActionButtonLocation =>
      throw StateError('It cannot be determined until the widget is laid out');

  @override
  final ValueChanged<bool> onDrawerChanged;

  @override
  final ValueChanged<bool> onEndDrawerChanged;

  @override
  final String restorationId;
}

@Deprecated(
    'Use the newer MD3AdaptativeScaffold or MD3NavigationScaffold instead')
class ResponsiveScaffoldState extends State<Scaffold>
    with TickerProviderStateMixin, RestorationMixin
    implements ScaffoldState {
  final _scaffoldKey = GlobalKey<ScaffoldState>(
      debugLabel: 'Scaffold key in the ResponsiveScaffold');
  GlobalKey<StandardDrawerControllerState> _drawerKey;
  GlobalKey<StandardDrawerControllerState> _endDrawerKey;
  _ResponsiveScaffoldResolver _resolvedLayout;

  bool _standardEndDrawerOpen = false;
  bool _standardDrawerOpen = false;

  void _standardEndDrawerChanged(bool open) => _standardEndDrawerOpen = open;
  void _standardDrawerChanged(bool open) => _standardDrawerOpen = open;

  @override
  ResponsiveScaffold get widget => super.widget as ResponsiveScaffold;

  Widget _buildNavRail(BuildContext context, {bool expanded = false}) {
    final items = widget.navigationSpec.items
        .map(NavigationSpec.itemToRailDestination)
        .toList();
    final builder = widget.navigationSpec.navigationRailBuilder ??
        ResponsiveScaffoldDefaults.navigationRailBuilder;
    return builder(context,
        expanded: expanded,
        destinations: items,
        navigationSpec: widget.navigationSpec);
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = widget.navigationSpec.items
        .map(NavigationSpec.itemToBottomNavItem)
        .toList();
    final builder = widget.navigationSpec.bottomNavBuilder ??
        ResponsiveScaffoldDefaults.bottomNavBuilder;
    return builder(context,
        items: items, navigationSpec: widget.navigationSpec);
  }

  Widget _buildNavDrawer(BuildContext context, bool isStandardDrawer) {
    final header = widget.navigationSpec.navHeaderBuilder(context);

    final selected = widget.navigationSpec.selectedIndex;
    var items = <NavigationDrawerItem>[];
    for (var i = 0; i < widget.navigationSpec.items.length; i++) {
      final isSelected = i == selected;
      final navItem = widget.navigationSpec.items[i];
      final activeIcon = navItem.activeIcon ?? navItem.icon;
      void onTap() => widget.navigationSpec.onChanged?.call(i);
      final item = NavigationDrawerItem(
        title: navItem.label,
        icon: isSelected ? navItem.icon : activeIcon,
        selected: isSelected,
        onTap: onTap,
      );
      items.add(item);
    }
    final builder = widget.navigationSpec.navDrawerBuilder ??
        ResponsiveScaffoldDefaults.navDrawerBuilder;
    return NavigationDrawerTheme(
        data: NavigationDrawerThemeData(isStandardDrawer: isStandardDrawer),
        child: builder(context, items: items, header: header));
  }

  Widget _buildBody(BuildContext context,
      {_ResponsiveScaffoldResolver resolver}) {
    final appBar = resolver.bodyAppBar;

    final drawer = resolver.standardOrPermanentDrawer;
    if (drawer?._resolvedType == DrawerType.Standard) {
      _drawerKey ??= GlobalKey();
    } else {
      _standardDrawerOpen = false;
      _drawerKey = null;
    }
    final drawerWidget = _drawerKey == null
        ? drawer?.child
        : StandardDrawerController(
            child: drawer?.child,
            alignment: DrawerAlignment.start,
            drawerCallback: _standardDrawerChanged,
            key: _drawerKey,
          );

    final endDrawer = resolver.standardOrPermanentEndDrawer;
    if (endDrawer?._resolvedType == DrawerType.Standard) {
      _endDrawerKey ??= GlobalKey();
      _standardEndDrawerOpen = false;
    } else {
      _endDrawerKey = null;
    }
    final endDrawerWidget = _endDrawerKey == null
        ? endDrawer?.child
        : StandardDrawerController(
            child: endDrawer.child,
            alignment: DrawerAlignment.end,
            drawerCallback: _standardEndDrawerChanged,
            key: _endDrawerKey,
          );
    final navigationRail = resolver.navigationRail;

    final appbarAndBody = Column(mainAxisSize: MainAxisSize.max, children: [
      if (appBar != null)
        SizedBox(
          height: appBar.preferredSize.height,
          width: appBar.preferredSize.width,
          child: appBar,
        ),
      Expanded(
          child: Row(mainAxisSize: MainAxisSize.max, children: [
        if (drawerWidget != null && !drawer.isFullHeight) drawerWidget,
        Expanded(child: widget.body),
        if (endDrawerWidget != null && !endDrawer.isFullHeight) endDrawerWidget
      ]))
    ]);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (drawerWidget != null && drawer.isFullHeight) drawerWidget,
        if (navigationRail != null) navigationRail,
        Expanded(
          child: appbarAndBody,
        ),
        if (endDrawerWidget != null && endDrawer.isFullHeight) endDrawerWidget,
      ],
    );
  }

  // Called only on build
  _ResponsiveScaffoldResolver _resolveLayout(BuildContext context) {
    final layout = MaterialLayout.of(context);
    final breakpoint = layout.breakpoint;
    final scaffoldBreakpoint =
        _getFromBreakpointMap(breakpoint, map: widget.scaffoldBreakpoints);
    final resolver = _ResponsiveScaffoldResolver(
        breakpoint, scaffoldBreakpoint, widget.navigationSpec);
    // Resolve all NavSpecs other than NavigationDrawer
    resolver._resolveNavRail(context, _buildNavRail);
    resolver._resolveBottomNavbar(context, _buildBottomNav);

    resolver._resolveEndDrawer(widget.responsiveEndDrawer);
    resolver._resolveDrawer(widget.responsiveDrawer);
    resolver._resolveNavigationDrawer(context, _buildNavDrawer);
    resolver._resolveAppBar(widget.appBar);

    resolver.assertIsResolved();

    return resolver;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasDirectionality(context));

    _resolvedLayout = _resolveLayout(context);
    final resolved = _resolvedLayout;
    final breakpoint = MaterialLayout.of(context).breakpoint;

    return Scaffold(
      key: _scaffoldKey,
      body: _buildBody(context, resolver: resolved)?._shadowScaffold,
      drawer: resolved.modalDrawer?._shadowScaffold,
      endDrawer: resolved.modalEndDrawer?._shadowScaffold,
      appBar: resolved.scaffoldAppbar?._shadowScaffold,
      bottomNavigationBar: resolved.bottomNavBar?._shadowScaffold,
      floatingActionButton: widget.floatingActionButton?._shadowScaffold,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      floatingActionButtonLocation: _getFromBreakpointMap(breakpoint,
          map: widget.floatingActionButtonLocations,
          fallback: FloatingActionButtonLocation.endFloat),
      persistentFooterButtons: widget.persistentFooterButtons,
      bottomSheet: widget.bottomSheet?._shadowScaffold,
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      drawerScrimColor: widget.drawerScrimColor,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
    );
  }

  @override
  double get appBarMaxHeight {
    final topPadding =
        widget.primary ? MediaQuery.of(context).padding.top : 0.0;
    final appBarMaxHeight = widget.appBar.preferredSize.height + topPadding;
    assert(appBarMaxHeight >= 0.0 && appBarMaxHeight.isFinite);
    return appBarMaxHeight;
  }

  @override
  bool get hasAppBar =>
      _resolvedLayout.bodyAppBar != null ||
      _resolvedLayout._scaffoldAppBar != null;

  @override
  bool get hasDrawer =>
      _resolvedLayout.bottomDrawer != null ||
      _resolvedLayout.modalDrawer != null ||
      _resolvedLayout.standardOrPermanentDrawer?._resolvedType ==
          DrawerType.Standard;

  @override
  bool get hasEndDrawer =>
      _resolvedLayout.modalEndDrawer != null ||
      _resolvedLayout.standardOrPermanentEndDrawer?._resolvedType ==
          DrawerType.Standard;

  @override
  bool get hasFloatingActionButton =>
      _scaffoldKey.currentState.hasFloatingActionButton;

  @override
  void hideCurrentSnackBar(
          {SnackBarClosedReason reason = SnackBarClosedReason.hide}) =>
      _scaffoldKey.currentState.hideCurrentSnackBar(reason: reason);

  @override
  // TODO: implement isEndDrawerOpen
  bool get isDrawerOpen => throw UnimplementedError();

  @override
  // TODO: implement isEndDrawerOpen
  bool get isEndDrawerOpen => throw UnimplementedError();

  @override
  void openDrawer() {
    if (_resolvedLayout.modalDrawer != null) {
      return _scaffoldKey.currentState.openDrawer();
    }
    if (_resolvedLayout.bottomDrawer != null) {
      var drawer = _resolvedLayout.bottomDrawer;
      var popped = false;
      showModalBottomSheet<void>(
          context: context,
          builder: (context) {
            final newDrawer = _resolvedLayout.bottomDrawer;
            if (newDrawer == null) {
              if (!popped) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => Navigator.of(context).pop());
                popped = true;
              }
              return drawer;
            }
            drawer = newDrawer;
            return drawer;
          });
      return;
    }
    if (_drawerKey != null) {
      if (_standardDrawerOpen) {
        _drawerKey.currentState.close();
      } else {
        _drawerKey.currentState.open();
      }
      return;
    }
  }

  @override
  void openEndDrawer() {
    if (_resolvedLayout.modalEndDrawer != null) {
      return _scaffoldKey.currentState.openEndDrawer();
    }
    if (_endDrawerKey != null) {
      if (_standardEndDrawerOpen) {
        _endDrawerKey.currentState.close();
      } else {
        _endDrawerKey.currentState.open();
      }
      return;
    }
  }

  @override
  void removeCurrentSnackBar(
          {SnackBarClosedReason reason = SnackBarClosedReason.remove}) =>
      _scaffoldKey.currentState.removeCurrentSnackBar(reason: reason);

  @override
  void showBodyScrim(bool value, double opacity) {
    // TODO: implement showBodyScrim
  }

  @override
  // TODO: implement the responsive version. Maybe just increasing the padding
  // will work?
  PersistentBottomSheetController<T> showBottomSheet<T>(WidgetBuilder builder,
          {Color backgroundColor,
          double elevation,
          ShapeBorder shape,
          Clip clipBehavior,
          BoxConstraints constraints,
          AnimationController transitionAnimationController}) =>
      _scaffoldKey.currentState.showBottomSheet<T>(builder,
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: shape,
          clipBehavior: clipBehavior,
          constraints: constraints,
          transitionAnimationController: transitionAnimationController);

  @override
  // TODO: implement the responsive version. Maybe just increasing the padding
  // will work?
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
          SnackBar snackbar) =>
      _scaffoldKey.currentState.showSnackBar(snackbar);

  @override
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) {
    // TODO: implement restoreState
  }
}

extension on PreferredSizeWidget {
  _PreferredSizeScaffoldContextShadower get _shadowScaffold =>
      this == null ? null : _PreferredSizeScaffoldContextShadower(child: this);
}

extension on Widget {
  _ScaffoldContextShadower get _shadowScaffold =>
      this == null ? null : _ScaffoldContextShadower(child: this);
}

class _PreferredSizeScaffoldContextShadower extends _ScaffoldContextShadower
    implements PreferredSizeWidget {
  final PreferredSizeWidget child;

  _PreferredSizeScaffoldContextShadower({this.child});

  @override
  Size get preferredSize => child.preferredSize;
}

class _ScaffoldContextShadower extends StatefulWidget implements Scaffold {
  final Widget child;

  const _ScaffoldContextShadower({Key key, this.child}) : super(key: key);

  @override
  PreferredSizeWidget get appBar => throw UnimplementedError();
  @override
  Color get backgroundColor => throw UnimplementedError();
  @override
  Widget get body => throw UnimplementedError();
  @override
  Widget get bottomNavigationBar => throw UnimplementedError();
  @override
  Widget get bottomSheet => throw UnimplementedError();
  @override
  ScaffoldState createState() => _ScaffoldContextShadowerState();
  @override
  Widget get drawer => throw UnimplementedError();
  @override
  DragStartBehavior get drawerDragStartBehavior => throw UnimplementedError();
  @override
  double get drawerEdgeDragWidth => throw UnimplementedError();
  @override
  bool get drawerEnableOpenDragGesture => throw UnimplementedError();
  @override
  Color get drawerScrimColor => throw UnimplementedError();
  @override
  Widget get endDrawer => throw UnimplementedError();
  @override
  bool get endDrawerEnableOpenDragGesture => throw UnimplementedError();
  @override
  bool get extendBody => throw UnimplementedError();
  @override
  bool get extendBodyBehindAppBar => throw UnimplementedError();
  @override
  Widget get floatingActionButton => throw UnimplementedError();
  @override
  FloatingActionButtonAnimator get floatingActionButtonAnimator =>
      throw UnimplementedError();
  @override
  FloatingActionButtonLocation get floatingActionButtonLocation =>
      throw UnimplementedError();
  @override
  List<Widget> get persistentFooterButtons => throw UnimplementedError();
  @override
  bool get primary => throw UnimplementedError();
  @override
  bool get resizeToAvoidBottomInset => throw UnimplementedError();

  @override
  get onDrawerChanged => throw UnimplementedError();

  @override
  get onEndDrawerChanged => throw UnimplementedError();

  @override
  String get restorationId => throw UnimplementedError();
}

class _ScaffoldContextShadowerState extends State<Scaffold>
    implements ScaffoldState {
  _ScaffoldContextShadower get widget =>
      super.widget as _ScaffoldContextShadower;
  ResponsiveScaffoldState get _state =>
      context.findAncestorStateOfType<ResponsiveScaffoldState>();

  double get appBarMaxHeight => _state.appBarMaxHeight;

  @override
  Widget build(BuildContext context) => widget.child;
  @override
  Ticker createTicker(void Function(Duration elapsed) f) =>
      throw UnimplementedError();
  @override
  bool get hasAppBar => _state.hasAppBar;
  @override
  bool get hasDrawer => _state.hasDrawer;
  @override
  bool get hasEndDrawer => _state.hasEndDrawer;
  @override
  bool get hasFloatingActionButton => _state.hasFloatingActionButton;
  @override
  void hideCurrentSnackBar(
          {SnackBarClosedReason reason = SnackBarClosedReason.hide}) =>
      _state.hideCurrentSnackBar(reason: reason);
  @override
  bool get isDrawerOpen => _state.isDrawerOpen;
  @override
  bool get isEndDrawerOpen => _state.isEndDrawerOpen;
  @override
  void openDrawer() => _state.openDrawer();
  @override
  void openEndDrawer() => _state.openEndDrawer();
  @override
  void removeCurrentSnackBar(
          {SnackBarClosedReason reason = SnackBarClosedReason.remove}) =>
      _state.removeCurrentSnackBar(reason: reason);
  @override
  void showBodyScrim(bool value, double opacity) =>
      _state.showBodyScrim(value, opacity);
  @override
  PersistentBottomSheetController<T> showBottomSheet<T>(WidgetBuilder builder,
          {Color backgroundColor,
          double elevation,
          ShapeBorder shape,
          Clip clipBehavior,
          BoxConstraints constraints,
          AnimationController transitionAnimationController}) =>
      _state.showBottomSheet(builder,
          backgroundColor: backgroundColor,
          elevation: elevation,
          shape: shape,
          clipBehavior: clipBehavior,
          constraints: constraints,
          transitionAnimationController: transitionAnimationController);
  @override
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
          SnackBar snackbar) =>
      _state.showSnackBar(snackbar);

  @override
  RestorationBucket get bucket => _state.bucket;

  @override
  void didToggleBucket(RestorationBucket oldBucket) =>
      _state.didToggleBucket(oldBucket);

  @override
  void didUpdateRestorationId() => _state.didUpdateRestorationId();

  @override
  void registerForRestoration(
          RestorableProperty<Object> property, String restorationId) =>
      _state.registerForRestoration(property, restorationId);

  @override
  String get restorationId => _state.restorationId;

  @override
  bool get restorePending => _state.restorePending;

  @override
  void restoreState(RestorationBucket oldBucket, bool initialRestore) =>
      _state.restoreState(oldBucket, initialRestore);

  @override
  void unregisterFromRestoration(RestorableProperty<Object> property) =>
      _state.unregisterFromRestoration(property);
}
