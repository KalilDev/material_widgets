import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_size_class_property.dart';
import 'package:material_you/material_you.dart';

import '../../material_widgets.dart';
import '../shrinkable_drawer_controller.dart';
import 'spec_scaffold.dart';

typedef FloatingActionButtonBuilder = Widget Function(BuildContext, bool);
Widget _removeFabElevation(BuildContext context, Widget fab) =>
    MD3FloatingActionButtonTheme(
      data: MD3FloatingActionButtonThemeData(
        style: (MD3FloatingActionButtonTheme.of(context).style ??
                const ButtonStyle())
            .copyWith(elevation: MaterialStateProperty.all(0)),
      ),
      child: fab,
    );

abstract class MD3NavigationDelegate {
  const MD3NavigationDelegate();

  Widget buildNavigationBar(
    MD3NavigationSpec spec,
  ) =>
      NavigationBar(
        selectedIndex: spec.selectedIndex,
        onDestinationSelected: spec.onChanged,
        destinations: spec.items
            .map(
              (e) => NavigationDestination(
                icon: e.icon,
                selectedIcon: e.activeIcon,
                label: e.labelText,
                tooltip: e.tooltip,
              ),
            )
            .toList(),
      );

  Widget buildExpandableRail(
    MD3NavigationSpec spec, {
    FloatingActionButtonBuilder? floatingActionButtonBuilder,
    bool canExpand = true,
    Widget? header,
    double railAlignment = -0.5,
  }) =>
      _ExpandableRail(
        spec: spec,
        floatingActionButtonBuilder: floatingActionButtonBuilder,
        canExpand: canExpand,
        header: header,
        railAlignment: railAlignment,
      );

  Widget buildNavigationDrawer(
    MD3NavigationSpec spec,
    Widget? drawerHeader,
  ) =>
      _buildDrawer(spec, drawerHeader);

  MD3AdaptativeScaffoldSpec buildCompact(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  );
  MD3AdaptativeScaffoldSpec buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  );
  MD3AdaptativeScaffoldSpec buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  );
}

class MD3BottomNavigationDelegate extends MD3NavigationDelegate {
  const MD3BottomNavigationDelegate({
    this.appBar,
    this.drawerHeader,
    this.endDrawer,
    this.endModalDrawer,
    this.floatingActionButton,
    this.navigationFabBuilder,
    this.showModalDrawerOnCompact = true,
    this.surfaceBackground,
    this.properties,
  });

  final PreferredSizeWidget? appBar;
  final Widget? drawerHeader;
  final Widget? endDrawer;
  final Widget? endModalDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonBuilder? navigationFabBuilder;
  final bool showModalDrawerOnCompact;
  final MD3SizeClassProperty<bool>? surfaceBackground;
  final MD3ScaffoldProperties? properties;

  @override
  MD3AdaptativeScaffoldSpec buildCompact(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      MD3AdaptativeScaffoldSpec(
        body: body,
        appBar: appBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton:
            floatingActionButton ?? navigationFabBuilder?.call(context, false),
        startModalDrawer: showModalDrawerOnCompact
            ? buildNavigationDrawer(spec, drawerHeader)
            : null,
        bottomNavigationBar: buildNavigationBar(spec),
        surfaceBackground:
            surfaceBackground?.resolve(MD3WindowSizeClass.compact) ?? true,
        properties: properties,
      );

  @override
  MD3AdaptativeScaffoldSpec buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildExpandableRailSpec(spec, body, false, MD3WindowSizeClass.medium);

  @override
  MD3AdaptativeScaffoldSpec buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildExpandableRailSpec(spec, body, true, MD3WindowSizeClass.expanded);

  MD3AdaptativeScaffoldSpec _buildExpandableRailSpec(
    MD3NavigationSpec spec,
    Widget body,
    bool canExpand,
    MD3WindowSizeClass sizeClass,
  ) =>
      MD3AdaptativeScaffoldSpec(
        body: body,
        appBar: appBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton:
            navigationFabBuilder == null ? floatingActionButton : null,
        startDrawer: buildExpandableRail(
          spec,
          floatingActionButtonBuilder: navigationFabBuilder,
          canExpand: canExpand,
        ),
        surfaceBackground: surfaceBackground?.resolve(sizeClass) ?? true,
        properties: properties,
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
    this.surfaceBackground,
    this.properties,
  });

  final PreferredSizeWidget? appBar;
  final Widget? drawerHeader;
  final Widget? bottomNavigationBar;
  final Widget? endDrawer;
  final Widget? endModalDrawer;
  final Widget? floatingActionButton;
  final MD3SizeClassProperty<bool>? surfaceBackground;
  final MD3ScaffoldProperties? properties;

  MD3AdaptativeScaffoldSpec _buildSpec(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
    MD3WindowSizeClass sizeClass,
  ) =>
      MD3AdaptativeScaffoldSpec(
        body: body,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton: floatingActionButton,
        startModalDrawer: buildNavigationDrawer(spec, drawerHeader),
        surfaceBackground: surfaceBackground?.resolve(sizeClass) ?? true,
        properties: properties,
      );

  @override
  MD3AdaptativeScaffoldSpec buildCompact(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildSpec(context, spec, body, MD3WindowSizeClass.compact);

  @override
  MD3AdaptativeScaffoldSpec buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildSpec(context, spec, body, MD3WindowSizeClass.medium);

  @override
  MD3AdaptativeScaffoldSpec buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildSpec(context, spec, body, MD3WindowSizeClass.expanded);
}

extension _ItE<T> on Iterable<T> {
  Iterable<T1> mapIndexed<T1>(T1 Function(T, int) fn) sync* {
    var i = 0;
    for (final e in this) {
      yield fn(e, i++);
    }
  }
}

class _ExpandableRail extends StatefulWidget {
  const _ExpandableRail({
    Key? key,
    required this.spec,
    this.floatingActionButtonBuilder,
    this.header,
    this.canExpand = true,
    this.railAlignment = -0.5,
  }) : super(key: key);
  final MD3NavigationSpec spec;
  final FloatingActionButtonBuilder? floatingActionButtonBuilder;
  final Widget? header;
  final bool canExpand;
  final double railAlignment;

  @override
  _ExpandableRailState createState() => _ExpandableRailState();
}

class _ExpandableRailState extends State<_ExpandableRail>
    with SingleTickerProviderStateMixin {
  final shrinkableDrawerController =
      GlobalKey<ShrinkableDrawerControllerState>();
  late AnimationController iconAnimController;
  @override
  void initState() {
    super.initState();
    iconAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  bool _isOpen = false;

  @override
  void didUpdateWidget(_ExpandableRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.canExpand && oldWidget.canExpand) {
      // Close it if it was open
      shrinkableDrawerController.currentState!.close();
    }
  }

  @override
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
      ? shrinkableDrawerController.currentState!.close()
      : shrinkableDrawerController.currentState!.open();

  Widget _menuButton(BuildContext context) => SizedBox(
        height: 64,
        width: 56,
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

  Widget _fabHeader(BuildContext context) {
    if (widget.floatingActionButtonBuilder != null) {
      return SizedBox(
        width: double.infinity,
        child: _removeFabElevation(
          context,
          Builder(
            builder: (context) => widget.floatingActionButtonBuilder!(
              context,
              _isOpen,
            ),
          ),
        ),
      );
    }
    return SizedBox();
  }

  Widget _shrinkable(BuildContext context, Widget? child) => SizeTransition(
        sizeFactor: iconAnimController,
        axis: Axis.horizontal,
        axisAlignment: -1,
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      );

  Iterable<_ExpandableRailItem> _railItems(
    BuildContext context,
    MD3NavigationSpec spec,
  ) =>
      spec.items.mapIndexed(
        (e, i) {
          final selected = spec.selectedIndex == i;
          return _ExpandableRailItem(
            icon: selected ? e.activeIcon : e.icon,
            isSelected: selected,
            label: e.label,
            tileExpansionAnimation: iconAnimController,
            tooltip: e.labelText,
            onTap: () => spec.onChanged(i),
          );
        },
      );
  Widget _appBarSizedHeader(BuildContext context, double? appBarHeight) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: appBarHeight ?? double.infinity,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _shrinkable(context, widget.header)),
            if (widget.canExpand) _menuButton(context),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final appBarHeight = MD3AppBarSizeInfo.maybeOf(context)?.size?.height;
    return ShrinkableDrawerController(
      key: shrinkableDrawerController,
      shrunkWidth: 80,
      drawerCallback: _onDrawerChange,
      alignment: DrawerAlignment.start,
      child: MD3NavigationDrawer(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            SizedBox(
              height: appBarHeight,
              child: _appBarSizedHeader(context, appBarHeight),
            ),
            _fabHeader(context),
            Expanded(
              child: Align(
                alignment: Alignment(0, widget.railAlignment),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _railItems(
                    context,
                    widget.spec,
                  ).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ExpandableRailItem extends StatelessWidget {
  const _ExpandableRailItem({
    Key? key,
    required this.tileExpansionAnimation,
    this.tooltip,
    this.isSelected = false,
    this.onTap,
    required this.icon,
    required this.label,
  }) : super(key: key);
  final Animation<double> tileExpansionAnimation;
  final String? tooltip;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget icon;
  final Widget label;

  Widget _tileLabel(BuildContext context, Widget? child) => SizeTransition(
        sizeFactor: tileExpansionAnimation,
        axis: Axis.horizontal,
        axisAlignment: -1,
        child: Align(
          alignment: Alignment.centerLeft,
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final child = NavigationDrawerItem(
      icon: icon,
      selected: isSelected,
      title: _tileLabel(context, label),
      onTap: onTap,
    );
    if (tileExpansionAnimation.isCompleted || tooltip == null) {
      return child;
    }

    return Tooltip(
      message: tooltip,
      child: child,
    );
  }
}

Widget _buildDrawer(
  MD3NavigationSpec spec,
  Widget? drawerHeader, {
  bool noLabel = false,
  bool tooltip = false,
  Radius radius = Radius.zero,
}) =>
    MD3NavigationDrawer(
      radius: radius,
      child: ListView(
        primary: false,
        children: [
          drawerHeader ??
              const NavigationDrawerHeader(
                title: Text('Navegação'),
              ),
          ..._navigationDrawerItems(
            spec,
            noLabel: noLabel,
            tooltip: tooltip,
          )
        ],
      ),
    );

Iterable<Widget> _navigationDrawerItems(
  MD3NavigationSpec spec, {
  bool noLabel = false,
  bool tooltip = false,
}) =>
    spec.items.mapIndexed(
      (e, i) {
        final selected = spec.selectedIndex == i;
        final child = NavigationDrawerItem(
          icon: selected ? e.activeIcon : e.icon,
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
