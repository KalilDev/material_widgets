// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

import '../../material_widgets.dart';

@Deprecated('Use MD3ResponsiveAppBarAction')
abstract class ResponsiveAppbarAction {
  @Deprecated('Use MD3ResponsiveAppBarAction')
  factory ResponsiveAppbarAction({
    Widget icon,
    String tooltip,
    Widget title,
    VoidCallback onPressed,
  }) = MD3ResponsiveAppBarAction;
}

class MD3ResponsiveAppBarAction implements ResponsiveAppbarAction {
  const MD3ResponsiveAppBarAction({
    this.icon,
    this.tooltip,
    this.title,
    this.onPressed,
  });
  final Widget? icon;
  final String? tooltip;
  final Widget? title;
  final VoidCallback? onPressed;
}

enum _MD3AppBarType {
  center,
  small,
  medium,
  large,
  mediumOrLarge,
}

extension on _MD3AppBarType {
  double get height {
    switch (this) {
      case _MD3AppBarType.center:
        return MD3CenterAlignedAppBar.kHeight;
      case _MD3AppBarType.small:
        return MD3SmallAppBar.kHeight;
      case _MD3AppBarType.medium:
        return MD3MediumAppBar.kHeight;
      case _MD3AppBarType.large:
        return MD3LargeAppBar.kHeight;
      case _MD3AppBarType.mediumOrLarge:
        return MD3LargeOrMediumAppBar.kHeight;
    }
  }
}

class ResponsiveAppbar extends StatelessWidget implements PreferredSizeWidget {
  @Deprecated('Use one of the named ResponsiveAppbar constructors')
  ResponsiveAppbar({
    Key? key,
    @Deprecated('Depends on the app bar type') double? toolbarHeight,
    this.title,
    this.leading,
    @Deprecated('use buildActions') List<ResponsiveAppbarAction>? actions,
    List<ResponsiveAppbarAction> Function(BuildContext)? buildActions,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
    this.bottom,
  })  : _appBarType = _MD3AppBarType.small,
        buildActions = actions == null ? buildActions : ((_) => actions),
        super(key: key);

  const ResponsiveAppbar.center({
    Key? key,
    this.title,
    this.leading,
    this.buildActions,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
    this.bottom,
  })  : _appBarType = _MD3AppBarType.center,
        super(key: key);

  const ResponsiveAppbar.small({
    Key? key,
    this.title,
    this.leading,
    this.buildActions,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
    this.bottom,
  })  : _appBarType = _MD3AppBarType.small,
        super(key: key);

  const ResponsiveAppbar.medium({
    Key? key,
    this.title,
    this.leading,
    this.buildActions,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
    this.bottom,
  })  : _appBarType = _MD3AppBarType.medium,
        super(key: key);

  const ResponsiveAppbar.large({
    Key? key,
    this.title,
    this.leading,
    this.buildActions,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
    this.bottom,
  })  : _appBarType = _MD3AppBarType.large,
        super(key: key);

  const ResponsiveAppbar.mediumOrLarge({
    Key? key,
    this.title,
    this.leading,
    this.buildActions,
    this.primary = true,
    this.notifySize = true,
    this.isElevated,
    this.bottom,
  })  : _appBarType = _MD3AppBarType.mediumOrLarge,
        super(key: key);

  final Widget? title;
  final Widget? leading;
  final List<ResponsiveAppbarAction> Function(BuildContext)? buildActions;
  final _MD3AppBarType _appBarType;
  final bool primary;
  final bool notifySize;
  final bool? isElevated;
  final PreferredSizeWidget? bottom;
  @override
  Size get preferredSize => Size.fromHeight(
      _appBarType.height + (bottom?.preferredSize.height ?? 0.0));

  Widget _actionToActionWidget(MD3ResponsiveAppBarAction? action) {
    return IconButton(
      icon: action!.icon!,
      onPressed: action.onPressed,
      tooltip: action.tooltip,
    );
  }

  MD3PopupMenuItem<MD3ResponsiveAppBarAction> _actionToPopupMenuItem(
    BuildContext context,
    MD3ResponsiveAppBarAction action,
  ) {
    return MD3PopupMenuItem(
      value: action,
      child: action.title!,
    );
  }

  WidgetBuilder _moreButtonBuilder(List<MD3ResponsiveAppBarAction?> hidden) =>
      (context) {
        void open() {
          final items = hidden.map((e) => _actionToPopupMenuItem(context, e!));
          final button = context.findRenderObject()! as RenderBox;
          final overlay =
              Overlay.of(context)!.context.findRenderObject()! as RenderBox;
          final position = RelativeRect.fromRect(
            Rect.fromPoints(
              button.localToGlobal(Offset.zero, ancestor: overlay),
              button.localToGlobal(
                button.size.bottomRight(Offset.zero),
                ancestor: overlay,
              ),
            ),
            Offset.zero & overlay.size,
          );
          showMD3Menu<MD3ResponsiveAppBarAction>(
            context: context,
            items: items.toList(),
            position: position,
          ).then((e) => e?.onPressed?.call());
        }

        return IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: open,
          tooltip: 'more',
        );
      };

  List<Widget>? _buildActions(BuildContext context) {
    final builtActions = buildActions?.call(context) ?? [];
    if (builtActions.isEmpty) {
      return null;
    }
    // https://m3.material.io/components/top-app-bar/guidelines
    //
    // And quote: "Up to three interactive icons can be placed after the
    // headline, at the trailing end of the container."
    var limit = 3;
    if (_appBarType == _MD3AppBarType.center) {
      // MD3CenterAppBar supports only a single icon
      limit = 1;
    }
    final concreteActions = builtActions.map((e) {
      if (e is MD3ResponsiveAppBarAction) {
        return e;
      }
    }).where((e) => e != null);
    List<Widget> actions;
    if (concreteActions.length > limit) {
      final shown = concreteActions.take(limit - 1);
      final hidden = concreteActions.skip(limit - 1).toList();
      final moreButton = Builder(builder: _moreButtonBuilder(hidden));
      actions = [...shown.map(_actionToActionWidget), moreButton];
    } else {
      actions = concreteActions.map(_actionToActionWidget).toList();
    }
    return actions;
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    final actionWidgets = _buildActions(context);
    switch (_appBarType) {
      case _MD3AppBarType.center:
        if ((actionWidgets?.length ?? 0) > 1) {
          throw StateError('Invalid action count for center appbar');
        }
        return MD3CenterAlignedAppBar(
          leading: leading,
          title: title,
          trailing:
              (actionWidgets?.isEmpty ?? true) ? null : actionWidgets!.single,
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
          bottom: bottom,
        );
      case _MD3AppBarType.small:
        return MD3SmallAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
          bottom: bottom,
        );
      case _MD3AppBarType.medium:
        return MD3MediumAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
          bottom: bottom,
        );
      case _MD3AppBarType.large:
        return MD3LargeAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
          bottom: bottom,
        );
      case _MD3AppBarType.mediumOrLarge:
        return MD3LargeOrMediumAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
          primary: primary,
          notifySize: notifySize,
          isElevated: isElevated,
          bottom: bottom,
        );
    }
  }
}
