import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:animations/animations.dart';

import 'switcher.dart';

class TextCard extends StatelessWidget {
  const TextCard({
    Key? key,
    this.title,
    this.subtitle,
    this.content,
    this.bottom,
    this.scrollable = true,
    this.onPressed,
    this.onLongPress,
  }) : super(key: key);
  final Widget? title;
  final Widget? subtitle;
  final Widget? bottom;
  final Widget? content;
  final bool scrollable;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  Widget _content(BuildContext context) => content != null
      ? DefaultTextStyle(
          style: context.textTheme.bodyMedium.copyWith(
            color: DefaultTextStyle.of(context).style.color!.withOpacity(0.6),
          ),
          child: content!,
        )
      : SizedBox();

  Widget _subtitle(BuildContext context) => DefaultTextStyle(
        style: context.textTheme.bodySmall.copyWith(
          color: DefaultTextStyle.of(context).style.color!.withOpacity(0.8),
        ),
        child: subtitle!,
      );
  Widget _title(BuildContext context) => DefaultTextStyle(
        style: context.textTheme.titleMedium.copyWith(
          color: DefaultTextStyle.of(context).style.color,
        ),
        child: title!,
      );

  @override
  Widget build(BuildContext context) => OutlinedCard(
        onPressed: onPressed,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (scrollable) ...[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (title != null) _title(context),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          _subtitle(context),
                        ],
                        const SizedBox(height: 16),
                        _content(context),
                      ],
                    ),
                  ),
                )
              ] else ...[
                if (title != null) _title(context),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  _subtitle(context),
                ],
                const SizedBox(height: 16),
                Expanded(child: _content(context)),
              ],
              if (bottom != null) ...[
                const SizedBox(height: 8),
                bottom!,
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    this.image,
    this.bottom,
    this.onPressed,
    this.onLongPress,
    this.outlined = true,
  }) : super(key: key);
  final Widget? image;
  final Widget? bottom;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool outlined;
  @override
  Widget build(BuildContext context) {
    final style = CardStyle(
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      clipBehavior: Clip.antiAlias,
    );
    final child = Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: image,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: bottom,
          ),
        )
      ],
    );

    if (outlined) {
      return OutlinedCard(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: style,
        child: child,
      );
    }
    return FilledCard(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      child: child,
    );
  }
}

class OutlinedSquaredCard extends StatelessWidget {
  const OutlinedSquaredCard({
    Key? key,
    this.color,
    this.content,
    this.title,
    this.subtitle,
    this.onPressed,
    this.onLongPressed,
  }) : super(key: key);
  final CustomColorScheme? color;
  final Widget? content;
  final Widget? title;
  final Widget? subtitle;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;

  Widget _wrapContent(BuildContext context, Widget child) => IconTheme.merge(
        data: IconThemeData(
          color: color?.onColorContainer,
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final background = color?.colorContainer;
    final foreground = color?.onColorContainer;
    final titleStyle = context.textTheme.titleSmall.copyWith(
      color: foreground,
    );
    final subtitleGeometryStyle = context.textTheme.bodySmall;
    var contentBottomPadding = 16.0;
    contentBottomPadding += titleStyle.height! * titleStyle.fontSize!;
    if (subtitle != null) {
      contentBottomPadding +=
          subtitleGeometryStyle.height! * subtitleGeometryStyle.fontSize!;
    }
    contentBottomPadding += 8;
    return OutlinedCard(
      onPressed: onPressed,
      onLongPress: onLongPressed,
      style: CardStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      child: Ink(
        color: background ?? Colors.transparent,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: contentBottomPadding),
              child: SizedBox.expand(
                child: _wrapContent(context, content ?? const SizedBox()),
              ),
            ),
            Positioned(
              bottom: 16,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      DefaultTextStyle(style: titleStyle, child: title!),
                    if (title != null && subtitle != null)
                      const SizedBox(height: 2),
                    if (subtitle != null)
                      DefaultTextStyle(
                        style: subtitleGeometryStyle.copyWith(
                          color: foreground ??
                              DefaultTextStyle.of(context).style.color,
                        ),
                        child: subtitle!,
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  const CardContainer({Key? key, this.child, this.bottomHeight})
      : super(key: key);
  final Widget? child;
  final double? bottomHeight;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = width + bottomHeight!;
          return SizedBox(
            height: height,
            width: width,
            child: child,
          );
        },
      );
}

typedef FlippableWidgetBuilder = Widget Function(BuildContext, VoidCallback);

class FlippableCard extends StatefulWidget {
  const FlippableCard({
    Key? key,
    this.bottomHeight,
    this.back,
    this.front,
  }) : super(key: key);
  final FlippableWidgetBuilder? back;
  final FlippableWidgetBuilder? front;
  final double? bottomHeight;

  @override
  _FlippableCardState createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard> {
  bool _isFlipped = false;
  void flip() => setState(() => _isFlipped = !_isFlipped);
  @override
  Widget build(BuildContext context) => CardContainer(
        bottomHeight: widget.bottomHeight,
        child: SharedAxisSwitcher(
          type: SharedAxisTransitionType.scaled,
          child: _isFlipped
              ? SizedBox.expand(
                  key: ObjectKey(true),
                  child: widget.back!(context, flip),
                )
              : SizedBox.expand(
                  key: ObjectKey(false),
                  child: widget.front!(context, flip),
                ),
        ),
      );
}
