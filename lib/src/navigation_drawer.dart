import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

class NavigationDrawerThemeData {
  final bool isStandardDrawer;
  final double headerBaseline;
  final EdgeInsetsGeometry itemPadding;
  final ShapeBorder itemShape;
  final Color itemSelectedColor;
  final Color itemUnselectedColor;
  final Color itemSelectedColorBackground;
  final double iconTitleSpacing;
  final double spacerHeight;

  const NavigationDrawerThemeData({
    this.isStandardDrawer,
    this.headerBaseline,
    this.itemPadding,
    this.itemShape,
    this.itemSelectedColor,
    this.itemUnselectedColor,
    this.itemSelectedColorBackground,
    this.iconTitleSpacing,
    this.spacerHeight,
  });
}

class NavigationDrawerTheme extends InheritedWidget {
  final NavigationDrawerThemeData data;

  NavigationDrawerTheme({this.data, Widget child}) : super(child: child);
  @override
  bool updateShouldNotify(NavigationDrawerTheme oldWidget) =>
      data != oldWidget.data;

  static NavigationDrawerThemeData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NavigationDrawerTheme>()
        ?.data;
  }
}

class NavigationDrawerHeader extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final TextStyle textStyle;
  final double baseline;
  final bool isStandardDrawer;

  const NavigationDrawerHeader({
    Key key,
    this.title,
    @Deprecated('Deprecated on MD3') this.subtitle,
    this.textStyle,
    this.isStandardDrawer,
    this.baseline,
  }) : super(key: key);

  static const double kStandardHeight = 64;
  static const double kModalHeight = 74;

  // top to text baseline
  static const double kStandardTitleOffset = 42;
  // top to text baseline
  static const double kModalTitleOffset = 36;

  // bottom to text baseline
  static const double kModalSubtitleOffset = 18;

  bool/*!*/ _getIsStandardDrawer(BuildContext context) {
    if (isStandardDrawer != null) {
      return isStandardDrawer;
    }
    const defaultVal = false;
    return NavigationDrawerTheme.of(context)?.isStandardDrawer ?? defaultVal;
  }

  double/*!*/ _getbaseline(BuildContext context) {
    if (baseline != null) {
      return baseline;
    }

    const defaultVal = 28.0;
    return NavigationDrawerTheme.of(context)?.headerBaseline ?? defaultVal;
  }

  Widget buildTitle(BuildContext context) {
    final offset = _getIsStandardDrawer(context)
        ? kStandardTitleOffset
        : kModalTitleOffset;
    final style = textStyle ?? context.textTheme.titleMedium;
    var widget = DefaultTextStyle(
      style: style.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
      child: title,
    );
    return widget;
  }

  Widget buildSubtitle(BuildContext context) {
    final offset = kModalSubtitleOffset;
    var widget = DefaultTextStyle(
        style: Theme.of(context).textTheme.caption, child: subtitle);
    return Positioned(
      child: widget,
      left: _getbaseline(context),
      bottom: offset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: _getbaseline(context)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: buildTitle(context),
        ),
      ),
    );
  }
}

class NavigationDrawerSpacer extends StatelessWidget {
  final double height;

  const NavigationDrawerSpacer({Key key, this.height}) : super(key: key);
  double/*!*/ _getHeight(BuildContext context) {
    if (height != null) {
      return height;
    }
    const defaultVal = 32.0;
    return NavigationDrawerTheme.of(context)?.spacerHeight ?? defaultVal;
  }

  @override
  Widget build(BuildContext context) => Divider(
        height: _getHeight(context),
        thickness: 1,
        indent: 28,
        endIndent: 28,
        color: context.colorScheme.outline,
      );
}

class NavigationDrawerGroupHeader extends StatelessWidget {
  final Widget subtitle;
  final double baseline;

  const NavigationDrawerGroupHeader({
    Key key,
    this.subtitle,
    this.baseline,
  }) : super(key: key);
  static const double kHeight = 36;
  // top to text baseline
  static const double kTitleOffset = 28;

  @override
  Widget build(BuildContext context) => NavigationDrawerHeader(
        textStyle: context.textTheme.titleSmall,
        title: subtitle,
        baseline: baseline,
      );
}

class NavigationDrawerItem extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final bool selected;
  final EdgeInsets padding;
  final VoidCallback onTap;
  final ShapeBorder shape;
  final Color selectedColor;
  final Color selectedContentColor;
  final double iconTitleSpacing;

  const NavigationDrawerItem(
      {Key key,
      this.title,
      this.icon,
      this.selected = false,
      this.padding,
      this.onTap,
      this.shape,
      this.selectedColor,
      this.selectedContentColor,
      this.iconTitleSpacing})
      : super(key: key);

  final double kHeight = 56.0;
  bool get isDisabled => onTap == null;

  Color/*!*/ _getSelectedColorBackground(BuildContext context) {
    if (selectedColor != null) {
      return selectedColor;
    }
    final inherited =
        NavigationDrawerTheme.of(context)?.itemSelectedColorBackground;
    if (inherited != null) {
      return inherited;
    }
    final colorScheme = context.colorScheme;
    final defaultVal = colorScheme.secondaryContainer;
    return defaultVal;
  }

  Color/*!*/ _getSelectedForegroundColor(BuildContext context) {
    if (selectedContentColor != null) {
      return selectedContentColor;
    }
    final inherited = NavigationDrawerTheme.of(context)?.itemSelectedColor;
    if (inherited != null) {
      return inherited;
    }
    final defaultVal = context.colorScheme.onSecondaryContainer;
    return defaultVal;
  }

  Color _getDisabledBackground(BuildContext context) {
    return context.colorScheme.onSecondaryContainer.withOpacity(0.24);
  }

  Color/*!*/ _getUnselectedForegroundColor(BuildContext context) {
    if (selectedContentColor != null) {
      return selectedContentColor;
    }
    final inherited = NavigationDrawerTheme.of(context)?.itemUnselectedColor;
    if (inherited != null) {
      return inherited;
    }
    final defaultVal = context.colorScheme.onSurfaceVariant;
    return defaultVal;
  }

  double/*!*/ _getIconTitleSpacing(BuildContext context) {
    if (iconTitleSpacing != null) {
      return iconTitleSpacing;
    }
    const defaultVal = 12.0;
    return NavigationDrawerTheme.of(context)?.iconTitleSpacing ?? defaultVal;
  }

  double _getRightSpacing(BuildContext context) => 4;
  double _getLeftSpacing(BuildContext context) {
    final padding = _getPadding(context);
    final baseline = NavigationDrawerTheme.of(context)?.headerBaseline ?? 28.0;
    return baseline - padding.left;
  }

  EdgeInsets/*!*/ _getPadding(BuildContext context) {
    if (padding != null) {
      return padding;
    }
    const defaultVal = EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0);
    return NavigationDrawerTheme.of(context)
            ?.itemPadding
            ?.resolve(Directionality.of(context)) ??
        defaultVal;
  }

  ShapeBorder/*!*/ _getShape(BuildContext context) {
    if (shape != null) {
      return shape;
    }
    if (isDisabled) {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
    }
    const defaultVal = StadiumBorder();
    return NavigationDrawerTheme.of(context)?.itemShape ?? defaultVal;
  }

  Widget _buildIcon(BuildContext context) {
    var icon = this.icon;
    icon = IconTheme(
      data: IconTheme.of(context).copyWith(
        color: selected
            ? _getSelectedForegroundColor(context)
            : _getUnselectedForegroundColor(context),
      ),
      child: icon,
    );
    return icon;
  }

  Widget _buildLabel(BuildContext context) {
    return DefaultTextStyle(
      style: context.textTheme.labelLarge.copyWith(
        color: selected
            ? _getSelectedForegroundColor(context)
            : _getUnselectedForegroundColor(context),
      ),
      child: title,
    );
  }

  Widget buildInner(BuildContext context) {
    final shape = _getShape(context);
    return Material(
      color: selected
          ? _getSelectedColorBackground(context)
          : isDisabled
              ? _getDisabledBackground(context)
              : Colors.transparent,
      shape: shape,
      child: InkWell(
        customBorder: shape,
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: _getLeftSpacing(context),
            ),
            if (icon != null) ...[
              _buildIcon(context),
              SizedBox(
                width: _getIconTitleSpacing(context),
              ),
            ],
            if (title != null)
              Align(
                alignment: Alignment.centerLeft,
                child: _buildLabel(context),
              ),
            SizedBox(
              width: _getRightSpacing(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kHeight,
      width: double.infinity,
      child: Padding(
        padding: _getPadding(context),
        child: buildInner(context),
      ),
    );
  }
}
