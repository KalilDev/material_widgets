import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import '../../material_widgets.dart';
import '../shrinkable_drawer_controller.dart';

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

  final PreferredSizeWidget? appBar;
  final Widget? drawerHeader;
  final Widget? endDrawer;
  final Widget? endModalDrawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonBuilder? navigationFabBuilder;
  final bool showModalDrawerOnCompact;

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
                selectedIcon: e.activeIcon,
                label: e.labelText,
                tooltip: e.tooltip,
              ),
            )
            .toList(),
      );

  @override
  MD3AdaptativeScaffoldSpec buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildExpandableRail(spec, body, false);

  @override
  MD3AdaptativeScaffoldSpec buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      _buildExpandableRail(spec, body, true);

  MD3AdaptativeScaffoldSpec _buildExpandableRail(
    MD3NavigationSpec spec,
    Widget body,
    bool canExpand,
  ) =>
      MD3AdaptativeScaffoldSpec(
        body: body,
        appBar: appBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton:
            navigationFabBuilder == null ? floatingActionButton : null,
        startDrawer: _ExpandableRail(
          spec: spec,
          floatingActionButtonBuilder: navigationFabBuilder,
          canExpand: canExpand,
        ),
        buildScaffold: (context, child) => MD3AppBarSizeScope(
          initialSize: appBar?.preferredSize ?? const Size.fromHeight(0),
          child: child,
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

  final PreferredSizeWidget? appBar;
  final Widget? drawerHeader;
  final Widget? bottomNavigationBar;
  final Widget? endDrawer;
  final Widget? endModalDrawer;
  final Widget? floatingActionButton;

  @override
  MD3AdaptativeScaffoldSpec buildCompact(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      MD3AdaptativeScaffoldSpec(
        body: body,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton: floatingActionButton,
        startModalDrawer: _buildDrawer(context, spec, drawerHeader),
      );

  @override
  MD3AdaptativeScaffoldSpec buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      buildCompact(context, spec, body);

  @override
  MD3AdaptativeScaffoldSpec buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  ) =>
      MD3AdaptativeScaffoldSpec(
        body: body,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        endDrawer: endDrawer,
        endModalDrawer: endModalDrawer,
        floatingActionButton: floatingActionButton,
        startDrawer: _buildDrawer(
          context,
          spec,
          drawerHeader,
          radius: Radius.zero,
        ),
      );
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
      child: _drawer(
        context,
        radius: Radius.zero,
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

Widget _drawer(
  BuildContext context, {
  Radius radius = const Radius.circular(16),
  Widget? child,
}) =>
    MD3NavigationDrawer(
      radius: radius,
      child: child,
    );

Widget _buildDrawer(
  BuildContext context,
  MD3NavigationSpec spec,
  Widget? drawerHeader, {
  bool noLabel = false,
  bool tooltip = false,
  Radius radius = const Radius.circular(16),
}) =>
    _drawer(
      context,
      child: SafeArea(
        child: ListView(
          primary: false,
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
      radius: radius,
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
