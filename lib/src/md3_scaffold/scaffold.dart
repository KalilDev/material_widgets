import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import '../md3_appBar/controller.dart';
import '../md3_appBar/size_scope.dart';
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
    this.surfaceBackground = true,
    this.properties,
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
  final bool surfaceBackground;
  final MD3ScaffoldProperties? properties;

  Widget _buildBody(BuildContext context) {
    Color background;
    Color foreground;
    if (!surfaceBackground) {
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
      properties: properties,
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
      child: MD3AppBarSizeScope(
        initialSize: appBar?.preferredSize ?? const Size.fromHeight(0),
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
    this.properties,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget body;
  final Widget? startDrawer;
  final Widget? endDrawer;
  final Color background;
  final Widget? floatingActionButton;
  final MD3ScaffoldProperties? properties;

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
        floatingActionButtonLocation: properties?.floatingActionButtonLocation,
        floatingActionButtonAnimator: properties?.floatingActionButtonAnimator,
        drawerScrimColor: properties?.drawerScrimColor,
        resizeToAvoidBottomInset: properties?.resizeToAvoidBottomInset,
        primary: properties?.primary ?? true,
        drawerDragStartBehavior:
            properties?.drawerDragStartBehavior ?? DragStartBehavior.start,
        drawerEdgeDragWidth: properties?.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture:
            properties?.drawerEnableOpenDragGesture ?? true,
        endDrawerEnableOpenDragGesture:
            properties?.endDrawerEnableOpenDragGesture ?? true,
        restorationId: properties?.restorationId,
      );
}

/// The set of properties for an scaffold that are supported by
/// [MD3AdaptativeScaffold].
class MD3ScaffoldProperties with Diagnosticable {
  const MD3ScaffoldProperties({
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.drawerScrimColor,
    this.resizeToAvoidBottomInset,
    this.primary,
    this.drawerDragStartBehavior,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture,
    this.restorationId,
  });

  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final Color? drawerScrimColor;
  final bool? resizeToAvoidBottomInset;
  final bool? primary;
  final DragStartBehavior? drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool? drawerEnableOpenDragGesture;
  final bool? endDrawerEnableOpenDragGesture;
  final String? restorationId;

  @override
  int get hashCode => Object.hashAll([
        floatingActionButtonLocation,
        floatingActionButtonAnimator,
        drawerScrimColor,
        resizeToAvoidBottomInset,
        primary,
        drawerDragStartBehavior,
        drawerEdgeDragWidth,
        drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture,
        restorationId,
      ]);

  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! MD3ScaffoldProperties) {
      return false;
    }
    return true &&
        floatingActionButtonLocation == other.floatingActionButtonLocation &&
        floatingActionButtonAnimator == other.floatingActionButtonAnimator &&
        drawerScrimColor == other.drawerScrimColor &&
        resizeToAvoidBottomInset == other.resizeToAvoidBottomInset &&
        primary == other.primary &&
        drawerDragStartBehavior == other.drawerDragStartBehavior &&
        drawerEdgeDragWidth == other.drawerEdgeDragWidth &&
        drawerEnableOpenDragGesture == other.drawerEnableOpenDragGesture &&
        endDrawerEnableOpenDragGesture ==
            other.endDrawerEnableOpenDragGesture &&
        restorationId == other.restorationId;
  }

  MD3ScaffoldProperties copyWith({
    FloatingActionButtonLocation? floatingActionButtonLocation,
    FloatingActionButtonAnimator? floatingActionButtonAnimator,
    Color? drawerScrimColor,
    bool? resizeToAvoidBottomInset,
    bool? primary,
    DragStartBehavior? drawerDragStartBehavior,
    double? drawerEdgeDragWidth,
    bool? drawerEnableOpenDragGesture,
    bool? endDrawerEnableOpenDragGesture,
    String? restorationId,
  }) =>
      MD3ScaffoldProperties(
        floatingActionButtonLocation:
            floatingActionButtonLocation ?? this.floatingActionButtonLocation,
        floatingActionButtonAnimator:
            floatingActionButtonAnimator ?? this.floatingActionButtonAnimator,
        drawerScrimColor: drawerScrimColor ?? this.drawerScrimColor,
        resizeToAvoidBottomInset:
            resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
        primary: primary ?? this.primary,
        drawerDragStartBehavior:
            drawerDragStartBehavior ?? this.drawerDragStartBehavior,
        drawerEdgeDragWidth: drawerEdgeDragWidth ?? this.drawerEdgeDragWidth,
        drawerEnableOpenDragGesture:
            drawerEnableOpenDragGesture ?? this.drawerEnableOpenDragGesture,
        endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture ??
            this.endDrawerEnableOpenDragGesture,
        restorationId: restorationId ?? this.restorationId,
      );

  /// Returns a copy of this MD3ScaffoldProperties where the non-null fields in [other]
  /// have replaced the corresponding null fields in this MD3ScaffoldProperties.
  ///
  /// In other words, [other] is used to fill in unspecified (null) fields
  /// this MD3ScaffoldProperties.
  MD3ScaffoldProperties merge(
    MD3ScaffoldProperties? other,
  ) {
    if (other == null) {
      return this;
    }
    return copyWith(
      floatingActionButtonLocation:
          floatingActionButtonLocation ?? other.floatingActionButtonLocation,
      floatingActionButtonAnimator:
          floatingActionButtonAnimator ?? other.floatingActionButtonAnimator,
      drawerScrimColor: drawerScrimColor ?? other.drawerScrimColor,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset ?? other.resizeToAvoidBottomInset,
      primary: primary ?? other.primary,
      drawerDragStartBehavior:
          drawerDragStartBehavior ?? other.drawerDragStartBehavior,
      drawerEdgeDragWidth: drawerEdgeDragWidth ?? other.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture:
          drawerEnableOpenDragGesture ?? other.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture ??
          other.endDrawerEnableOpenDragGesture,
      restorationId: restorationId ?? other.restorationId,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FloatingActionButtonLocation>(
        'floatingActionButtonLocation', floatingActionButtonLocation,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FloatingActionButtonAnimator>(
        'floatingActionButtonAnimator', floatingActionButtonAnimator,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>(
        'drawerScrimColor', drawerScrimColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'resizeToAvoidBottomInset', resizeToAvoidBottomInset,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('primary', primary, defaultValue: null));
    properties.add(DiagnosticsProperty<DragStartBehavior>(
        'drawerDragStartBehavior', drawerDragStartBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'drawerEdgeDragWidth', drawerEdgeDragWidth,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'drawerEnableOpenDragGesture', drawerEnableOpenDragGesture,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'endDrawerEnableOpenDragGesture', endDrawerEnableOpenDragGesture,
        defaultValue: null));
    properties.add(DiagnosticsProperty<String>('restorationId', restorationId,
        defaultValue: null));
  }
}
