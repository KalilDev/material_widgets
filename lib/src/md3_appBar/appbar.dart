import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_widgets/src/monadic_value_listenable.dart';
import 'package:material_you/material_you.dart';
import 'responsive_appbar.dart';
import '../monadic_value_listenable.dart';

class _MD3AppBarTrailingIconContainer extends StatelessWidget {
  const _MD3AppBarTrailingIconContainer({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => IconTheme.merge(
        data: IconThemeData(color: context.colorScheme.onSurfaceVariant),
        child: SizedBox(
          height: 48,
          width: 48,
          child: child,
        ),
      );
}

///
/// https://m3.material.io/m3/pages/top-app-bar/specs/#51ac0fae-61c2-4abc-b8f9-1167bf54e875
class MD3CenterAlignedAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MD3CenterAlignedAppBar({
    Key key,
    this.leading,
    this.trailing,
    this.title,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
  }) : super(key: key);
  final Widget leading;
  final Widget trailing;
  final Widget title;
  final bool primary;
  final bool notifySize;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return MD3RawAppBar(
      centerTitle: true,
      title: title,
      leading: leading ?? _appBarNavigationItemOrPlaceholder(context),
      appBarHeight: 64,
      actions: [
        SizedBox(width: 12),
        _MD3AppBarTrailingIconContainer(
          child: trailing ?? _appBarNavigationItemOrPlaceholder(context, true),
        ),
        SizedBox(width: 4),
      ],
      primary: primary,
      notifySize: notifySize,
      isElevated: isElevated,
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(64);
}

Widget _appBarNavigationItemOrPlaceholder(
  BuildContext context, [
  bool end = false,
]) {
  final scaffold = Scaffold.maybeOf(context);
  if (end && (scaffold?.hasEndDrawer ?? false)) {
    // the AppBar widget will not add the hamburger menu automatically
    return IconButton(
      onPressed: scaffold.openEndDrawer,
      icon: Icon(Icons.menu),
    );
  }
  if (!end && (scaffold?.hasDrawer ?? false)) {
    // the AppBar widget will add the hamburger menu automatically
    return null;
  }
  if (ModalRoute.of(context).canPop && !end) {
    return const BackButton();
  }
  return const Icon(null);
}

///
/// https://m3.material.io/m3/pages/top-app-bar/specs/#14e23895-ac2e-40d8-b0f7-8d016c10a225
class MD3SmallAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MD3SmallAppBar({
    Key key,
    this.leading,
    this.actions,
    this.title,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
  }) : super(key: key);
  final Widget leading;
  final List<Widget> actions;
  final Widget title;
  final bool primary;
  final bool notifySize;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    var actions = this.actions;
    if (actions?.isEmpty ?? true) {
      actions = null;
    }
    return MD3RawAppBar(
      title: title,
      leading: leading ?? _appBarNavigationItemOrPlaceholder(context),
      titleSpacing: 0,
      appBarHeight: 64,
      actions: [
        SizedBox(width: 12),
        ...(actions
                ?.map(
                  (e) => _MD3AppBarTrailingIconContainer(
                    child: e,
                  ),
                )
                ?.toList() ??
            [
              _appBarNavigationItemOrPlaceholder(
                context,
                true,
              ),
            ]),
        SizedBox(width: 4),
      ],
      primary: primary,
      notifySize: notifySize,
      isElevated: isElevated,
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(64);

  static const double kHeight = 64;
}

///
/// https://m3.material.io/m3/pages/top-app-bar/specs/#e3fd3eba-0444-437c-9a82-071ef03d85b1
class MD3MediumAppBar extends _MD3LargeOrMediumAppBar {
  const MD3MediumAppBar({
    Key key,
    Widget leading,
    List<Widget> actions,
    Widget title,
    bool primary = true,
    bool notifySize = true,
    bool isElevated,
  }) : super(
          key: key,
          titleStyleBuilder: titleStyle,
          bottomHeight: kBottomHeight,
          bottomPadding: kBottomPadding,
          leading: leading,
          actions: actions,
          title: title,
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
        );
  static TextStyle titleStyle(BuildContext context) =>
      context.textTheme.headlineSmall.copyWith(
        color: context.colorScheme.onSurface,
      );
  static const double kHeight = 64 + kBottomHeight;
  static const double kBottomHeight = 48;
  static const double kBottomPadding = 24;
}

Widget _topPadding(Widget child, double padding) => child == null
    ? null
    : Padding(
        padding: EdgeInsets.only(top: padding),
        child: child,
      );

///
/// https://m3.material.io/m3/pages/top-app-bar/specs/#8140aaaf-5729-4368-a0f5-baef8d576dbf
class MD3LargeAppBar extends _MD3LargeOrMediumAppBar {
  const MD3LargeAppBar({
    Key key,
    Widget leading,
    List<Widget> actions,
    Widget title,
    bool primary = true,
    bool notifySize = true,
    bool isElevated,
  }) : super(
          key: key,
          titleStyleBuilder: titleStyle,
          bottomHeight: kBottomHeight,
          bottomPadding: kBottomPadding,
          leading: leading,
          actions: actions,
          title: title,
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
        );
  static TextStyle titleStyle(BuildContext context) =>
      context.textTheme.headlineMedium.copyWith(
        color: context.colorScheme.onSurface,
      );
  static const double kHeight = 64 + kBottomHeight;
  static const double kBottomHeight = 88;
  static const double kBottomPadding = 28;
}

// An app bar that interpolates between the large and medium app bars with the
// scroll
/// https://m3.material.io/m3/pages/top-app-bar/specs/#e3fd3eba-0444-437c-9a82-071ef03d85b1
/// https://m3.material.io/m3/pages/top-app-bar/specs/#8140aaaf-5729-4368-a0f5-baef8d576dbf
class MD3LargeOrMediumAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const MD3LargeOrMediumAppBar({
    Key key,
    this.leading,
    this.actions,
    this.title,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
  }) : super(key: key);
  final Widget leading;
  final List<Widget> actions;
  final Widget title;
  final bool primary;
  final bool notifySize;
  final bool isElevated;

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final Size preferredSize = const Size.fromHeight(kHeight);

  static const double kHeight = MD3LargeAppBar.kHeight;

  @override
  _MD3LargeOrMediumAppBarState createState() => _MD3LargeOrMediumAppBarState();
}

class _MD3LargeOrMediumAppBarState extends State<MD3LargeOrMediumAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController _expansionController;
  ScrollController/*!*/ _primaryScrollController;

  static const kDuration = Duration(milliseconds: 200);

  void initState() {
    super.initState();
    _expansionController = AnimationController(
      vsync: this,
      duration: kDuration,
    );
    expansionAnimation.parent = ReverseAnimation(_expansionController);
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    final primaryScrollController = PrimaryScrollController.of(context);
    _maybeUpdateScrollController(primaryScrollController);
  }

  void _onScroll() {
    _maybeUpdateScrollAnimation();
  }

  void _maybeUpdateScrollController(ScrollController controller) {
    if (_primaryScrollController == controller) {
      return;
    }
    _primaryScrollController?.removeListener(_onScroll);
    _primaryScrollController = controller;
    if (controller == null) {
      return;
    }
    _primaryScrollController.addListener(_onScroll);
    _maybeUpdateScrollAnimation();
  }

  // We jumped from the beggining to the end or the end to the beggining. This
  // is common on desktops, when the Scroll Wheel jumps more than kHeightDelta
  // pixels in one go
  bool _maybeAnimateHandleDesktopJump(double prev, double next) {
    Future<void> move([Duration duration]) => _expansionController.animateTo(
          next,
          duration: duration,
        );
    final extremes = {0.0, 1.0};
    final linear = ReverseAnimation(_expansionController);
    if (_expansionController.isAnimating) {
      final animationTarget =
          _expansionController.velocity.sign.isNegative ? 0.0 : 1.0;
      if (next == animationTarget) {
        // We are already animating in the direction of the target. Continue
        // animating.
        return true;
      }
      if (extremes.contains(next)) {
        // We are moving back in the other direction. Animate back.
        move().then((_) => expansionAnimation.parent = linear);
        return true;
      }
      // We are moving to an arbitrary point. Animate to it with an adjusted
      // duration.
      final delta = next - prev;
      final duration = kDuration * delta.abs();
      move(duration).then((_) => expansionAnimation.parent = linear);
      return true;
    }
    if (!extremes.containsAll([prev, next])) {
      return false;
    }

    expansionAnimation.parent = CurvedAnimation(
      parent: linear,
      curve: Curves.easeInOut,
    );
    move().then((_) => expansionAnimation.parent = linear);

    return true;
  }

  void _maybeUpdateScrollAnimation() {
    final furthestPixels = _primaryScrollController.positions
        .map((e) => e.pixels ?? 0.0)
        .fold<double>(0.0, (greatest, e) => max(greatest, e));
    final previousDt = _expansionController.value;
    final dt = (furthestPixels / kHeightDelta).clamp(0.0, 1.0).toDouble();
    if (dt == previousDt) {
      return;
    }
    if (_maybeAnimateHandleDesktopJump(previousDt, dt)) {
      return;
    }

    _expansionController.value = dt;
  }

  void dispose() {
    _expansionController.dispose();
    _primaryScrollController = null;
    super.dispose();
  }

  // 0 represents medium, 1 represents large
  ProxyAnimation expansionAnimation = ProxyAnimation();

  static final Tween<double> heightTween =
      Tween(begin: MD3MediumAppBar.kHeight, end: MD3LargeAppBar.kHeight);
  static final Tween<double> bottomHeightTween = Tween(
      begin: MD3MediumAppBar.kBottomHeight, end: MD3LargeAppBar.kBottomHeight);
  static final Tween<double> bottomPaddingTween = Tween(
      begin: MD3MediumAppBar.kBottomPadding,
      end: MD3LargeAppBar.kBottomPadding);
  static const double kHeightDelta =
      MD3LargeAppBar.kHeight - MD3MediumAppBar.kHeight;
  Tween<TextStyle> titleStyleTween(BuildContext context) => TextStyleTween(
        begin: MD3MediumAppBar.titleStyle(context),
        end: MD3LargeAppBar.titleStyle(context),
      );

  Widget buildAppBar(
    BuildContext context,
    double height,
    double bottomHeight,
    double bottomPadding,
    TextStyle titleStyle,
  ) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: height +
              (widget.primary ? MediaQuery.of(context).viewPadding.top : 0),
        ),
        child: _MD3LargeOrMediumAppBar(
          leading: widget.leading,
          actions: widget.actions,
          title: widget.title,
          titleStyleBuilder: (_) => titleStyle,
          bottomHeight: bottomHeight,
          bottomPadding: bottomPadding,
          primary: widget.primary,
          notifySize: widget.notifySize,
          isElevated: widget.isElevated,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final height = heightTween.animate(expansionAnimation);
    final bottomHeight = bottomHeightTween.animate(expansionAnimation);
    final bottomPadding = bottomPaddingTween.animate(expansionAnimation);
    final titleStyle = titleStyleTween(context).animate(expansionAnimation);

    final animatedWidget = height.bind(
      (height) => bottomHeight.bind(
        (bottomHeight) => bottomPadding.bind(
          (bottomPadding) => titleStyle.map(
            (titleStyle) => buildAppBar(
              context,
              height,
              bottomHeight,
              bottomPadding,
              titleStyle,
            ),
          ),
        ),
      ),
    );

    return runValueListenableWidget(animatedWidget);
  }
}

class _MD3LargeOrMediumAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _MD3LargeOrMediumAppBar({
    Key key,
    this.leading,
    this.actions,
    this.title,
    @required this.titleStyleBuilder,
    @required this.bottomHeight,
    @required this.bottomPadding,
    this.topAdditionalPaddding = 4.0,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
  }) : super(key: key);
  final Widget leading;
  final List<Widget> actions;
  final Widget title;
  final TextStyle Function(BuildContext) titleStyleBuilder;
  final double bottomHeight;
  final double bottomPadding;
  final double topAdditionalPaddding;
  final bool primary;
  final bool notifySize;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MD3RawAppBar(
          leading: leading ?? _appBarNavigationItemOrPlaceholder(context),
          titleSpacing: 0,
          actions: [
            const SizedBox(width: 12),
            // ignore: unnecessary_parenthesis
            ...(actions
                    ?.map(
                      (e) => _MD3AppBarTrailingIconContainer(
                        child: e,
                      ),
                    )
                    ?.map((e) => _topPadding(e, topAdditionalPaddding))
                    ?.toList() ??
                []),
            const SizedBox(width: 4),
          ],
          appBarHeight: 64.0 + topAdditionalPaddding,
          bottom: _MD3LargerAppBarBottom(
            height: bottomHeight - topAdditionalPaddding,
          ),
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
        ),
        Positioned(
          bottom: bottomPadding,
          left: 16,
          child: DefaultTextStyle(
            style: titleStyleBuilder(context),
            child: title,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64 + bottomHeight);
}

class _MD3LargerAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  _MD3LargerAppBarBottom({
    Key key,
    double height,
  })  : preferredSize = Size.fromHeight(height),
        super(key: key);
  final Size preferredSize;

  @override
  Widget build(BuildContext context) => SizedBox();
}
