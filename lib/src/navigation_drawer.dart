import 'package:flutter/material.dart';

class NavigationDrawerThemeData {
  final bool isStandardDrawer;
  final double headerBaseline;
  final EdgeInsetsGeometry itemPadding;
  final ShapeBorder itemShape;
  final Color itemSelectedColor;
  final Color itemSelectedColorBackground;
  final double iconTitleSpacing;
  final double spacerHeight;

  const NavigationDrawerThemeData(
      {this.isStandardDrawer,
      this.headerBaseline,
      this.itemPadding,
      this.itemShape,
      this.itemSelectedColor,
      this.itemSelectedColorBackground,
      this.iconTitleSpacing,
      this.spacerHeight});
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
  final double baseline;
  final bool isStandardDrawer;

  const NavigationDrawerHeader(
      {Key key,
      this.title,
      this.subtitle,
      this.isStandardDrawer,
      this.baseline})
      : super(key: key);

  static const double kStandardHeight = 64;
  static const double kModalHeight = 74;

  // top to text baseline
  static const double kStandardTitleOffset = 42;
  // top to text baseline
  static const double kModalTitleOffset = 36;

  // bottom to text baseline
  static const double kModalSubtitleOffset = 18;

  double _getHeight(BuildContext context) =>
      _getIsStandardDrawer(context) ? kStandardHeight : kModalHeight;

  bool _getIsStandardDrawer(BuildContext context) {
    if (isStandardDrawer != null) {
      return isStandardDrawer;
    }
    const defaultVal = false;
    return NavigationDrawerTheme.of(context)?.isStandardDrawer ?? defaultVal;
  }

  double _getbaseline(BuildContext context) {
    if (baseline != null) {
      return baseline;
    }

    const defaultVal = 16.0;
    return NavigationDrawerTheme.of(context)?.headerBaseline ?? defaultVal;
  }

  Widget buildTitle(BuildContext context) {
    final offset = _getIsStandardDrawer(context)
        ? kStandardTitleOffset
        : kModalTitleOffset;
    var widget = DefaultTextStyle(
        style: Theme.of(context).textTheme.headline6, child: title);
    return Positioned(
      child: widget,
      left: _getbaseline(context),
      bottom: _getHeight(context) - offset,
    );
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
      height: _getHeight(context),
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (subtitle != null && !_getIsStandardDrawer(context))
            buildSubtitle(context),
          if (title != null) buildTitle(context)
        ],
      ),
    );
  }
}

class NavigationDrawerSpacer extends StatelessWidget {
  final double height;

  const NavigationDrawerSpacer({Key key, this.height}) : super(key: key);
  double _getHeight(BuildContext context) {
    if (height != null) {
      return height;
    }
    const defaultVal = 8.0;
    return NavigationDrawerTheme.of(context)?.spacerHeight ?? defaultVal;
  }

  @override
  Widget build(BuildContext context) => SizedBox(height: _getHeight(context));
}

class NavigationDrawerGroupHeader extends StatelessWidget {
  final Widget subtitle;
  final double baseline;

  const NavigationDrawerGroupHeader({Key key, this.subtitle, this.baseline})
      : super(key: key);
  static const double kHeight = 36;
  // top to text baseline
  static const double kTitleOffset = 28;

  double _getbaseline(BuildContext context) {
    if (baseline != null) {
      return baseline;
    }

    const defaultVal = 16.0;
    return NavigationDrawerTheme.of(context)?.headerBaseline ?? defaultVal;
  }

  Widget _buildSubtitle(BuildContext context) {
    final style = Theme.of(context).textTheme.caption;
    final textHeight = style.fontSize * (style.height ?? 1.0);
    final offset = kTitleOffset - textHeight;
    var widget = DefaultTextStyle(style: style, child: subtitle);
    return Positioned(
      child: widget,
      left: _getbaseline(context),
      top: offset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [if (subtitle != null) _buildSubtitle(context)],
      ),
    );
  }
}

class NavigationDrawerItem extends StatelessWidget {
  final Widget title;
  final Widget icon;
  final bool selected;
  final EdgeInsetsGeometry padding;
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

  final double kHeight = 48.0;

  Color _getSelectedColorBackground(BuildContext context) {
    if (selectedColor != null) {
      return selectedColor;
    }
    final inherited =
        NavigationDrawerTheme.of(context)?.itemSelectedColorBackground;
    if (inherited != null) {
      return inherited;
    }
    final colorScheme = Theme.of(context).colorScheme;
    final defaultVal = Color.alphaBlend(
        colorScheme.primary.withAlpha(70), colorScheme.surface);
    return defaultVal;
  }

  Color _getSelectedColor(BuildContext context) {
    if (selectedContentColor != null) {
      return selectedContentColor;
    }
    final inherited = NavigationDrawerTheme.of(context)?.itemSelectedColor;
    if (inherited != null) {
      return inherited;
    }
    final defaultVal = Theme.of(context).colorScheme.primary;
    return defaultVal;
  }

  double _getIconTitleSpacing(BuildContext context) {
    if (iconTitleSpacing != null) {
      return iconTitleSpacing;
    }
    const defaultVal = 24.0;
    return NavigationDrawerTheme.of(context)?.iconTitleSpacing ?? defaultVal;
  }

  double _getLeftSpacing(BuildContext context) {
    final padding = _getPadding(context);
    final baseline = NavigationDrawerTheme.of(context)?.headerBaseline ?? 16.0;
    return baseline - padding.left;
  }

  EdgeInsets _getPadding(BuildContext context) {
    if (padding != null) {
      return padding;
    }
    const defaultVal = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
    return NavigationDrawerTheme.of(context)?.itemPadding ?? defaultVal;
  }

  ShapeBorder _getShape(BuildContext context) {
    if (shape != null) {
      return shape;
    }
    const defaultVal = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    );
    return NavigationDrawerTheme.of(context)?.itemShape ?? defaultVal;
  }

  Widget _buildIcon(BuildContext context) {
    var icon = this.icon;
    if (selected) {
      icon = IconTheme(
          data:
              IconTheme.of(context).copyWith(color: _getSelectedColor(context)),
          child: icon);
    }
    return icon;
  }

  Widget _buildLabel(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: selected ? _getSelectedColor(context) : null),
        child: title);
  }

  Widget buildInner(BuildContext context) {
    return Material(
      color: selected ? _getSelectedColorBackground(context) : null,
      shape: _getShape(context),
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
                  alignment: Alignment.centerLeft, child: _buildLabel(context)),
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
        ));
  }
}
