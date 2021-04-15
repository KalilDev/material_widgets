part of 'responsive_scaffold.dart';

enum _ResolverPart {
  breakpoint,
  scaffoldBreakpoint,
  navRail,
  bottomNavBar,
  endDrawer,
  drawer,
  navDrawer,
  appBar
}

class _ResponsiveScaffoldResolver {
  final MaterialBreakpoint breakpoint;
  final ScaffoldBreakpoint scaffoldBreakpoint;
  final NavigationSpec navigationSpec;
  bool _didResolveNavSpec = false;

  NavigationType _getNavType() {
    _assertResolvedDependencies([_ResolverPart.breakpoint]);
    return _getFromBreakpointMap(breakpoint,
        map: navigationSpec?.breakpointNavigationTypeMap,
        fallback: NavigationType.BottomNavigationBar);
  }

  Widget modalDrawer;
  Widget modalEndDrawer;
  ResponsiveScaffoldDrawer standardOrPermanentDrawer;
  ResponsiveScaffoldDrawer standardOrPermanentEndDrawer;
  Widget navigationRail;
  PreferredSizeWidget _scaffoldAppBar;
  PreferredSizeWidget bodyAppBar;
  Widget bottomNavBar;
  Widget bottomDrawer;
  final List<_ResolverPart> _debugResolved = [
    _ResolverPart.breakpoint,
    _ResolverPart.scaffoldBreakpoint,
  ];

  void _assertResolvedDependencies(List<_ResolverPart> dependencies) {
    for (final dep in dependencies) {
      assert(_debugResolved.contains(dep));
    }
  }

  void _assertUnresolvedDependencies(List<_ResolverPart> dependencies) {
    for (final dep in dependencies) {
      assert(!_debugResolved.contains(dep));
    }
  }

  void _debugAddResolved(_ResolverPart part) {
    assert(!_debugResolved.contains(part));
    _debugResolved.add(part);
  }

  void assertIsResolved() => _assertResolvedDependencies(_ResolverPart.values);

  _ResponsiveScaffoldResolver(
      this.breakpoint, this.scaffoldBreakpoint, this.navigationSpec);

  void _resolveNavRail(BuildContext context,
      Widget Function(BuildContext, {bool expanded}) buildRail) {
    _assertResolvedDependencies([]);
    _debugAddResolved(_ResolverPart.navRail);
    if (navigationSpec == null) {
      _didResolveNavSpec = true;
    }
    if (_didResolveNavSpec) {
      return;
    }
    if (_getNavType() == NavigationType.NavigationRail ||
        _getNavType() == NavigationType.ExpandedNavigationRail) {
      switch (_getNavType()) {
        case NavigationType.NavigationRail:
          navigationRail = buildRail(context);
          break;
        case NavigationType.ExpandedNavigationRail:
          navigationRail = buildRail(context, expanded: true);
          break;
        default:
      }
      _didResolveNavSpec = true;
    }
  }

  void _resolveBottomNavbar(
      BuildContext context, WidgetBuilder buildBottomNavbar) {
    _assertResolvedDependencies([]);
    _debugAddResolved(_ResolverPart.bottomNavBar);
    if (navigationSpec == null) {
      _didResolveNavSpec = true;
    }
    if (_didResolveNavSpec) {
      return;
    }
    if (_getNavType() == NavigationType.BottomNavigationBar) {
      bottomNavBar = buildBottomNavbar(context);
      _didResolveNavSpec = true;
    }
    if (_getNavType() ==
        NavigationType.BottomNavigationBarAndNavigationDrawer) {
      bottomNavBar = buildBottomNavbar(context);
    }
  }

  bool get isLarge {
    _assertResolvedDependencies([_ResolverPart.breakpoint]);
    return breakpoint.windowSize == WindowSize.large ||
        breakpoint.windowSize == WindowSize.xlarge;
  }

  PreferredSizeWidget get scaffoldAppbar =>
      _scaffoldAppBar ??
      (bodyAppBar == null
          ? null
          : _PreferredSizeWidget(preferredSize: bodyAppBar.preferredSize));

  DrawerType _resolveDrawerType(Map<MaterialBreakpoint, DrawerType> types,
      {bool isEnd = false}) {
    _assertResolvedDependencies(
        [_ResolverPart.breakpoint, _ResolverPart.bottomNavBar]);
    final drawerType = _getFromBreakpointMap(breakpoint, map: types);
    switch (drawerType) {
      case DrawerType.StandardOrPersistent:
        return isEnd || isLarge ? DrawerType.Persistent : DrawerType.Standard;
      case DrawerType.ModalOrBottom:
        final hasBottomNavbar = bottomNavBar != null;
        return isEnd || !hasBottomNavbar ? DrawerType.Modal : DrawerType.Bottom;
      default:
        return drawerType;
    }
  }

  void _resolveEndDrawer(ResponsiveScaffoldDrawer endDrawer) {
    _assertResolvedDependencies([]);
    _debugAddResolved(_ResolverPart.endDrawer);
    if (endDrawer == null) {
      return;
    }
    assert(standardOrPermanentEndDrawer == null && modalEndDrawer == null);
    var drawerType = _resolveDrawerType(endDrawer.types, isEnd: true);
    switch (drawerType) {
      case DrawerType.Modal:
        modalEndDrawer = endDrawer.child;
        break;
      case DrawerType.Bottom:
        assert(bottomDrawer == null);
        bottomDrawer = endDrawer.child;
        break;
      case DrawerType.Standard:
        standardOrPermanentEndDrawer = endDrawer._resolved(DrawerType.Standard);
        break;
      case DrawerType.Persistent:
        standardOrPermanentEndDrawer =
            endDrawer._resolved(DrawerType.Persistent);
        break;
      default:
    }
  }

  void _resolveDrawer(ResponsiveScaffoldDrawer drawer) {
    _assertUnresolvedDependencies([_ResolverPart.navDrawer]);
    _assertResolvedDependencies([]);
    _debugAddResolved(_ResolverPart.drawer);
    if (drawer == null) {
      return;
    }
    assert(standardOrPermanentDrawer == null && modalDrawer == null);
    var drawerType = _resolveDrawerType(drawer.types);
    switch (drawerType) {
      case DrawerType.Modal:
        modalDrawer = drawer.child;
        break;
      case DrawerType.Bottom:
        assert(bottomDrawer == null);
        bottomDrawer = drawer.child;
        break;
      case DrawerType.Standard:
        assert(_didResolveNavSpec == true && standardOrPermanentDrawer == null);
        standardOrPermanentDrawer = drawer._resolved(DrawerType.Standard);
        break;
      case DrawerType.Persistent:
        assert(_didResolveNavSpec == true && standardOrPermanentDrawer == null);
        standardOrPermanentDrawer = drawer._resolved(DrawerType.Persistent);
        break;
      default:
    }
  }

  // TODO: Bottom nav drawer
  void _resolveNavigationDrawer(
      BuildContext context,
      Widget Function(BuildContext context, bool isStandard)
          buildNavigationDrawer) {
    _assertResolvedDependencies([
      _ResolverPart.drawer,
      _ResolverPart.scaffoldBreakpoint,
      _ResolverPart.bottomNavBar
    ]);
    _debugAddResolved(_ResolverPart.navDrawer);
    if (navigationSpec == null) {
      _didResolveNavSpec = true;
    }
    if (_didResolveNavSpec) {
      return;
    }
    final isStandardOrPermanent =
        scaffoldBreakpoint == ScaffoldBreakpoint.DualDrawers ||
            (scaffoldBreakpoint == ScaffoldBreakpoint.SingleDrawer &&
                standardOrPermanentEndDrawer == null);
    final drawer = buildNavigationDrawer(context, isStandardOrPermanent);
    if (!isStandardOrPermanent) {
      modalDrawer = drawer;
      _didResolveNavSpec = true;
      return;
    }

    final drawerType = isLarge ? DrawerType.Persistent : DrawerType.Standard;

    final navDrawer = ResponsiveScaffoldDrawer._(
        child: drawer,
        isFullHeight: navigationSpec.fullHeightDrawer,
        resolvedType: drawerType);
    final hasExtendedDrawer = standardOrPermanentDrawer != null;
    if (hasExtendedDrawer && navigationSpec.showWithExtendedDrawer) {
      modalDrawer = navDrawer.child;
    } else {
      standardOrPermanentDrawer ??= navDrawer;
    }
    _didResolveNavSpec = true;
  }

  void _resolveAppBar(Widget appBar) {
    _assertResolvedDependencies([
      _ResolverPart.drawer,
      _ResolverPart.endDrawer,
      _ResolverPart.navDrawer
    ]);
    _debugAddResolved(_ResolverPart.appBar);
    assert(bodyAppBar == null && _scaffoldAppBar == null);
    var isOnScaffold = true;
    isOnScaffold =
        isOnScaffold && !(standardOrPermanentEndDrawer?.isFullHeight ?? false);
    isOnScaffold =
        isOnScaffold && !(standardOrPermanentDrawer?.isFullHeight ?? false);
    if (isOnScaffold) {
      _scaffoldAppBar = appBar as PreferredSizeWidget;
    } else {
      bodyAppBar = appBar as PreferredSizeWidget;
    }
  }
}

T _getFromBreakpointMap<T>(MaterialBreakpoint bp,
    {@required Map<MaterialBreakpoint, T> map, T fallback}) {
  if (map == null) {
    return null;
  }
  final value = map[bp];
  if (value != null) {
    return value;
  }

  final previousBps =
      MaterialBreakpoint.values.takeWhile((value) => bp != value).toList();
  // walk back to front trying to find the closest bp
  for (final bp in previousBps.reversed) {
    final value = map[bp];
    if (value != null) {
      return value;
    }
  }
  // welp, couldnt find any, use the fallback
  return fallback;
}

class _PreferredSizeWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const _PreferredSizeWidget({Key key, this.preferredSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  @override
  final Size preferredSize;
}
