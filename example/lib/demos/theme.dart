import 'package:example/common/layout.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';

class ThemeDemo extends StatelessWidget {
  const ThemeDemo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    final theme = context.monetTheme;
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(
        title: Text('Color System'),
      ),
      body: ListView(
        children: [
          margin,
          Text('Primary', style: title),
          gutter,
          TonalColorWidget(color: theme.primary),
          gutter,
          Text('Secondary', style: title),
          gutter,
          TonalColorWidget(color: theme.secondary),
          gutter,
          Text('Tertiary', style: title),
          gutter,
          TonalColorWidget(color: theme.tertiary),
          gutter,
          Text('Error', style: title),
          gutter,
          TonalColorWidget(color: theme.error),
          gutter,
          Text('Neutral', style: title),
          gutter,
          TonalColorWidget(color: theme.neutral),
          gutter,
          Text('Neutral Variant', style: title),
          gutter,
          TonalColorWidget(color: theme.neutralVariant),
          margin,
          Text('Light color scheme', style: title),
          gutter,
          MonetColorSchemeWidget(scheme: theme.light),
          margin,
          Text('Dark color scheme', style: title),
          gutter,
          MonetColorSchemeWidget(scheme: theme.dark),
          margin
        ],
      ),
    );
  }
}

class TonalColorWidget extends StatelessWidget {
  const TonalColorWidget({Key key, @required this.color}) : super(key: key);
  final ColorTonalPalette color;

  static const kTones = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 100];

  Widget _labels(BuildContext context) => Row(
        children: kTones
            .map((e) => Text(
                  e.toString(),
                  style: context.textTheme.labelMedium,
                ))
            .map((e) => Expanded(child: e))
            .toList(),
      );

  Widget _colors() => Row(
        children: kTones
            .map((e) => AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: color.getTone(e),
                  ),
                ))
            .map((e) => Expanded(child: e))
            .toList(),
      );

  @override
  Widget build(BuildContext context) => Row(children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _colors(),
              _labels(context),
            ],
          ),
        ),
      ]);
}

class MonetColorSchemeWidget extends StatelessWidget {
  final MonetColorScheme scheme;
  const MonetColorSchemeWidget({
    Key key,
    @required this.scheme,
  }) : super(key: key);

  static const _kRadius = Radius.circular(24);
  static const _kOutlineWidth = 1.0;
  static const _kGutter = 8.0;
  static const _kInnerLeftMargin = 12.0;
  static const _kInnerTopMargin = 16.0;
  static const _kHeight = 56.0;
  static const _kHeightHeader = _kHeight * 2.5;

  BorderSide get border =>
      BorderSide(color: scheme.outline, width: _kOutlineWidth);

  Widget section(
    Widget left,
    Widget right, [
    double height = _kHeight,
  ]) =>
      SizedBox(
        height: height,
        child: Row(
          children: [
            Expanded(child: left),
            Expanded(child: right),
          ],
        ),
      );

  Widget _color(String name, Color color, Color on, [BorderRadius radius]) =>
      SizedBox.expand(
        child: Material(
          color: color,
          shape: RoundedRectangleBorder(
            side: border,
            borderRadius: radius ?? BorderRadius.zero,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: _kInnerTopMargin,
              left: _kInnerLeftMargin,
            ),
            child: Text(
              name,
              style: TextStyle(color: on),
            ),
          ),
        ),
      );
  Widget _two(
    String name,
    Color color,
    Color on, {
    BorderRadius left,
    BorderRadius right,
  }) =>
      Row(
        children: [
          Expanded(child: _color(name, color, on, left)),
          Expanded(child: _color('On $name', on, color, right))
        ],
      );

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700,
        ),
        child: Column(
          children: [
            section(
              _two(
                'Primary',
                scheme.primary,
                scheme.onPrimary,
                left: const BorderRadius.only(
                  topLeft: _kRadius,
                ),
              ),
              _two(
                'Primary Container',
                scheme.primaryContainer,
                scheme.onPrimaryContainer,
                right: const BorderRadius.only(
                  topRight: _kRadius,
                ),
              ),
              _kHeightHeader,
            ),
            SizedBox(height: _kGutter),
            section(
              _two(
                'Secondary',
                scheme.secondary,
                scheme.onSecondary,
              ),
              _two(
                'Secondary Container',
                scheme.secondaryContainer,
                scheme.onSecondaryContainer,
              ),
            ),
            SizedBox(height: _kGutter),
            section(
              _two(
                'Tertiary',
                scheme.tertiary,
                scheme.onTertiary,
              ),
              _two(
                'Tertiary Container',
                scheme.tertiaryContainer,
                scheme.onTertiaryContainer,
              ),
            ),
            SizedBox(height: _kGutter),
            section(
              _two(
                'Error',
                scheme.error,
                scheme.onError,
              ),
              _two(
                'Error Container',
                scheme.errorContainer,
                scheme.onErrorContainer,
              ),
            ),
            SizedBox(height: _kGutter),
            section(
              _two(
                'Background',
                scheme.background,
                scheme.onBackground,
              ),
              _two(
                'Surface',
                scheme.surface,
                scheme.onSurface,
              ),
            ),
            SizedBox(height: _kGutter),
            section(
              _two(
                'Surface-variant',
                scheme.surfaceVariant,
                scheme.onSurfaceVariant,
                left: const BorderRadius.only(
                  bottomLeft: _kRadius,
                ),
              ),
              _color(
                'Outline',
                scheme.outline,
                scheme.surface,
                const BorderRadius.only(
                  bottomRight: _kRadius,
                ),
              ),
            ),
          ],
        ),
      );
}
