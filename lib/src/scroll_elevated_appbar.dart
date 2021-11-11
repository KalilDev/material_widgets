import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_you/material_you.dart';

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
            (toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double toolbarHeight;
  final double bottomHeight;
}

class MD3ScrollElevatedAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  MD3ScrollElevatedAppBar({
    Key key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
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
    this.toolbarHeight,
    this.leadingWidth,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
  })  : assert(automaticallyImplyLeading != null),
        assert(elevation == null || elevation >= 0.0),
        assert(primary != null),
        assert(toolbarOpacity != null),
        assert(bottomOpacity != null),
        preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize?.height),
        super(key: key);

  final Widget leading;
  final bool automaticallyImplyLeading;
  final Widget title;
  final List<Widget> actions;
  final Widget flexibleSpace;
  final PreferredSizeWidget bottom;
  final double elevation;
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
  final double toolbarHeight;
  final double leadingWidth;
  final TextStyle toolbarTextStyle;
  final TextStyle titleTextStyle;
  final SystemUiOverlayStyle systemOverlayStyle;

  @override
  _MD3ScrollElevatedAppBarState createState() =>
      _MD3ScrollElevatedAppBarState();
}

class _MD3ScrollElevatedAppBarState extends State<MD3ScrollElevatedAppBar>
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
  void initState() {
    super.initState();
    backgroundController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    backgroundColorAnimation =
        CurvedAnimation(parent: backgroundController, curve: Curves.easeInOut);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final primaryScrollController = PrimaryScrollController.of(context);
    _updatePrimaryScrollController(primaryScrollController);
  }

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
        elevation: widget.elevation,
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
        toolbarHeight: widget.toolbarHeight,
        leadingWidth: widget.leadingWidth,
        toolbarTextStyle: widget.toolbarTextStyle,
        titleTextStyle: widget.titleTextStyle,
        systemOverlayStyle: widget.systemOverlayStyle,
      ),
    );
  }
}
