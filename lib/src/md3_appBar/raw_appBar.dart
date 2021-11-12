import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_you/material_you.dart';

Size _preferredAppBarSize(double toolbarHeight, double bottomHeight) {
  toolbarHeight ??= kToolbarHeight;
  bottomHeight ??= 0;
  return Size.fromHeight(toolbarHeight + bottomHeight);
}

/// An [AppBar] class which is colored with surface+elevation.level0 tint, and
/// when it is inside an scrollable body, and it is scrolled, animates the
/// background color to the elevation level2.
class MD3RawAppBar extends StatefulWidget implements PreferredSizeWidget {
  MD3RawAppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.shadowColor,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.primary = true,
    this.centerTitle,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.appBarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.elevationDuration = const Duration(milliseconds: 200),
  })  : assert(automaticallyImplyLeading != null),
        assert(primary != null),
        assert(toolbarOpacity != null),
        assert(bottomOpacity != null),
        preferredSize =
            _preferredAppBarSize(appBarHeight, bottom?.preferredSize?.height),
        super(key: key);

  static Size prefferedAppBarSize(double appBarHeight, double bottomHeight) =>
      _preferredAppBarSize(appBarHeight, bottomHeight);

  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final Color shadowColor;
  final ShapeBorder shape;
  final IconThemeData iconTheme;
  final IconThemeData actionsIconTheme;
  final bool primary;
  final bool centerTitle;
  final bool excludeHeaderSemantics;
  final double titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  @override
  final Size preferredSize;
  final double appBarHeight;
  final double leadingWidth;
  final TextStyle toolbarTextStyle;
  final TextStyle titleTextStyle;
  final Duration elevationDuration;

  @override
  _MD3RawAppBarState createState() => _MD3RawAppBarState();
}

class _MD3RawAppBarState extends State<MD3RawAppBar>
    with SingleTickerProviderStateMixin {
  ScrollController primaryScrollController;
  AnimationController backgroundController;
  Tween<Color> get backgroundColorTween => ColorTween(
        begin: context.elevation.level0.overlaidColor(
          context.colorScheme.surface,
          MD3ElevationLevel.surfaceTint(context.colorScheme),
        ),
        end: context.elevation.level2.overlaidColor(
          context.colorScheme.surface,
          MD3ElevationLevel.surfaceTint(context.colorScheme),
        ),
      );
  Animation<double> backgroundColorAnimation;
  @override
  void initState() {
    super.initState();
    backgroundController = AnimationController(
      vsync: this,
      duration: widget.elevationDuration,
    );
    backgroundColorAnimation = CurvedAnimation(
      parent: backgroundController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final primaryScrollController = PrimaryScrollController.of(context);
    _updatePrimaryScrollController(primaryScrollController);
  }

  @override
  void didUpdateWidget(MD3RawAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    backgroundController.duration = widget.elevationDuration;
  }

  @override
  void dispose() {
    backgroundController.dispose();
    super.dispose();
  }

  void _updatePrimaryScrollController(ScrollController controller) {
    if (controller == primaryScrollController) {
      return;
    }
    primaryScrollController?.removeListener(_onScroll);
    primaryScrollController = controller;
    controller.addListener(_onScroll);
    _updateIsScrolled();
  }

  void _updateIsScrolled() {
    final positions = primaryScrollController.positions;
    final offset = positions
        .map((e) => e.pixels)
        .fold<double>(0.0, (largest, e) => max(largest, e));
    final isScrolled = offset > 0;
    if (isScrolled) {
      if (backgroundController.velocity > 0 ||
          backgroundController.isCompleted) {
        return;
      }
      backgroundController.forward();
      return;
    }
    if (backgroundController.velocity < 0 || backgroundController.isDismissed) {
      return;
    }
    backgroundController.reverse();
  }

  void _onScroll() {
    _updateIsScrolled();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: backgroundColorTween.animate(backgroundColorAnimation),
      builder: (context, backgroundColor, _) => AppBar(
        backgroundColor: backgroundColor,
        leading: widget.leading,
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        title: widget.title,
        actions: widget.actions,
        flexibleSpace: widget.flexibleSpace,
        bottom: widget.bottom,
        shadowColor: widget.shadowColor,
        shape: widget.shape,
        iconTheme: widget.iconTheme,
        actionsIconTheme: widget.actionsIconTheme,
        primary: widget.primary,
        centerTitle: widget.centerTitle,
        excludeHeaderSemantics: widget.excludeHeaderSemantics,
        titleSpacing: widget.titleSpacing,
        toolbarOpacity: widget.toolbarOpacity,
        bottomOpacity: widget.bottomOpacity,
        toolbarHeight: widget.appBarHeight,
        leadingWidth: widget.leadingWidth,
        toolbarTextStyle: widget.toolbarTextStyle,
        titleTextStyle: widget.titleTextStyle,
        systemOverlayStyle: _systemUiOverlayStyle(context, backgroundColor),
      ),
    );
  }

  SystemUiOverlayStyle _systemUiOverlayStyle(
    BuildContext context,
    Color backgroundColor,
  ) =>
      SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarBrightness: ThemeData.estimateBrightnessForColor(
          backgroundColor,
        ),
        statusBarIconBrightness: ThemeData.estimateBrightnessForColor(
          context.colorScheme.onSurface,
        ),
        systemNavigationBarContrastEnforced: false,
      );
}
