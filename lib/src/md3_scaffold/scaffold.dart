import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import '../md3_appBar/controller.dart';
import '../navigation_drawer.dart';
import 'body.dart';

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

  Widget _buildBody(BuildContext context) {
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
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      body: DefaultTextStyle.merge(
        style: TextStyle(color: foreground),
        child: MD3ScaffoldBody.maybeWrap(child: body),
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
    final startDrawer = _wrapDrawer(this.startDrawer, false, false);
    final endDrawer = _wrapDrawer(this.endDrawer, false, true);
    final leftDrawer = isLtr ? startDrawer : endDrawer;
    final rightDrawer = isLtr ? endDrawer : startDrawer;
    return MD3AppBarController(
      child: Row(
        // We already handle the directionality
        textDirection: TextDirection.ltr,
        children: [
          if (leftDrawer != null)
            Builder(
              builder: (context) => MD3AppBarScope(
                isScrolledUnder:
                    MD3AppBarControllerScope.of(context).isLeftScrolledUnder,
                child: leftDrawer,
              ),
            ),
          Expanded(child: _buildBody(context)),
          if (rightDrawer != null)
            Builder(
              builder: (context) => MD3AppBarScope(
                isScrolledUnder:
                    MD3AppBarControllerScope.of(context).isRightScrolledUnder,
                child: rightDrawer,
              ),
            ),
        ],
      ),
    );
  }
}

Widget? _wrapDrawer(Widget? drawer, bool isModal, bool isEnd) => drawer == null
    ? null
    : MD3DrawerScope(
        isModal: isModal,
        isEnd: isEnd,
        child: drawer,
      );

class _BodySection extends StatelessWidget {
  const _BodySection({
    Key? key,
    this.scaffoldKey,
    this.appBar,
    this.bottomNavigationBar,
    required this.body,
    this.startDrawer,
    this.endDrawer,
    required this.background,
    this.floatingActionButton,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Widget? startDrawer;
  final Widget? endDrawer;
  final Color background;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) => Scaffold(
        key: scaffoldKey,
        appBar: appBar == null
            ? null
            : MD3AppBarScope(
                isScrolledUnder:
                    MD3AppBarControllerScope.of(context).isTopScrolledUnder,
                child: appBar!,
              ),
        body: body,
        backgroundColor: background,
        bottomNavigationBar: bottomNavigationBar == null
            ? null
            : MD3AppBarScope(
                isScrolledUnder:
                    MD3AppBarControllerScope.of(context).isBottomScrolledUnder,
                child: bottomNavigationBar!,
              ),
        drawer: _wrapDrawer(startDrawer, true, false),
        endDrawer: _wrapDrawer(endDrawer, true, true),
        floatingActionButton: floatingActionButton,
      );
}
