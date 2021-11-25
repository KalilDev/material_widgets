import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_appBar/raw_appBar.dart';
import 'package:material_you/material_you.dart';

class MD3SliverAppBar extends StatefulWidget {
  const MD3SliverAppBar({
    Key key,
    this.title,
    this.leading,
    this.actions = const [],
    this.expandable = true,
    this.primary = true,
    this.pinned = true,
  }) : super(key: key);
  final Widget title;
  final Widget leading;
  final List<Widget> actions;

  /// Whether or not this [MD3SliverAppBar] can expand from an small appbar to
  /// an large appbar
  final bool expandable;
  final bool primary;
  final bool pinned;

  @override
  State<MD3SliverAppBar> createState() => _MD3SliverAppBarState();
}

class _MD3SliverAppBarState extends State<MD3SliverAppBar> {
  double get _bottomPadding => 28;

  double get _bottomHeight => widget.expandable ? 88 : 0;

  void dispose() {
    super.dispose();
  }

  void _notifySize(double height) => null;

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

    notifySize(
        (maxExtent - shrinkOffset).clamp(minExtent, maxExtent).toDouble());

    final isElevated =
        bottomHeight != 0 ? bottomTitleOpacity != 1.0 : shrinkOffset > 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MD3RawAppBar(
          isElevated: isElevated,
          title: _opacityTextStyle(
            opacity: topTitleOpacity,
            style: titleTextStyle,
            child: title,
          ),
          appBarHeight: 64,
          actions: actions,
          leading: leading,
          primary: primary,
          notifySize: false,
        ),
        if (bottomHeight != 0.0)
          _bottom(
            (bottomHeight - shrinkOffset).clamp(0.0, bottomHeight).toDouble(),
            bottomTitleOpacity,
          ),
      ],
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
