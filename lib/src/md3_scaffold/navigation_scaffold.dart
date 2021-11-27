import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

abstract class MD3NavigationDelegate {
  const MD3NavigationDelegate();
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

class NavigationItem {
  final Widget label;
  final Widget icon;
  final Widget? activeIcon;
  final Color? backgroundColor;
  final String labelText;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.backgroundColor,
    required this.labelText,
  });
}

class MD3NavigationSpec {
  final List<NavigationItem> items;
  final ValueChanged<int> onChanged;
  final int selectedIndex;

  const MD3NavigationSpec({
    required this.items,
    required this.onChanged,
    required this.selectedIndex,
  });
}

class MD3NavigationScaffold extends StatelessWidget {
  const MD3NavigationScaffold({
    Key? key,
    this.scaffoldKey,
    required this.spec,
    required this.delegate,
    this.surfaceTintBackground = true,
    this.bodyMargin = true,
    this.body,
  }) : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final MD3NavigationSpec spec;
  final MD3NavigationDelegate delegate;
  final bool surfaceTintBackground;
  final bool bodyMargin;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    late MD3AdaptativeScaffoldSpec scaffoldSpec;
    switch (context.sizeClass) {
      case MD3WindowSizeClass.compact:
        scaffoldSpec = delegate.buildCompact(context, spec, body!);
        break;
      case MD3WindowSizeClass.medium:
        scaffoldSpec = delegate.buildMedium(context, spec, body!);
        break;
      case MD3WindowSizeClass.expanded:
        scaffoldSpec = delegate.buildExpanded(context, spec, body!);
        break;
    }
    final scaffold = MD3AdaptativeScaffold(
      scaffoldKey: scaffoldKey,
      appBar: scaffoldSpec.appBar,
      bottomNavigationBar: scaffoldSpec.bottomNavigationBar,
      floatingActionButton: scaffoldSpec.floatingActionButton,
      body: scaffoldSpec.body,
      startDrawer: scaffoldSpec.startDrawer,
      endDrawer: scaffoldSpec.endDrawer,
      startModalDrawer: scaffoldSpec.startModalDrawer,
      endModalDrawer: scaffoldSpec.endModalDrawer,
      surfaceTintBackground: surfaceTintBackground,
      bodyMargin: bodyMargin,
    );
    if (scaffoldSpec.buildScaffold != null) {
      return scaffoldSpec.buildScaffold!(context, scaffold);
    }
    return scaffold;
  }
}

class MD3AdaptativeScaffoldSpec {
  const MD3AdaptativeScaffoldSpec({
    this.appBar,
    this.bottomNavigationBar,
    required this.body,
    this.startDrawer,
    this.endDrawer,
    this.startModalDrawer,
    this.endModalDrawer,
    this.floatingActionButton,
    this.buildScaffold,
  });

  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Widget? startDrawer;
  final Widget? endDrawer;
  final Widget? startModalDrawer;
  final Widget? endModalDrawer;
  final Widget? floatingActionButton;
  final Widget Function(BuildContext, Widget)? buildScaffold;
}
