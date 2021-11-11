import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

abstract class MD3NavigationDelegate {
  const MD3NavigationDelegate();
  MD3AdaptativeScaffoldWidgets buildCompact(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  );
  MD3AdaptativeScaffoldWidgets buildMedium(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  );
  MD3AdaptativeScaffoldWidgets buildExpanded(
    BuildContext context,
    MD3NavigationSpec spec,
    Widget body,
  );
}

class NavigationItem {
  final Widget label;
  final Widget icon;
  final Widget activeIcon;
  final Color backgroundColor;
  final String labelText;

  const NavigationItem({
    @required this.label,
    @required this.icon,
    @required this.activeIcon,
    this.backgroundColor,
    this.labelText,
  });
}

class MD3NavigationSpec {
  final List<NavigationItem> items;
  final ValueChanged<int> onChanged;
  final int selectedIndex;

  const MD3NavigationSpec({
    @required this.items,
    @required this.onChanged,
    this.selectedIndex,
  });
}

class MD3NavigationScaffold extends StatelessWidget {
  const MD3NavigationScaffold({
    Key key,
    this.scaffoldKey,
    this.spec,
    this.delegate,
    this.surfaceTintBackground = true,
    this.body,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  final MD3NavigationSpec spec;
  final MD3NavigationDelegate delegate;
  final bool surfaceTintBackground;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    MD3AdaptativeScaffoldWidgets widgets;
    switch (context.sizeClass) {
      case MD3WindowSizeClass.compact:
        widgets = delegate.buildCompact(context, spec, body);
        break;
      case MD3WindowSizeClass.medium:
        widgets = delegate.buildMedium(context, spec, body);
        break;
      case MD3WindowSizeClass.expanded:
        widgets = delegate.buildExpanded(context, spec, body);
        break;
    }
    return MD3AdaptativeScaffold(
      scaffoldKey: scaffoldKey,
      appBar: widgets.appBar,
      bottomNavigationBar: widgets.bottomNavigationBar,
      floatingActionButton: widgets.floatingActionButton,
      body: widgets.body,
      startDrawer: widgets.startDrawer,
      endDrawer: widgets.endDrawer,
      startModalDrawer: widgets.startModalDrawer,
      endModalDrawer: widgets.endModalDrawer,
      surfaceTintBackground: surfaceTintBackground,
    );
  }
}

class MD3AdaptativeScaffoldWidgets {
  const MD3AdaptativeScaffoldWidgets({
    this.appBar,
    this.bottomNavigationBar,
    this.body,
    this.startDrawer,
    this.endDrawer,
    this.startModalDrawer,
    this.endModalDrawer,
    this.floatingActionButton,
  });

  final PreferredSizeWidget appBar;
  final Widget bottomNavigationBar;
  final Widget body;
  final Widget startDrawer;
  final Widget endDrawer;
  final Widget startModalDrawer;
  final Widget endModalDrawer;
  final Widget floatingActionButton;
}
