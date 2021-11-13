import 'package:flutter/material.dart';
import 'package:material_widgets/src/md3_appBar/raw_appBar.dart';

import '../material_widgets.dart';
import 'deprecated/material_breakpoint.dart';
import 'deprecated/material_layout.dart';
import 'deprecated/material_layout_data.dart';

int _getButtonCountForBreakpoint(MaterialBreakpoint bp) {
  final entries = MaterialBreakpoint.values.asMap().entries;
  final bpAndIndex =
      entries.singleWhere((bpAndIndex) => bp == bpAndIndex.value);
  return bpAndIndex.key + 1;
}

@Deprecated('Use MD3ResponsiveAppBarAction')
abstract class ResponsiveAppbarAction {
  @Deprecated('Use MD3ResponsiveAppBarAction')
  factory ResponsiveAppbarAction(
      {Widget icon,
      String tooltip,
      Widget title,
      VoidCallback onPressed}) = MD3ResponsiveAppBarAction;
  @Deprecated('Use MD3ResponsiveAppBarAction')
  static MD3ResponsiveAppBarAction create(
          {Widget icon,
          String tooltip,
          Widget title,
          VoidCallback onPressed}) =>
      MD3ResponsiveAppBarAction(
        icon: icon,
        tooltip: tooltip,
        title: title,
        onPressed: onPressed,
      );
  @Deprecated(
      'Use ResponsiveAppbar.buildActions with MD3ResponsiveAppBarAction')
  static _ResponsiveAppBarActionBuilder builder(
          MD3ResponsiveAppBarAction Function(BuildContext) build) =>
      _ResponsiveAppBarActionBuilder(build);
}

class MD3ResponsiveAppBarAction implements ResponsiveAppbarAction {
  final Widget icon;
  final String tooltip;
  final Widget title;
  final VoidCallback onPressed;

  const MD3ResponsiveAppBarAction({
    this.icon,
    this.tooltip,
    this.title,
    this.onPressed,
  });
}

class _ResponsiveAppBarActionBuilder implements ResponsiveAppbarAction {
  final MD3ResponsiveAppBarAction Function(BuildContext) build;

  const _ResponsiveAppBarActionBuilder(this.build);
}

enum _MD3AppBarType {
  center,
  small,
  medium,
  large,
  mediumOrLarge,
}

class ResponsiveAppbar extends StatelessWidget implements PreferredSizeWidget {
  @Deprecated('Use one of the named ResponsiveAppbar constructors')
  ResponsiveAppbar({
    Key key,
    @Deprecated('Removed on MD3') PreferredSizeWidget bottom,
    @Deprecated('Depends on the app bar type') double toolbarHeight,
    this.title,
    this.leading,
    @Deprecated('use buildActions') List<ResponsiveAppbarAction> actions,
    List<ResponsiveAppbarAction> Function(BuildContext) buildActions,
  })  : _appBarType = _MD3AppBarType.small,
        preferredSize = const Size.fromHeight(MD3SmallAppBar.kHeight),
        buildActions = actions == null ? buildActions : ((_) => actions),
        super(key: key);

  const ResponsiveAppbar.center({
    Key key,
    this.title,
    this.leading,
    this.buildActions,
  })  : _appBarType = _MD3AppBarType.center,
        preferredSize = const Size.fromHeight(MD3SmallAppBar.kHeight),
        super(key: key);

  const ResponsiveAppbar.small({
    Key key,
    this.title,
    this.leading,
    this.buildActions,
  })  : _appBarType = _MD3AppBarType.small,
        preferredSize = const Size.fromHeight(MD3SmallAppBar.kHeight),
        super(key: key);

  const ResponsiveAppbar.medium({
    Key key,
    this.title,
    this.leading,
    this.buildActions,
  })  : _appBarType = _MD3AppBarType.medium,
        preferredSize = const Size.fromHeight(MD3MediumAppBar.kHeight),
        super(key: key);

  const ResponsiveAppbar.large({
    Key key,
    this.title,
    this.leading,
    this.buildActions,
  })  : _appBarType = _MD3AppBarType.large,
        preferredSize = const Size.fromHeight(MD3LargeAppBar.kHeight),
        super(key: key);

  const ResponsiveAppbar.mediumOrLarge({
    Key key,
    this.title,
    this.leading,
    this.buildActions,
  })  : _appBarType = _MD3AppBarType.mediumOrLarge,
        preferredSize = const Size.fromHeight(MD3LargeOrMediumAppBar.kHeight),
        super(key: key);

  final Widget title;
  final Widget leading;
  final List<ResponsiveAppbarAction> Function(BuildContext) buildActions;
  final _MD3AppBarType _appBarType;
  @override
  final Size preferredSize;

  Widget _actionToActionWidget(MD3ResponsiveAppBarAction action) {
    return IconButton(
      icon: action.icon,
      onPressed: action.onPressed,
      tooltip: action.tooltip,
    );
  }

  Widget _actionToBottomSheetWidget(MD3ResponsiveAppBarAction action) {
    return ListTile(
      leading: action.icon,
      onTap: action.onPressed,
      title: action.title,
    );
  }

  PopupMenuItem<MD3ResponsiveAppBarAction> _actionToPopupMenuItem(
      MD3ResponsiveAppBarAction action) {
    return PopupMenuItem(child: action.title, value: action);
  }

  WidgetBuilder _moreButtonBuilder(
          List<MD3ResponsiveAppBarAction> hidden, bool isBottomSheet) =>
      (context) {
        void open() {
          if (isBottomSheet) {
            final widgets = hidden.map(_actionToBottomSheetWidget);
            showModalBottomSheet<void>(
                context: context,
                builder: (context) {
                  return ListView(children: widgets.toList());
                });
            return;
          }
          final items = hidden.map(_actionToPopupMenuItem);
          final button = context.findRenderObject() as RenderBox;
          final overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          final position = RelativeRect.fromRect(
            Rect.fromPoints(
              button.localToGlobal(Offset.zero, ancestor: overlay),
              button.localToGlobal(button.size.bottomRight(Offset.zero),
                  ancestor: overlay),
            ),
            Offset.zero & overlay.size,
          );
          showMenu<MD3ResponsiveAppBarAction>(
            context: context,
            items: items.toList(),
            position: position,
          ).then((e) => e?.onPressed?.call());
        }

        return IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: open,
          tooltip: "more",
        );
      };

  List<Widget> _buildActions(BuildContext context, MaterialLayoutData data) {
    final builtActions = this.buildActions?.call(context) ?? [];
    if (builtActions == null || builtActions.isEmpty) {
      return null;
    }
    var limit = _getButtonCountForBreakpoint(data.breakpoint);
    if (_appBarType == _MD3AppBarType.center) {
      // MD3CenterAppBar supports only a single icon
      limit = 1;
    }
    final concreteActions = builtActions.map((e) {
      if (e is MD3ResponsiveAppBarAction) {
        return e;
      }
      if (e is _ResponsiveAppBarActionBuilder) {
        return e.build(context);
      }
      return null;
    }).where((e) => e != null);
    List<Widget> actions;
    if (concreteActions.length > limit) {
      final shown = concreteActions.take(limit - 1);
      final hidden = concreteActions.skip(limit - 1).toList();
      final moreButton = Builder(
          builder: _moreButtonBuilder(
              hidden, data.breakpoint == MaterialBreakpoint.one));
      actions = [...shown.map(_actionToActionWidget), moreButton];
    } else {
      actions = concreteActions.map(_actionToActionWidget).toList();
    }
    return actions;
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    final layout = MaterialLayout.of(context);
    final actionWidgets = _buildActions(context, layout);
    switch (_appBarType) {
      case _MD3AppBarType.center:
        if (actionWidgets.length > 1) {
          throw StateError('Invalid action count for center appbar');
        }
        return MD3CenterAlignedAppBar(
          leading: leading,
          title: title,
          trailing: actionWidgets.isEmpty ? null : actionWidgets.single,
        );
      case _MD3AppBarType.small:
        return MD3SmallAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
        );
      case _MD3AppBarType.medium:
        return MD3MediumAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
        );
      case _MD3AppBarType.large:
        return MD3LargeAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
        );
      case _MD3AppBarType.mediumOrLarge:
        return MD3LargeOrMediumAppBar(
          leading: leading,
          title: title,
          actions: actionWidgets,
        );
    }
  }
}
