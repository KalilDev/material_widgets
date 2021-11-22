import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';

class MD3BasicDialog extends StatelessWidget {
  const MD3BasicDialog({
    Key key,
    this.dialogAlignment = MD3TabletDialogAlignment.end,
    this.dividerAfterTitle = true,
    this.icon,
    @required this.title,
    @required this.content,
    this.extraContent,
    this.actions = const [],
  }) : super(key: key);

  final MD3TabletDialogAlignment dialogAlignment;
  final bool dividerAfterTitle;
  final Widget icon;
  final Widget title;
  final Widget content;
  final Widget extraContent;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => MD3DialogLayout(
        dialogAlignment: dialogAlignment,
        child: _MD3BasicDialog(
          dividerAfterTitle: dividerAfterTitle,
          icon: icon,
          title: title,
          content: content,
          extraContent: extraContent,
          actions: actions,
        ),
      );
}

class _MD3BasicDialog extends StatelessWidget {
  const _MD3BasicDialog({
    Key key,
    this.dividerAfterTitle = true,
    this.icon,
    @required this.title,
    @required this.content,
    this.extraContent,
    this.actions = const [],
  }) : super(key: key);

  final bool dividerAfterTitle;
  final Widget icon;
  final Widget title;
  final Widget content;
  final Widget extraContent;
  final List<Widget> actions;

  Widget _wrapContent(BuildContext context, {Widget content}) =>
      DefaultTextStyle(
        style: context.textTheme.bodyMedium.copyWith(
          color: context.colorScheme.onSurfaceVariant,
        ),
        child: content,
      );
  Widget _title(BuildContext context, [bool center = false]) =>
      DefaultTextStyle(
        style: context.textTheme.headlineSmall.copyWith(
          color: context.colorScheme.onSurface,
        ),
        textAlign: center ? TextAlign.center : TextAlign.start,
        child: title,
      );
  List<Widget> _iconAndTitle(BuildContext context) => [
        IconTheme.merge(
          data: const IconThemeData(size: 24),
          child: icon,
        ),
        const SizedBox(height: 16),
        _title(context, true),
      ];
  Widget _divider(BuildContext context, bool visible, [double height = 16]) =>
      false
          ? Divider(
              height: 16,
              thickness: 1,
              color: context.colorScheme.surfaceVariant,
              endIndent: 0,
              indent: 0,
            )
          : SizedBox(
              height: 16,
              width: 0,
            );
  Widget _actions(BuildContext context) => SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.end,
          spacing: 8.0,
          runSpacing: 8.0,
          children: actions,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(28),
      color: context.elevation.level3.overlaidColor(
        context.colorScheme.surface,
        MD3ElevationLevel.surfaceTint(context.colorScheme),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: icon != null
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (icon != null) ..._iconAndTitle(context) else _title(context),
              _divider(context, extraContent == null && dividerAfterTitle),
              _wrapContent(context, content: content),
              if (extraContent != null) ...[
                _divider(context, true),
                _wrapContent(context, content: extraContent),
                _divider(context, true, 24),
              ] else
                SizedBox(height: 8.0),
              if (actions != null) _actions(context),
            ],
          ),
        ),
      ),
    );
  }
}

enum MD3TabletDialogAlignment { start, center, end }

class MD3DialogLayout extends StatelessWidget {
  const MD3DialogLayout({
    Key key,
    this.dialogAlignment = MD3TabletDialogAlignment.start,
    this.child,
  }) : super(key: key);

  final MD3TabletDialogAlignment dialogAlignment;
  final Widget child;

  bool _isSmall(BuildContext context) =>
      context.sizeClass == MD3WindowSizeClass.compact;
  bool _isTablet(BuildContext context) =>
      context.deviceType == MD3DeviceType.tablet;

  double _marginFor(bool isSmall) => isSmall ? 48 : 56;
  double _maxHeightFor(bool isSmall) => isSmall ? double.infinity : 560;

  _AlignmentAndMaxWidth _alignmentFor(
    bool isTablet,
    double windowWidthNoMargin,
  ) {
    if (!isTablet || dialogAlignment == MD3TabletDialogAlignment.center) {
      return _AlignmentAndMaxWidth(
        min(560.0, windowWidthNoMargin),
        MD3TabletDialogAlignment.center,
      );
    }
    final maxWidth = min(560.0, windowWidthNoMargin / 2);
    return _AlignmentAndMaxWidth(maxWidth, dialogAlignment);
  }

  Widget _dialog(double maxWidth, double maxHeight) => ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 280,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: child,
      );

  Widget _aligned(MD3TabletDialogAlignment alignment, Widget child) {
    switch (alignment) {
      case MD3TabletDialogAlignment.start:
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: child),
            const Expanded(child: SizedBox()),
          ],
        );
      case MD3TabletDialogAlignment.center:
        return child;
      case MD3TabletDialogAlignment.end:
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Expanded(child: child),
          ],
        );
    }
    throw ArgumentError.notNull('dialogAlignment');
  }

  @override
  Widget build(BuildContext context) {
    final small = _isSmall(context);
    final margin = _marginFor(small);
    final maxHeight = _maxHeightFor(small);
    final alignmentAndMaxWidth = _alignmentFor(
      _isTablet(context),
      MediaQuery.of(context).size.width - 2 * margin,
    );

    return Padding(
      padding: EdgeInsets.all(margin),
      child: _aligned(
        alignmentAndMaxWidth.alignment,
        Center(
          child: _dialog(
            alignmentAndMaxWidth.maxWidth,
            maxHeight,
          ),
        ),
      ),
    );
  }
}

class _AlignmentAndMaxWidth {
  _AlignmentAndMaxWidth(this.maxWidth, this.alignment);

  final double maxWidth;
  final MD3TabletDialogAlignment alignment;
}