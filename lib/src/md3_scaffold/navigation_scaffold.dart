import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

import 'spec_scaffold.dart';

class NavigationItem {
  factory NavigationItem({
    required String labelText,
    Widget? label,
    required Widget icon,
    Widget? activeIcon,
    String? tooltip,
  }) =>
      NavigationItem.raw(
        label: label ?? Text(labelText),
        icon: icon,
        activeIcon: activeIcon ?? icon,
        labelText: labelText,
        tooltip: tooltip,
      );
  const NavigationItem.raw({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.labelText,
    this.tooltip,
  });

  final Widget label;
  final Widget icon;
  final Widget activeIcon;
  final String labelText;
  final String? tooltip;
}

class MD3NavigationSpec {
  const MD3NavigationSpec({
    required this.items,
    required this.onChanged,
    required this.selectedIndex,
  });
  final List<NavigationItem> items;
  final ValueChanged<int> onChanged;
  final int selectedIndex;
}

class MD3NavigationScaffold extends StatelessWidget {
  const MD3NavigationScaffold({
    Key? key,
    this.scaffoldKey,
    required this.spec,
    required this.delegate,
    this.body,
  }) : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final MD3NavigationSpec spec;
  final MD3NavigationDelegate delegate;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    late final MD3AdaptativeScaffoldSpec scaffoldSpec;
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
    return MD3AdaptativeSpecScaffold(
      scaffoldKey: scaffoldKey,
      scaffoldSpec: scaffoldSpec,
    );
  }
}
