import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import '../../material_widgets.dart';
import '../shrinkable_drawer_controller.dart';

typedef FloatingActionButtonBuilder = Widget Function(BuildContext, bool);
Widget _removeFabElevation(BuildContext context, Widget fab) =>
    MD3FloatingActionButtonTheme(
      data: MD3FloatingActionButtonThemeData(
        style:
            (MD3FloatingActionButtonTheme.of(context)?.style ?? ButtonStyle())
                .copyWith(elevation: MaterialStateProperty.all(0)),
      ),
      child: fab,
    );

class MD3BottomNavigationDelegate extends MD3NavigationDelegate {
  const MD3BottomNavigationDelegate({
    this.appBar,
    this.drawerHeader,
    this.endDrawer,
    this.endModalDrawer,
    this.floatingActionButton,
    this.navigationFabBuilder,
    this.showModalDrawerOnCompact = true,
  });

  final PreferredSizeWidget appBar;
  final Widget drawerHeader;
  final Widget endDrawer;
  final Widget endModalDrawer;
  final Widget floatingActionButton;
  final FloatingActionButtonBuilder navigationFabBuilder;
  final bool showModalDrawerOnCompact;

  @override
  MD3AdaptativeScaffoldWidgets buildCompact(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      MD3AdaptativeScaffoldWidgets(
        body: body,
        appBar: appBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton:
            floatingActionButton ?? navigationFabBuilder?.call(context, false),
        startModalDrawer: showModalDrawerOnCompact
            ? _buildDrawer(context, spec, drawerHeader)
            : null,
        bottomNavigationBar: _buildNavigationBar(context, spec),
      );

  Widget _buildNavigationBar(
    BuildContext context,
    MD3NavigationSpec spec,
  ) =>
      NavigationBar(
        selectedIndex: spec.selectedIndex,
        onDestinationSelected: spec.onChanged,
        destinations: spec.items
            .map(
              (e) => NavigationDestination(
                icon: e.icon,
                selectedIcon: e.activeIcon ?? e.icon,
                label: e.labelText,
                tooltip: e.labelText,
              ),
            )
            .toList(),
      );

  @override
  MD3AdaptativeScaffoldWidgets buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildExpandableRail(spec, body, false);

  @override
  MD3AdaptativeScaffoldWidgets buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildExpandableRail(spec, body, true);

  MD3AdaptativeScaffoldWidgets _buildExpandableRail(
    MD3NavigationSpec spec,
    Widget body,
    bool canExpand,
  ) =>
      MD3AdaptativeScaffoldWidgets(
        body: body,
        appBar: appBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton:
            navigationFabBuilder == null ? floatingActionButton : null,
        startDrawer: _ExpandableRail(
          spec: spec,
          floatingActionButtonBuilder: navigationFabBuilder,
          appBarHeight: appBar?.preferredSize?.height,
          canExpand: canExpand,
        ),
      );
}

/// An [MD3NavigationDelegate] which uses an modal [Drawer] for compact and
/// normal devices, and an fixed [Drawer] for large devices.
class MD3DrawersNavigationDelegate extends MD3NavigationDelegate {
  const MD3DrawersNavigationDelegate({
    this.appBar,
    this.drawerHeader,
    this.bottomNavigationBar,
    this.endDrawer,
    this.endModalDrawer,
    this.floatingActionButton,
  });

  final PreferredSizeWidget appBar;
  final Widget drawerHeader;
  final Widget bottomNavigationBar;
  final Widget endDrawer;
  final Widget endModalDrawer;
  final Widget floatingActionButton;

  @override
  MD3AdaptativeScaffoldWidgets buildCompact(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      MD3AdaptativeScaffoldWidgets(
        body: body,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton: floatingActionButton,
        startModalDrawer: _buildDrawer(context, spec, drawerHeader),
      );

  @override
  MD3AdaptativeScaffoldWidgets buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      buildCompact(context, spec, body);

  @override
  MD3AdaptativeScaffoldWidgets buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      MD3AdaptativeScaffoldWidgets(
        body: body,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton: floatingActionButton,
        startDrawer: SizedBox(
          width: 256,
          child: _buildDrawer(
            context,
            spec,
            drawerHeader,
            level0Elevation: true,
          ),
        ),
      );
}

extension _<T> on Iterable<T> {
  Iterable<T1> mapIndexed<T1>(T1 Function(T, int) fn) sync* {
    var i = 0;
    for (final e in this) {
      yield fn(e, i++);
    }
  }
}

class _ExpandableRail extends StatefulWidget {
  const _ExpandableRail({
    Key key,
    this.spec,
    this.floatingActionButtonBuilder,
    this.appBarHeight,
    this.header,
    this.canExpand = true,
  }) : super(key: key);
  final MD3NavigationSpec spec;
  final FloatingActionButtonBuilder floatingActionButtonBuilder;
  final Widget header;
  final double appBarHeight;
  final bool canExpand;

  @override
  _ExpandableRailState createState() => _ExpandableRailState();
}

class _ExpandableRailState extends State<_ExpandableRail>
    with SingleTickerProviderStateMixin {
  final shrinkableDrawerController =
      GlobalKey<ShrinkableDrawerControllerState>();
  AnimationController iconAnimController;
  void initState() {
    super.initState();
    iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  bool _isOpen = false;

  void didUpdateWidget(_ExpandableRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.canExpand && oldWidget.canExpand) {
      // Close it if it was open
      shrinkableDrawerController.currentState.close();
    }
  }

  void dispose() {
    iconAnimController.dispose();
    super.dispose();
  }

  void _onDrawerChange(bool state) {
    _isOpen = state;
    setState(() {});
    if (state) {
      iconAnimController.forward();
    } else {
      iconAnimController.reverse();
    }
  }

  void _toggleDrawer() => _isOpen
      ? shrinkableDrawerController.currentState.close()
      : shrinkableDrawerController.currentState.open();

  Widget _menuButton(BuildContext context) => SizedBox(
        height: 64,
        width: 80,
        child: Center(
          child: IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress: iconAnimController,
            ),
            onPressed: _toggleDrawer,
          ),
        ),
      );

  Widget _fabHeader(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.floatingActionButtonBuilder != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                child: _removeFabElevation(
                  context,
                  Builder(
                    builder: (context) => widget.floatingActionButtonBuilder(
                      context,
                      _isOpen,
                    ),
                  ),
                ),
                width: double.infinity,
              ),
            ),
          const Expanded(child: const SizedBox())
        ],
      );

  Widget _shrinkable(BuildContext context, Widget child) => SizeTransition(
        sizeFactor: iconAnimController,
        axis: Axis.horizontal,
        axisAlignment: -1,
        child: Center(child: child),
      );

  Iterable<Widget> _navigationDrawerItems(
    BuildContext context,
    MD3NavigationSpec spec,
  ) =>
      spec.items.mapIndexed(
        (e, i) {
          final selected = spec.selectedIndex == i;
          final child = NavigationDrawerItem(
            icon: selected ? e.activeIcon ?? e.icon : e.icon,
            selected: selected,
            title: _shrinkable(context, e.label),
            onTap: () => spec.onChanged(i),
          );

          if (_isOpen) {
            return child;
          }

          return Tooltip(
            message: e.labelText,
            child: child,
          );
        },
      );
  Widget _appBarSizedHeader(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.appBarHeight ?? double.infinity,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(child: _shrinkable(context, widget.header)),
            if (widget.canExpand) _menuButton(context),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ShrinkableDrawerController(
      key: shrinkableDrawerController,
      shrunkWidth: 80,
      drawerCallback: _onDrawerChange,
      alignment: DrawerAlignment.start,
      child: _drawer(
        context,
        level0Elevation: true,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            SizedBox(
              height: widget.appBarHeight,
              child: _appBarSizedHeader(context),
            ),
            Expanded(child: _fabHeader(context), flex: 4),
            ..._navigationDrawerItems(
              context,
              widget.spec,
            ),
            const Expanded(child: const SizedBox(), flex: 7),
          ],
        ),
      ),
    );
  }
}

Widget _drawer(BuildContext context,
        {Widget child, bool level0Elevation = false}) =>
    Drawer(
      backgroundColor: context.elevation.level0.overlaidColor(
        context.colorScheme.surface,
        MD3ElevationLevel.surfaceTint(context.colorScheme),
      ),
      child: child,
    );

Widget _buildDrawer(
  BuildContext context,
  MD3NavigationSpec spec,
  Widget drawerHeader, {
  bool noLabel = false,
  bool tooltip = false,
  bool level0Elevation = false,
}) =>
    _drawer(
      context,
      level0Elevation: level0Elevation,
      child: SafeArea(
        child: ListView(
          children: [
            drawerHeader ??
                const NavigationDrawerHeader(
                  title: Text('Navegação'),
                ),
            ..._navigationDrawerItems(
              context,
              spec,
              noLabel: noLabel,
              tooltip: tooltip,
            )
          ],
        ),
      ),
    );

Iterable<Widget> _navigationDrawerItems(
  BuildContext context,
  MD3NavigationSpec spec, {
  bool noLabel = false,
  bool tooltip = false,
}) =>
    spec.items.mapIndexed(
      (e, i) {
        final selected = spec.selectedIndex == i;
        final child = NavigationDrawerItem(
          icon: selected ? e.activeIcon ?? e.icon : e.icon,
          selected: selected,
          title: noLabel ? const SizedBox() : e.label,
          onTap: () => spec.onChanged(i),
        );
        if (!tooltip) {
          return child;
        }
        return Tooltip(
          message: e.labelText,
          child: child,
        );
      },
    );
