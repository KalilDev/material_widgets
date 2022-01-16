// ignore_for_file: parameter_assignments, unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_widgets/src/md3_appBar/size_scope.dart';
import 'package:material_you/material_you.dart';

import 'controller.dart';

Size _preferredAppBarSize(double? toolbarHeight, double? bottomHeight) {
  toolbarHeight ??= kToolbarHeight;
  bottomHeight ??= 0;
  return Size.fromHeight(toolbarHeight + bottomHeight);
}

/// An [AppBar] class which is colored with surface+elevation.level0 tint, and
/// when it is inside an scrollable body, and it is scrolled, animates the
/// background color to the elevation level2.
class MD3RawAppBar extends StatefulWidget implements PreferredSizeWidget {
  MD3RawAppBar({
    Key? key,
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
    this.isElevated,
    this.elevationDuration = const Duration(milliseconds: 200),
    this.notifySize = true,
    this.backgroundColor,
  })  : assert(primary != null),
        preferredSize =
            _preferredAppBarSize(appBarHeight, bottom?.preferredSize.height),
        super(key: key);

  static Size prefferedAppBarSize(double appBarHeight, double bottomHeight) =>
      _preferredAppBarSize(appBarHeight, bottomHeight);

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  @override
  final Size preferredSize;
  final double? appBarHeight;
  final double? leadingWidth;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;

  /// Whether or not the AppBar is elevated. When it is null, the
  /// [PrimaryScrollController] is checked. Otherwise this value is used.
  final bool? isElevated;
  final Duration elevationDuration;
  final bool notifySize;
  final MaterialStateProperty<Color?>? backgroundColor;

  @override
  _MD3RawAppBarState createState() => _MD3RawAppBarState();
}

class _MD3RawAppBarState extends State<MD3RawAppBar>
    with SingleTickerProviderStateMixin {
  late Handle<MD3AppBarSizeScopeState> _sizeScopeHandle;
  late Handle<ValueListenable<bool>> _scrollingNotifierHandle;
  bool _isScrollingUnder = false;

  static bool _shouldNotifySize(MD3RawAppBar widget) =>
      widget.primary && widget.notifySize;

  late AnimationController backgroundController;

  Tween<Color?> backgroundColorTweenFrom(
    MaterialStateProperty<Color> backgroundColor,
  ) =>
      ColorTween(
        begin: backgroundColor.resolve({}),
        end: backgroundColor.resolve({MaterialState.scrolledUnder}),
      );

  MaterialStateProperty<Color> _defaultBackgroundColor(BuildContext context) =>
      MD3ElevationTintableColor(
        context.colorScheme.surface,
        MD3ElevationLevel.surfaceTint(context.colorScheme),
        MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.scrolledUnder)
              ? context.elevation.level2
              : context.elevation.level0,
        ),
      );

  MaterialStateProperty<Color> _effectiveBackgroundColor(BuildContext context) {
    final defaultBackgroundColor = _defaultBackgroundColor(context);
    final widgetBackgroundColor = widget.backgroundColor;
    if (widgetBackgroundColor == null) {
      return defaultBackgroundColor;
    }

    return MaterialStateProperty.resolveWith(
      (states) =>
          widgetBackgroundColor.resolve(states) ??
          defaultBackgroundColor.resolve(states),
    );
  }

  late Animation<double> backgroundColorAnimation;

  void _onScrolledUpdate() {
    final isScrollingUnder = _scrollingNotifierHandle.value!.value;
    if (isScrollingUnder == _isScrollingUnder) {
      return;
    }
    _isScrollingUnder = isScrollingUnder;
    if (widget.isElevated != null || !widget.primary) {
      return;
    }
    if (isScrollingUnder) {
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
    if (widget.isElevated != null || !widget.primary) {
      backgroundController.value = (widget.isElevated ?? false) ? 1.0 : 0.0;
    }
    _sizeScopeHandle = Handle(
      (scope) => scope.registerAppBar(this, widget.preferredSize),
      (scope) => scope.unregisterAppBar(this),
    );
    _scrollingNotifierHandle = Handle(
      (notifier) {
        notifier.addListener(_onScrolledUpdate);
        if (_isScrollingUnder != notifier.value) {
          _onScrolledUpdate();
        }
      },
      (notifier) => notifier.removeListener(_onScrolledUpdate),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollingNotifierHandle
        // may be null when we arent on the expected appbar locations.
        // in which case, the handle will just be kept detached.
        .update(MD3AppBarScope.maybeOf(context)?.isScrolledUnder);
    _sizeScopeHandle.update(
      _shouldNotifySize(widget)
          ? MD3AppBarSizeScopeState.maybeOf(context)
          : null,
    );
  }

  @override
  void didUpdateWidget(MD3RawAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    backgroundController.duration = widget.elevationDuration;
    if (oldWidget.isElevated != widget.isElevated || !widget.primary) {
      _updateIsElevated(widget.isElevated ?? (widget.primary ? false : null));
    }
    if (oldWidget.preferredSize != widget.preferredSize) {
      _sizeScopeHandle.value?.updateAppBarSize(this, widget.preferredSize);
    }
  }

  void _updateIsElevated(bool? curr) {
    if (curr == null) {
      _onScrolledUpdate();
      return;
    }
    final currVal = curr ? 1.0 : 0.0;
    if (!backgroundController.isAnimating &&
        backgroundController.value == currVal) {
      return;
    }
    backgroundController.animateTo(currVal);
  }

  @override
  void deactivate() {
    _sizeScopeHandle.detach();
    super.deactivate();
  }

  @override
  void dispose() {
    backgroundController.dispose();
    _sizeScopeHandle.dispose();
    _scrollingNotifierHandle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColorTween = backgroundColorTweenFrom(
      _effectiveBackgroundColor(context),
    );
    return ValueListenableBuilder<Color?>(
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
        systemOverlayStyle: _systemUiOverlayStyle(context, backgroundColor!),
      ),
    );
  }

  SystemUiOverlayStyle _systemUiOverlayStyle(
    BuildContext context,
    Color backgroundColor,
  ) =>
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: ThemeData.estimateBrightnessForColor(
          backgroundColor,
        ),
        statusBarIconBrightness: ThemeData.estimateBrightnessForColor(
          context.colorScheme.onSurface,
        ),
      );
}
