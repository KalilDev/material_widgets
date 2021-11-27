import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

class MD3DialogDivider extends StatelessWidget {
  const MD3DialogDivider({
    Key? key,
    this.isVisible = true,
    this.height = 16.0,
  }) : super(key: key);
  final bool isVisible;
  final double height;

  @override
  Widget build(BuildContext context) => isVisible
      ? Divider(
          height: height,
          thickness: 1,
          color: context.colorScheme.surfaceVariant,
          endIndent: 0,
          indent: 0,
        )
      : SizedBox(
          height: height,
          width: 0,
        );
}

class MD3BasicDialog extends StatelessWidget {
  const MD3BasicDialog({
    Key? key,
    this.dialogAlignment = MD3TabletDialogAlignment.end,
    this.dividerAfterTitle = true,
    this.icon,
    required this.title,
    required this.content,
    this.extraContent,
    this.actions = const [],
  }) : super(key: key);

  final MD3TabletDialogAlignment dialogAlignment;
  final bool dividerAfterTitle;
  final Widget? icon;
  final Widget title;
  final Widget content;
  final Widget? extraContent;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => MD3DialogLayout(
        dialogAlignment: dialogAlignment,
        child: MD3DialogAnimation(
          child: _MD3BasicDialog(
            dividerAfterTitle: dividerAfterTitle,
            icon: icon,
            title: title,
            content: content,
            extraContent: extraContent,
            actions: actions,
          ),
        ),
      );
}

class _MD3BasicDialog extends StatelessWidget {
  const _MD3BasicDialog({
    Key? key,
    this.dividerAfterTitle = true,
    this.icon,
    required this.title,
    required this.content,
    this.extraContent,
    this.actions = const [],
  }) : super(key: key);

  final bool dividerAfterTitle;
  final Widget? icon;
  final Widget title;
  final Widget content;
  final Widget? extraContent;
  final List<Widget> actions;

  Widget _wrapContent(BuildContext context, {required Widget content}) =>
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
          child: icon!,
        ),
        const SizedBox(height: 16),
        _title(context, true),
      ];
  Widget _actions(BuildContext context) => SizedBox(
        width: double.infinity,
        child: OverflowBar(
          alignment: MainAxisAlignment.end,
          spacing: 8.0,
          overflowAlignment: OverflowBarAlignment.end,
          overflowSpacing: 8.0,
          children: actions,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
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
              MD3DialogDivider(
                isVisible: extraContent == null && dividerAfterTitle,
              ),
              _wrapContent(context, content: content),
              if (extraContent != null) ...[
                const MD3DialogDivider(),
                _wrapContent(context, content: extraContent!),
                const MD3DialogDivider(height: 24),
              ] else
                const SizedBox(height: 8.0),
              if (actions.isNotEmpty) _actions(context),
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
    Key? key,
    this.dialogAlignment = MD3TabletDialogAlignment.start,
    required this.child,
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
          children: [
            Expanded(child: child),
            const Expanded(child: SizedBox()),
          ],
        );
      case MD3TabletDialogAlignment.center:
        return child;
      case MD3TabletDialogAlignment.end:
        return Row(
          children: [
            const Expanded(child: SizedBox()),
            Expanded(child: child),
          ],
        );
    }
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

class MD3DialogAnimation extends StatefulWidget {
  const MD3DialogAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  static const Duration kDuration = Duration(milliseconds: 200);

  @override
  State<MD3DialogAnimation> createState() => _MD3DialogAnimationState();
}

class _MD3DialogAnimationState extends State<MD3DialogAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: MD3DialogAnimation.kDuration,
    );
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MD3DialogTransition(
        animation: animation,
        child: widget.child,
      );
}

class MD3DialogTransition extends StatelessWidget {
  const MD3DialogTransition({
    Key? key,
    required this.child,
    required this.animation,
  }) : super(key: key);
  final Widget child;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: animation!,
        child: ScaleTransition(
          scale: Tween(begin: 0.8, end: 1.0).animate(animation!),
          child: child,
        ),
      );
}

class _AlignmentAndMaxWidth {
  _AlignmentAndMaxWidth(this.maxWidth, this.alignment);

  final double maxWidth;
  final MD3TabletDialogAlignment alignment;
}
