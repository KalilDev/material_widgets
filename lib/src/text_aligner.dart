import 'dart:math';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class _TextAlignPainter extends CustomPainter {
  final TextStyle titleStyle;
  final String title;
  final double titleBodyBaselineDistance;
  final List<String> body;
  final double bodyBaselineHeight;
  final TextStyle bodyStyle;
  final TextDirection textDirection;
  final TextAlign titleAlign;
  final TextAlign bodyAlign;
  final bool showBaselines;
  final _metricsCache = <String, List<ui.LineMetrics>>{};

  _TextAlignPainter({
    @required this.titleStyle,
    @required this.title,
    @required this.titleBodyBaselineDistance,
    @required this.body,
    @required this.bodyBaselineHeight,
    @required this.bodyStyle,
    @required this.textDirection,
    @required this.titleAlign,
    @required this.bodyAlign,
    @required this.showBaselines,
  });

  Size layoutSize(BoxConstraints constraints) {
    final titlePainter = _painter(
      title,
      isTitle: true,
    );
    final titleMetrics = _layoutAndMetrics(
      title,
      titlePainter,
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
    );
    var width = titlePainter.width;
    var height = titleMetrics.last.height;

    // In case the title is null, we will line the text baseline with where the
    // title baseline would be, instead of spacing it
    final baselineOffset = title == null ? 0.0 : titleBodyBaselineDistance;
    final drawOnBaseline = title != null;

    final bodyStartBaseline = titleMetrics.last.baseline + baselineOffset;

    void layoutBodyPart(String text, double baselineOffset) {
      final painter = _painter(text);
      final metrics = _layoutAndMetrics(
        text,
        painter,
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
      );
      var startHeight = baselineOffset;
      if (drawOnBaseline) {
        startHeight -= metrics.last.baseline;
      }
      final totalHeight = startHeight + metrics.last.height;
      height = height < totalHeight ? totalHeight : height;
      width = width < painter.width ? painter.width : width;
    }

    for (var i = 0; i < body.length; i++) {
      final heightOffset = bodyBaselineHeight * i;
      layoutBodyPart(body[i], bodyStartBaseline + heightOffset);
    }
    return Size(width, height);
  }

  TextPainter _painter(String text, {bool isTitle = false}) => TextPainter(
        text: TextSpan(
          text: text,
          style: isTitle ? titleStyle : bodyStyle,
        ),
        textAlign: isTitle ? titleAlign : bodyAlign,
        textDirection: textDirection,
      );

  List<ui.LineMetrics> _layoutAndMetrics(
    String key,
    TextPainter painter, {
    double minWidth = 0.0,
    double maxWidth = double.infinity,
  }) {
    painter.layout(
      minWidth: minWidth,
      maxWidth: maxWidth,
    );
    final metrics =
        _metricsCache.putIfAbsent(key, () => painter.computeLineMetrics());
    return metrics;
  }

  @override
  void paint(Canvas canvas, Size size) {
    void alignedPaint(TextPainter painter, Offset start) {
      if (painter.width >= size.width) {
        return painter.paint(canvas, start);
      }
      var align = painter.textAlign;
      if (align == TextAlign.start || align == TextAlign.end) {
        final isStart = align == TextAlign.start;
        switch (painter.textDirection) {
          case TextDirection.rtl:
            align = isStart ? TextAlign.right : TextAlign.left;
            break;
          case TextDirection.ltr:
            align = isStart ? TextAlign.left : TextAlign.right;
            break;
        }
      }
      switch (align) {
        case TextAlign.right:
          start = start.translate(size.width - painter.width, 0);
          break;
        case TextAlign.center:
          start = start.translate((size.width - painter.width) / 2, 0);
          break;
        default:
      }
      return painter.paint(canvas, start);
    }

    // Returns the offset of the baseline.
    // if start is null, it will be Offset.zero, otherwise it will be the
    // previous baseline
    Offset paintTitle(TextPainter painter) {
      final metrics = _layoutAndMetrics(title, painter, maxWidth: size.width);
      alignedPaint(painter, Offset.zero);
      return Offset(0, metrics.last.baseline);
    }

    void drawBaselines(Offset start, Offset end) {
      if (!showBaselines) {
        return;
      }
      final c = Color(Random().nextInt(0xffffff) | 0xff000000);
      final p = Paint()..color = c;
      canvas.drawLine(start, start.translate(size.width, 0), p);
      canvas.drawLine(end, end.translate(size.width, 0), p);
      canvas.drawLine(start, end, p);
      final tp = _painter((start - end).dy.toStringAsFixed(2));
      tp.layout(maxWidth: size.width);
      tp.paint(canvas, start);
    }

    void paintBodyPart(
      String text,
      Offset startOffset, {
      Offset previousStart,
      bool drawOnBaseline,
    }) {
      final painter = _painter(text);
      final metrics = _layoutAndMetrics(text, painter, maxWidth: size.width);

      // By subtracting the baseline, we can align the baseline with the start,
      // if wanted
      final baselineOffset = drawOnBaseline ? metrics.last.baseline : 0.0;

      final start = startOffset.translate(0, -baselineOffset);

      alignedPaint(painter, start);
      if (previousStart != null) {
        drawBaselines(
          startOffset.translate(0, -baselineOffset),
          previousStart.translate(0, -baselineOffset),
        );
      }
    }

    final titlePainter = _painter(
      title ?? '',
      isTitle: true,
    );
    final titleBaseline = paintTitle(titlePainter);

    // In case the title is null, we will line the text baseline with where the
    // title baseline would be, instead of spacing it. We also draw on the start
    // instead of the baseline
    final baselineOffset = title == null ? 0.0 : titleBodyBaselineDistance;
    final drawOnBaseline = title != null;

    final bodyStartBaseline = titleBaseline.translate(0, baselineOffset);
    drawBaselines(titleBaseline, bodyStartBaseline);
    for (var i = 0; i < body.length; i++) {
      final heightOffset = bodyBaselineHeight * i;
      final start = bodyStartBaseline.translate(0, heightOffset);
      final previous = i == 0 ? null : start.translate(0, -bodyBaselineHeight);
      paintBodyPart(
        body[i],
        start,
        previousStart: previous,
        drawOnBaseline: drawOnBaseline,
      );
    }
  }

  static const _bodyEquality = ListEquality<String>();

  @override
  bool shouldRepaint(_TextAlignPainter old) => !(titleStyle == old.titleStyle &&
      title == old.title &&
      titleBodyBaselineDistance == old.titleBodyBaselineDistance &&
      _bodyEquality.equals(body, old.body) &&
      bodyBaselineHeight == old.bodyBaselineHeight &&
      bodyStyle == old.bodyStyle &&
      textDirection == old.textDirection &&
      titleAlign == old.titleAlign &&
      bodyAlign == old.bodyAlign &&
      showBaselines == old.showBaselines);
}

/// Aligns the body and title baselines.
///
/// TITLE
/// ___________________________ -> title baseline
///                            |
/// body[0]                    |  -> [titleBodyBaselineDistance]
/// ___________________________ -> body[0] baseline
///                            |
/// body[1]                    |  -> [bodyBaselineHeight]
/// ___________________________ -> body[1] baseline
class TextAligner extends StatelessWidget {
  final TextStyle titleStyle;
  final String title;
  final double titleBodyBaselineDistance;
  final List<String> body;
  final double bodyBaselineHeight;
  final TextStyle bodyStyle;
  final TextAlign titleAlign;
  final TextAlign bodyAlign;

  TextAligner({
    Key key,
    this.titleStyle,
    @required this.title,
    this.titleBodyBaselineDistance = 32.0,
    @required this.body,
    this.bodyBaselineHeight = 24.0,
    this.bodyStyle,
    this.titleAlign,
    this.bodyAlign,
  })  : assert(body.isNotEmpty),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    final defaultAlign =
        DefaultTextStyle.of(context)?.textAlign ?? TextAlign.start;

    final painter = _TextAlignPainter(
      titleStyle: titleStyle ?? Theme.of(context).textTheme.headline6,
      title: title,
      titleBodyBaselineDistance: titleBodyBaselineDistance,
      body: body,
      bodyBaselineHeight: bodyBaselineHeight,
      bodyStyle: bodyStyle ?? Theme.of(context).textTheme.caption,
      textDirection: Directionality.of(context),
      titleAlign: titleAlign ?? defaultAlign,
      bodyAlign: bodyAlign ?? defaultAlign,
      showBaselines: false,
    );
    return LayoutBuilder(
      builder: (_, constraints) => CustomPaint(
        painter: painter,
        child: SizedBox.fromSize(
          size: painter.layoutSize(constraints),
        ),
      ),
    );
  }
}
