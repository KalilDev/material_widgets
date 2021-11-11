import 'package:material_widgets/src/navigation_drawer.dart';
import 'package:material_widgets/src/standard_drawer_controller.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';

import '../shrinkable_drawer_controller.dart';

class MD3AdaptativeScaffold extends StatelessWidget {
  const MD3AdaptativeScaffold({
    Key key,
    this.scaffoldKey,
    this.appBar,
    this.bottomNavigationBar,
    this.body,
    this.startDrawer,
    this.endDrawer,
    this.startModalDrawer,
    this.endModalDrawer,
    this.floatingActionButton,
    this.surfaceTintBackground = true,
    this.bodyMargin = true,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final PreferredSizeWidget appBar;
  final Widget bottomNavigationBar;
  final Widget body;
  final Widget startDrawer;
  final Widget endDrawer;
  final Widget startModalDrawer;
  final Widget endModalDrawer;
  final Widget floatingActionButton;
  final bool surfaceTintBackground;
  final bool bodyMargin;

  Widget _buildBody(BuildContext context) {
    final sizeClass = context.sizeClass;
    final isExpanded = sizeClass == MD3WindowSizeClass.expanded;
    var minMargin = bodyMargin ? context.sizeClass.minimumMargins : 0.0,
        maxMargin = bodyMargin ? (isExpanded ? 200.0 : minMargin) : 0.0;
    Color background;
    if (sizeClass == MD3WindowSizeClass.compact || !surfaceTintBackground) {
      background = context.colorScheme.background;
    } else {
      background = context.elevation.level0.overlaidColor(
        context.colorScheme.surface,
        MD3ElevationLevel.surfaceTint(context.colorScheme),
      );
    }
    return _BodySection(
      scaffoldKey: scaffoldKey,
      minMargin: minMargin,
      maxMargin: maxMargin,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
      background: background,
      startDrawer: startModalDrawer,
      endDrawer: endModalDrawer,
      floatingActionButton: floatingActionButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    final leftDrawer = isLtr ? startDrawer : endDrawer;
    final rightDrawer = isLtr ? endDrawer : startDrawer;
    return Row(
      children: [
        if (leftDrawer != null) leftDrawer,
        Expanded(child: _buildBody(context)),
        if (rightDrawer != null) rightDrawer,
      ],
    );
  }
}

class _BodySection extends StatelessWidget {
  const _BodySection({
    Key key,
    this.scaffoldKey,
    this.minMargin,
    this.maxMargin,
    this.appBar,
    this.bottomNavigationBar,
    this.body,
    this.startDrawer,
    this.endDrawer,
    this.background,
    this.floatingActionButton,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final double minMargin;
  final double maxMargin;
  final PreferredSizeWidget appBar;
  final Widget bottomNavigationBar;
  final Widget body;
  final Widget startDrawer;
  final Widget endDrawer;
  final Color background;
  final Widget floatingActionButton;

  Widget _margin() => ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minMargin,
          maxWidth: maxMargin,
        ),
      );

  Widget _buildBody(BuildContext context) => Row(
        children: [
          _margin(),
          Expanded(child: body),
          _margin(),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        key: scaffoldKey,
        appBar: appBar,
        body: _buildBody(context),
        backgroundColor: background,
        bottomNavigationBar: bottomNavigationBar,
        drawer: startDrawer,
        endDrawer: endDrawer,
        floatingActionButton: floatingActionButton,
      );
}
