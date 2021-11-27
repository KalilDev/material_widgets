import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_appBar/appbar.dart';
import 'package:material_widgets/src/md3_appBar/raw_appBar.dart';
import 'package:material_you/material_you.dart';

import 'size_scope.dart';

class MD3SliverAppBar extends StatefulWidget {
  const MD3SliverAppBar({
    Key key,
    this.title,
    this.leading,
    this.actions = const [],
    this.expandable = true,
    this.primary = true,
    this.pinned = true,
  })  : _center = false,
        super(key: key);

  /// Not on the spec, but may be useful.
  MD3SliverAppBar.center({
    Key key,
    this.title,
    this.leading,
    Widget action,
    this.expandable = true,
    this.primary = true,
    this.pinned = true,
  })  : _center = true,
        actions = action == null ? [] : [action],
        super(key: key);
  final Widget title;
  final Widget leading;
  final List<Widget> actions;

  /// Whether or not this [MD3SliverAppBar] can expand from an small appbar to
  /// an large appbar
  final bool expandable;
  final bool primary;
  final bool pinned;

  final bool _center;

  @override
  State<MD3SliverAppBar> createState() => _MD3SliverAppBarState();
}

class _MD3SliverAppBarState extends State<MD3SliverAppBar> {
  Handle<MD3AppBarSizeScopeState/*!*/> _sizeScopeHandle;

  static bool _shouldNotifySize(MD3RawAppBar widget) =>
      widget.primary && widget.notifySize;

  double get _bottomPadding => 28;

  double get _bottomHeight => widget.expandable ? 88 : 0;
  double _height;

  void initState() {
    super.initState();
    _sizeScopeHandle = Handle(
      (scope) => scope.registerAppBar(
        this,
        Size.fromHeight(_height ?? _bottomHeight + 64),
      ),
      (scope) => scope.unregisterAppBar(this),
    );
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _sizeScopeHandle.update(MD3AppBarSizeScopeState.maybeOf(context));
  }

  void deactivate() {
    _sizeScopeHandle.detach();
    super.deactivate();
  }

  void dispose() {
    _sizeScopeHandle.dispose();
    super.dispose();
  }

  void _notifySize(double height) {
    _height = height;
    _sizeScopeHandle.value?.updateAppBarSize(this, Size.fromHeight(height));
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    final topPadding =
        widget.primary ? MediaQuery.of(context).padding.top : 0.0;

    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: SliverPersistentHeader(
        delegate: _MD3SliverAppBarDelegate(
          bottomTitleTextStyle: context.textTheme.headlineMedium.copyWith(
            color: context.colorScheme.onSurface,
          ),
          titleTextStyle: context.textTheme.titleLarge.copyWith(
            color: context.colorScheme.onSurface,
          ),
          title: widget.title,
          bottomHeight: _bottomHeight,
          bottomPadding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: _bottomPadding,
          ),
          topPadding: topPadding,
          leading: widget.leading,
          actions: widget.actions,
          primary: widget.primary,
          center: widget._center,
          notifySize: _notifySize,
        ),
        pinned: widget.pinned,
      ),
    );
  }
}

class _MD3SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _MD3SliverAppBarDelegate({
    @required this.bottomTitleTextStyle,
    @required this.titleTextStyle,
    @required this.title,
    @required this.bottomHeight,
    @required this.bottomPadding,
    @required this.topPadding,
    @required this.leading,
    @required this.actions,
    @required this.primary,
    @required this.notifySize,
    @required this.center,
  });

  final TextStyle bottomTitleTextStyle;
  final TextStyle titleTextStyle;
  final Widget title;
  final double bottomHeight;
  final EdgeInsetsGeometry bottomPadding;
  final double topPadding;
  final Widget leading;
  final List<Widget> actions;
  final bool primary;
  final ValueChanged<double> notifySize;
  final bool center;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bottomPadding =
        this.bottomPadding.resolve(Directionality.of(context));
    final titleHeight = bottomTitleTextStyle.fontSize *
        (MediaQuery.maybeOf(context).textScaleFactor ?? 1) *
        (bottomTitleTextStyle.height ?? 1);
    final bottomTitleTopPaddding =
        bottomHeight - titleHeight - bottomPadding.bottom;
    final bottomTitleAndTopPadddingHeight = bottomHeight - bottomPadding.bottom;
    var bottomTitleOpacity =
        (shrinkOffset - bottomTitleTopPaddding) / titleHeight;
    bottomTitleOpacity = 1 - bottomTitleOpacity;
    bottomTitleOpacity = bottomTitleOpacity.clamp(0.0, 1.0) as double;
    var topTitleOpacity =
        (shrinkOffset - bottomTitleAndTopPadddingHeight) / bottomPadding.bottom;
    topTitleOpacity = topTitleOpacity.clamp(0.0, 1.0) as double;
    final fullHeight =
        (maxExtent - shrinkOffset).clamp(minExtent, maxExtent).toDouble();
    notifySize(fullHeight);

    final isElevated =
        bottomHeight != 0 ? bottomTitleOpacity != 1.0 : shrinkOffset > 0;
    return SizedBox(
      height: fullHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _appbar(isElevated, topTitleOpacity),
          if (bottomHeight != 0.0)
            _bottom(
              (bottomHeight - shrinkOffset).clamp(0.0, bottomHeight).toDouble(),
              bottomTitleOpacity,
            ),
        ],
      ),
    );
  }

  Widget _appbar(bool isElevated, double topTitleOpacity) {
    if (!center) {
      return MD3SmallAppBar(
        isElevated: isElevated,
        title: _opacityTextStyle(
          opacity: topTitleOpacity,
          style: titleTextStyle,
          child: title,
        ),
        actions: actions,
        leading: leading,
        primary: primary,
        notifySize: false,
      );
    }
    return MD3CenterAlignedAppBar(
      isElevated: isElevated,
      title: _opacityTextStyle(
        opacity: topTitleOpacity,
        style: titleTextStyle,
        child: title,
      ),
      leading: leading,
      trailing: actions.isEmpty ? null : actions.single,
      primary: primary,
      notifySize: false,
    );
  }

  Widget _bottom(
    double bottomHeight,
    double opacity,
  ) {
    return ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: math.max(bottomHeight / (maxExtent - minExtent), 0.0),
        child: SizedBox(
          height: this.bottomHeight,
          width: double.infinity,
          child: Padding(
            padding: bottomPadding,
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: _opacityTextStyle(
                opacity: opacity,
                style: bottomTitleTextStyle,
                child: title,
              ),
            ),
          ),
        ),
      ),
    );
  }

  DefaultTextStyle _opacityTextStyle({
    double opacity,
    TextStyle style,
    Widget child,
  }) =>
      DefaultTextStyle(
        style: style,
        child: Opacity(
          opacity: opacity,
          child: child,
        ),
      );

  @override
  double get maxExtent => minExtent + bottomHeight;

  @override
  double get minExtent => 64 + topPadding;

  @override
  // TODO
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
