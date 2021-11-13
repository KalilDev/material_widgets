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

class ResponsiveAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double toolbarHeight;
  final PreferredSizeWidget bottom;
  final Widget title;
  final List<ResponsiveAppbarAction> Function(BuildContext) buildActions;

  ResponsiveAppbar({
    Key key,
    this.bottom,
    this.toolbarHeight,
    this.title,
    @Deprecated('use buildActions') List<ResponsiveAppbarAction> actions,
    List<ResponsiveAppbarAction> Function(BuildContext) buildActions,
  })  : preferredSize = MD3RawAppBar.prefferedAppBarSize(
          toolbarHeight ?? 0,
          bottom.preferredSize.height,
        ),
        buildActions = actions == null ? buildActions : ((_) => actions),
        super(key: key);

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
          showMenu<_ResponsiveAppBarAction>(
              context: context, items: items.toList(), position: position);
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
    final limit = _getButtonCountForBreakpoint(data.breakpoint);
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
  Widget build(BuildContext context) {
    final layout = MaterialLayout.of(context);
    return MD3RawAppBar(
      appBarHeight: this.toolbarHeight,
      title: this.title,
      bottom: this.bottom,
      actions: _buildActions(context, layout),
    );
  }
}
