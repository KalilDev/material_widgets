import 'package:flutter/material.dart';

import '../../navigation_drawer.dart';
import '../material_breakpoint.dart';
import 'navigation_spec.dart';
import 'responsive_scaffold.dart';

@Deprecated(
    'Use the newer MD3AdaptativeScaffold or MD3NavigationScaffold instead')
abstract class ResponsiveScaffoldDefaults {
  static const scaffoldBreakpoints = {
    MaterialBreakpoint.one: ScaffoldBreakpoint.Mobile,
    MaterialBreakpoint.seven: ScaffoldBreakpoint.SingleDrawer,
    MaterialBreakpoint.ten: ScaffoldBreakpoint.DualDrawers
  };

  static const fabPositions = {
    MaterialBreakpoint.one: FloatingActionButtonLocation.endFloat,
    /*
    MaterialBreakpoint.seven: FloatingActionButtonLocation.endTop,
    MaterialBreakpoint.ten: FloatingActionButtonLocation.startTop*/
  };

  static const Map<MaterialBreakpoint, NavigationType> navigationTypeMap = {
    MaterialBreakpoint.one:
        NavigationType.BottomNavigationBarAndNavigationDrawer,
    MaterialBreakpoint.five: NavigationType.NavigationDrawer,
    MaterialBreakpoint.seven: NavigationType.NavigationRail,
    MaterialBreakpoint.ten: NavigationType.NavigationDrawer
  };

  static const responsiveDrawerType = {
    MaterialBreakpoint.one: DrawerType.ModalOrBottom,
    MaterialBreakpoint.five: DrawerType.StandardOrPersistent
  };

  static Widget navigationRailBuilder(BuildContext context,
      {List<NavigationRailDestination> destinations,
      NavigationSpec navigationSpec,
      bool expanded}) {
    return NavigationRail(
      destinations: destinations,
      selectedIndex: navigationSpec.selectedIndex,
      extended: expanded,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: navigationSpec.onChanged,
    );
  }

  static Widget bottomNavBuilder(BuildContext context,
      {List<BottomNavigationBarItem> items, NavigationSpec navigationSpec}) {
    return BottomNavigationBar(
      items: items,
      fixedColor: Theme.of(context).colorScheme.primary,
      type: BottomNavigationBarType.fixed,
      currentIndex: navigationSpec.selectedIndex,
      onTap: navigationSpec.onChanged,
    );
  }

  static Widget navDrawerBuilder(BuildContext context,
      {Widget header, List<NavigationDrawerItem> items}) {
    return Drawer(
      child: ListView(
        children: [header, ...items],
      ),
    );
  }
}
