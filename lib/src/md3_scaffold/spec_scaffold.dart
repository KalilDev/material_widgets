import 'package:flutter/material.dart';

import 'scaffold.dart';

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
    Widget Function(BuildContext, Widget)? buildScaffold,
    this.surfaceTintBackground = true,
  }) : wrapScaffold = buildScaffold;

  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Widget? startDrawer;
  final Widget? endDrawer;
  final Widget? startModalDrawer;
  final Widget? endModalDrawer;
  final Widget? floatingActionButton;
  final Widget Function(BuildContext, Widget)? wrapScaffold;
  final bool surfaceTintBackground;
}

class MD3AdaptativeSpecScaffold extends StatelessWidget {
  const MD3AdaptativeSpecScaffold({
    Key? key,
    this.scaffoldKey,
    required this.scaffoldSpec,
  }) : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final MD3AdaptativeScaffoldSpec scaffoldSpec;

  @override
  Widget build(BuildContext context) {
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
      surfaceTintBackground: scaffoldSpec.surfaceTintBackground,
    );
    if (scaffoldSpec.wrapScaffold != null) {
      return scaffoldSpec.wrapScaffold!(context, scaffold);
    }
    return scaffold;
  }
}
