import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

class MD3AdaptativeScaffold extends StatelessWidget {
  const MD3AdaptativeScaffold({
    Key? key,
    this.scaffoldKey,
    this.appBar,
    this.bottomNavigationBar,
    required this.body,
    this.startDrawer,
    this.endDrawer,
    this.startModalDrawer,
    this.endModalDrawer,
    this.floatingActionButton,
    this.surfaceTintBackground = true,
    this.bodyMargin = true,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Widget? startDrawer;
  final Widget? endDrawer;
  final Widget? startModalDrawer;
  final Widget? endModalDrawer;
  final Widget? floatingActionButton;
  final bool surfaceTintBackground;
  final bool bodyMargin;

  Widget _buildBody(BuildContext context) {
    final sizeClass = context.sizeClass;
    final isExpanded = sizeClass == MD3WindowSizeClass.expanded;

    final minMargin = bodyMargin ? context.sizeClass.minimumMargins : 0.0;
    final maxMargin = bodyMargin ? (isExpanded ? 200.0 : minMargin) : 0.0;

    Color background;
    Color foreground;
    if (!surfaceTintBackground) {
      background = context.colorScheme.background;
      foreground = context.colorScheme.onBackground;
    } else {
      background = context.elevation.level0.overlaidColor(
        context.colorScheme.surface,
        MD3ElevationLevel.surfaceTint(context.colorScheme),
      );
      foreground = context.colorScheme.onSurface;
    }
    return _BodySection(
      scaffoldKey: scaffoldKey,
      minMargin: minMargin,
      maxMargin: maxMargin,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: DefaultTextStyle.merge(
        style: TextStyle(color: foreground),
        child: body,
      ),
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
    Key? key,
    this.scaffoldKey,
    required this.minMargin,
    required this.maxMargin,
    this.appBar,
    this.bottomNavigationBar,
    required this.body,
    this.startDrawer,
    this.endDrawer,
    required this.background,
    this.floatingActionButton,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final double minMargin;
  final double maxMargin;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Widget? startDrawer;
  final Widget? endDrawer;
  final Color background;
  final Widget? floatingActionButton;

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
