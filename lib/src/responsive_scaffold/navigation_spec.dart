import 'package:flutter/material.dart';

import '../material_breakpoint.dart';
import '../navigation_drawer.dart';
import 'responsive_scaffold_defaults.dart';

// ignore_for_file: constant_identifier_names

enum NavigationType {
  NavigationRail,
  ExpandedNavigationRail,
  BottomNavigationBar,
  BottomNavigationBarAndNavigationDrawer,
  NavigationDrawer
}

class NavigationItem {
  final Widget label;
  final Widget icon;
  final Widget activeIcon;
  // Only used in BottomNavigationBar
  final Color backgroundColor;

  const NavigationItem(
      {this.label, this.icon, this.activeIcon, this.backgroundColor});
}

typedef NavigationRailBuilder = Widget Function(BuildContext context,
    {List<NavigationRailDestination> destinations,
    NavigationSpec navigationSpec,
    bool expanded});
typedef BottomNavBuilder = Widget Function(BuildContext context,
    {List<BottomNavigationBarItem> items, NavigationSpec navigationSpec});
typedef NavDrawerBuilder = Widget Function(BuildContext context,
    {Widget header, List<NavigationDrawerItem> items});

class NavigationSpec {
  final List<NavigationItem> items;
  // When the display size is too big, the [ResponsiveScaffold] will place an
  // permanent drawer if there is any drawer.
  // When this is true, both the [ResponsiveScaffold.drawer] and the rail will
  // be shown.
  // This has no effect if when the [ResponsiveScaffold.drawer] is null
  final bool showWithExtendedDrawer;
  final ValueChanged<int> onChanged;
  final Map<MaterialBreakpoint, NavigationType> breakpointNavigationTypeMap;
  final int selectedIndex;
  final bool fullHeightDrawer;
  // Used for the navigation drawer
  final NavigationRailBuilder navigationRailBuilder;
  final BottomNavBuilder bottomNavBuilder;
  final WidgetBuilder navHeaderBuilder;
  final NavDrawerBuilder navDrawerBuilder;

  const NavigationSpec({
    @required this.items,
    this.showWithExtendedDrawer = false,
    @required this.onChanged,
    this.breakpointNavigationTypeMap =
        ResponsiveScaffoldDefaults.navigationTypeMap,
    this.selectedIndex,
    this.fullHeightDrawer = false,
    this.navigationRailBuilder,
    this.bottomNavBuilder,
    @required this.navHeaderBuilder,
    this.navDrawerBuilder,
  });

  static NavigationRailDestination itemToRailDestination(NavigationItem item) =>
      NavigationRailDestination(
          icon: item.icon, label: item.label, selectedIcon: item.activeIcon);

  static BottomNavigationBarItem itemToBottomNavItem(NavigationItem item) =>
      BottomNavigationBarItem(
          icon: item.icon,
          title: item.label,
          activeIcon: item.activeIcon,
          backgroundColor: item.backgroundColor);
}
