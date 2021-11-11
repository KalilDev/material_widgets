import 'package:flutter/material.dart';

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

abstract class ResponsiveAppbarAction {
  static _ResponsiveAppBarAction create(
          {Widget icon,
          String tooltip,
          Widget title,
          VoidCallback onPressed}) =>
      _ResponsiveAppBarAction(
          icon: icon, tooltip: tooltip, title: title, onPressed: onPressed);
  static _ResponsiveAppBarActionBuilder builder(
          _ResponsiveAppBarAction Function(BuildContext) build) =>
      _ResponsiveAppBarActionBuilder(build);
}

class _ResponsiveAppBarAction implements ResponsiveAppbarAction {
  final Widget icon;
  final String tooltip;
  final Widget title;
  final VoidCallback onPressed;

  const _ResponsiveAppBarAction(
      {this.icon, this.tooltip, this.title, this.onPressed});
}

class _ResponsiveAppBarActionBuilder implements ResponsiveAppbarAction {
  final _ResponsiveAppBarAction Function(BuildContext) build;

  const _ResponsiveAppBarActionBuilder(this.build);
}

class ResponsiveAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double toolbarHeight;
  final PreferredSizeWidget bottom;
  final Widget title;
  final List<ResponsiveAppbarAction> actions;

  ResponsiveAppbar(
      {Key key, this.bottom, this.toolbarHeight, this.title, this.actions})
      : preferredSize = Size.fromHeight(toolbarHeight ??
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  Widget _actionToActionWidget(_ResponsiveAppBarAction action) {
    return IconButton(
      icon: action.icon,
      onPressed: action.onPressed,
      tooltip: action.tooltip,
    );
  }

  Widget _actionToBottomSheetWidget(_ResponsiveAppBarAction action) {
    return ListTile(
      leading: action.icon,
      onTap: action.onPressed,
      title: action.title,
    );
  }

  PopupMenuItem<_ResponsiveAppBarAction> _actionToPopupMenuItem(
      _ResponsiveAppBarAction action) {
    return PopupMenuItem(child: action.title, value: action);
  }

  WidgetBuilder _moreButtonBuilder(
          List<_ResponsiveAppBarAction> hidden, bool isBottomSheet) =>
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
    if (this.actions == null || this.actions.isEmpty) {
      return null;
    }
    final limit = _getButtonCountForBreakpoint(data.breakpoint);
    final concreteActions = this.actions.map((e) {
      if (e is _ResponsiveAppBarAction) {
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
    return AppBar(
      toolbarHeight: toolbarHeight,
      title: title,
      bottom: bottom,
      actions: _buildActions(context, layout),
    );
  }

  @override
  final Size preferredSize;
}
