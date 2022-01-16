import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';
import 'md3_appBar/controller.dart';
import 'md3_chips/utils.dart';

typedef MD3NavigationDrawerItem = NavigationDrawerItem;
typedef MD3NavigationDrawerDivider = NavigationDrawerSpacer;
typedef MD3NavigationDrawerTitle = NavigationDrawerHeader;
typedef MD3NavigationDrawerSectionTitle = NavigationDrawerGroupHeader;

const double _kModalDrawerWidth = 256.0;
const double _kStandardDrawerWidth = 360.0;
const double _kDrawerItemHeight = 56.0;
const double _kHorizontalPadding = 28.0;
const double _kDrawerHorizontalPadding = 12.0;
const double _kRemainingHorizontalPadding =
    _kHorizontalPadding - _kDrawerHorizontalPadding;

// TODO: add theming back to new impls
class NavigationDrawerThemeData {
  const NavigationDrawerThemeData({
    @deprecated bool? isStandardDrawer,
    @deprecated double? headerBaseline,
    @deprecated @deprecated EdgeInsetsGeometry? itemPadding,
    this.itemShape,
    this.itemSelectedColor,
    this.itemUnselectedColor,
    this.itemSelectedColorBackground,
    @deprecated double? iconTitleSpacing,
    @deprecated double? spacerHeight,
  });
  final OutlinedBorder? itemShape;
  final Color? itemSelectedColor;
  final Color? itemUnselectedColor;
  final Color? itemSelectedColorBackground;
}

class NavigationDrawerTheme extends InheritedWidget {
  const NavigationDrawerTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final NavigationDrawerThemeData data;

  @override
  bool updateShouldNotify(NavigationDrawerTheme oldWidget) =>
      data != oldWidget.data;

  static NavigationDrawerThemeData? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NavigationDrawerTheme>()
        ?.data;
  }
}

class NavigationDrawerHeader extends StatelessWidget {
  const NavigationDrawerHeader({
    Key? key,
    Widget? title,
    @Deprecated('Deprecated on MD3') Widget? subtitle,
    this.textStyle,
    @deprecated bool? isStandardDrawer,
    @deprecated double? baseline,
    Widget? child,
  })  : child = title ?? child,
        super(key: key);

  final TextStyle? textStyle;

  final Widget? child;

  Widget buildTitle(BuildContext context) {
    final style = textStyle ?? context.textTheme.titleMedium;
    final widget = DefaultTextStyle(
      style: style.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
      child: child!,
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kDrawerItemHeight,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kRemainingHorizontalPadding,
        ),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: buildTitle(context),
        ),
      ),
    );
  }
}

class NavigationDrawerSpacer extends StatelessWidget {
  const NavigationDrawerSpacer({Key? key, this.height}) : super(key: key);

  final double? height;

  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        thickness: 1,
        indent: _kRemainingHorizontalPadding,
        endIndent: _kRemainingHorizontalPadding,
        color: context.colorScheme.outline,
      );
}

class NavigationDrawerGroupHeader extends StatelessWidget {
  const NavigationDrawerGroupHeader({
    Key? key,
    this.textStyle,
    @Deprecated('Use child') Widget? subtitle,
    @deprecated double? baseline,
    Widget? child,
  })  : child = child ?? subtitle,
        super(key: key);

  final TextStyle? textStyle;
  final Widget? child;

  @override
  Widget build(BuildContext context) => NavigationDrawerHeader(
        textStyle: textStyle ??
            context.textTheme.titleSmall.copyWith(fontWeight: FontWeight.bold),
        title: child,
      );
}

class _NavigationDrawerItemChild extends StatelessWidget {
  const _NavigationDrawerItemChild({
    Key? key,
    this.leading,
    required this.child,
  }) : super(key: key);
  final Widget? leading;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final width = constraints.maxWidth;
          const kTrailingPadding = 8;
          const kBetweenPadding = 12;
          const paddings = kTrailingPadding + kBetweenPadding;
          const minWidth = 56;
          final paddingT = ((width - minWidth) / paddings).clamp(0.0, 1.0);
          return Padding(
            padding: EdgeInsets.fromLTRB(
              leading == null ? 24 : 16,
              16,
              // TODO: according to the spec, it should be 24, but when shrinking it
              // clashes with the leading icon and overflows
              leading == null ? 24 : 16 + kTrailingPadding * paddingT,
              16,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(
                    width: kBetweenPadding * paddingT,
                  )
                ],
                Expanded(child: child),
              ],
            ),
          );
        },
      );
}

class NavigationDrawerItem extends StatelessWidget {
  const NavigationDrawerItem({
    Key? key,
    required this.title,
    this.icon,
    this.selected = false,
    this.padding,
    this.onTap,
    this.shape,
    @deprecated this.selectedColor,
    @deprecated this.selectedContentColor,
    this.backgroundColor,
    this.foregroundColor,
    @deprecated this.iconTitleSpacing,
    this.overlayColor,
    this.trailing,
  }) : super(key: key);

  final Widget title;
  final Widget? icon;
  final Widget? trailing;
  final bool selected;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  /// Can be an [MaterialStateOutlinedBorder]!!
  final OutlinedBorder? shape;
  @deprecated
  final Color? selectedColor;
  @deprecated
  final Color? selectedContentColor;
  final MaterialStateProperty<Color>? backgroundColor;
  final MaterialStateProperty<Color>? foregroundColor;
  final MaterialStateProperty<Color>? overlayColor;
  @deprecated
  final double? iconTitleSpacing;

  bool get isDisabled => onTap == null;

  MaterialStateProperty<OutlinedBorder> _defaultShape(
          MonetColorScheme colorScheme) =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0));
        }
        return StadiumBorder();
      });

  MaterialStateProperty<Color> _defaultBackgroundColor(
          MonetColorScheme colorScheme) =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          // TODO: makes no sense. this is the color according to the figma design package. check it later.
          return colorScheme.onSurface.withOpacity(0.24);
        }
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primaryContainer;
        }
        return Colors.transparent;
      });

  MaterialStateProperty<Color> _defaultForegroundColor(
    MonetColorScheme colorScheme,
  ) =>
      MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          // TODO: makes no sense. this is the color according to the figma design package. check it later.
          return colorScheme.onSecondaryContainer;
        }
        if (states.contains(MaterialState.selected)) {
          return colorScheme.onPrimaryContainer;
        }
        return colorScheme.onSurface;
      });

  MaterialStateProperty<Color> _defaultOverlayColor(
    Color color,
    MD3StateLayerOpacityTheme stateLayerOpacityTheme,
  ) =>
      MD3StateOverlayColor(
        color,
        stateLayerOpacityTheme,
      );

  MaterialStateProperty<Color?> _widgetBackgroundColor() =>
      backgroundColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return selectedColor;
        }
        return null;
      });
  MaterialStateProperty<Color?> _widgetForegroundColor() =>
      foregroundColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return selectedContentColor;
        }
        return null;
      });

  MaterialStateProperty<Color?> _inheritedBackgroundColor(
    NavigationDrawerThemeData? data,
  ) =>
      data == null
          ? MaterialStateProperty.all(null)
          : MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return data.itemSelectedColorBackground;
              }
              return null;
            });

  MaterialStateProperty<Color?> _inheritedForegroundColor(
    NavigationDrawerThemeData? data,
  ) =>
      data == null
          ? MaterialStateProperty.all(null)
          : MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return data.itemSelectedColor;
              }
              return data.itemUnselectedColor;
            });

  // TODO: add to theme data
  MaterialStateProperty<Color>? _inheritedOverlayColor(
    NavigationDrawerThemeData? data,
  ) =>
      null;

  MaterialStateProperty<OutlinedBorder?> _inheritedShape(
    NavigationDrawerThemeData? data,
  ) =>
      MaterialStateProperty.all(data?.itemShape);

  @override
  Widget build(BuildContext context) {
    final states = {
      if (isDisabled) MaterialState.disabled,
      if (selected) MaterialState.selected,
    };
    final scheme = context.colorScheme;
    final themeData = NavigationDrawerTheme.of(context);
    final defaultBackground = _defaultBackgroundColor(scheme);
    final defaultForeground = _defaultForegroundColor(scheme);
    final defaultShape = _defaultShape(scheme);
    final widgetBackground = _widgetBackgroundColor();
    final widgetForeground = _widgetForegroundColor();
    final widgetShape = MaterialStateProperty.resolveWith(
        (states) => MaterialStateProperty.resolveAs(shape, states));
    final widgetOverlay = this.overlayColor;
    final inheritedBackground = _inheritedBackgroundColor(themeData);
    final inheritedForeground = _inheritedForegroundColor(themeData);
    final inheritedShape = _inheritedShape(themeData);
    final inheritedOverlay = _inheritedOverlayColor(themeData);

    T resolve<T>(
      MaterialStateProperty<T> def,
      MaterialStateProperty<T?> widget,
      MaterialStateProperty<T?> inherited,
    ) =>
        widget.resolve(states) ??
        inherited.resolve(states) ??
        def.resolve(states);
    final resolvedBackground =
        resolve(defaultBackground, widgetBackground, inheritedBackground);
    final resolvedForeground =
        resolve(defaultForeground, widgetForeground, inheritedForeground);
    final resolvedShape = resolve(defaultShape, widgetShape, inheritedShape);

    final defaultOverlay =
        _defaultOverlayColor(resolvedForeground, context.stateOverlayOpacity);
    final overlayColor = widgetOverlay ?? inheritedOverlay ?? defaultOverlay;

    return SizedBox(
      height: _kDrawerItemHeight,
      width: double.infinity,
      child: IconTheme.merge(
        data: IconThemeData(
          color: resolvedForeground,
          opacity: 1.0,
        ),
        child: Material(
          color: resolvedBackground,
          textStyle: context.textTheme.labelLarge.copyWith(
            color: resolvedForeground,
          ),
          shape: resolvedShape,
          child: InkWell(
            overlayColor: overlayColor,
            onTap: onTap,
            customBorder: resolvedShape,
            canRequestFocus: !isDisabled,
            child: _NavigationDrawerItemChild(
              leading: icon,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: title),
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing!,
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MD3NavigationDrawer extends StatelessWidget {
  const MD3NavigationDrawer({
    Key? key,
    this.radius = const Radius.circular(16),
    this.padding =
        const EdgeInsets.symmetric(horizontal: _kDrawerHorizontalPadding),
    this.child,
    this.backgroundColor,
  }) : super(key: key);
  final Radius radius;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Widget? child;

  Color _defaultColor(
    BuildContext context,
    MD3ElevationLevel elevationLevel,
  ) =>
      elevationLevel.overlaidColor(
        context.colorScheme.surface,
        MD3ElevationLevel.surfaceTint(
          context.colorScheme,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final scope = MD3DrawerScope.of(context);
    final elevationLevel =
        scope.isModal ? context.elevation.level1 : context.elevation.level0;

    final width = scope.isModal ? _kModalDrawerWidth : _kStandardDrawerWidth;
    final effectiveColor =
        backgroundColor ?? _defaultColor(context, elevationLevel);

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.horizontal(
        start: scope.isEnd == true ? radius : Radius.zero,
        end: scope.isEnd == false ? radius : Radius.zero,
      ),
    );

    return Drawer(
      backgroundColor: effectiveColor,
      elevation: elevationLevel.value,
      shape: shape,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class MD3DrawerScope extends InheritedWidget {
  const MD3DrawerScope({
    Key? key,
    required this.isModal,
    required this.isEnd,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );
  final bool isModal;
  final bool? isEnd;

  static MD3DrawerScope of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MD3DrawerScope>()!;

  @override
  bool updateShouldNotify(MD3DrawerScope oldWidget) =>
      isModal != oldWidget.isModal || isEnd != oldWidget.isModal;
}
