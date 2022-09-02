// ignore_for_file: avoid_multiple_declarations_per_line

import 'package:flutter/material.dart';

/// An [Slider] following the MD3 style. This is an wrapper for the [Slider]
/// widget, which automatically sets the [SliderThemeData.trackShape] to
/// [MD3SliderTrackShape], and animates it between [onChangeStart] and
/// [onChangeEnd].
class MD3Slider extends StatefulWidget {
  const MD3Slider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
  }) : super(key: key);
  final double value;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final MouseCursor? mouseCursor;
  final String Function(double)? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<MD3Slider> createState() => _MD3SliderState();
}

class _MD3SliderState extends State<MD3Slider>
    with SingleTickerProviderStateMixin {
  late AnimationController _sineController;
  late Animation<double> _sine;

  static final _kSineTween = Tween(begin: 0.0, end: 2.0);

  @override
  void initState() {
    super.initState();
    _sineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _sine = _kSineTween.animate(_sineController);
  }

  @override
  void dispose() {
    _sineController.dispose();
    super.dispose();
  }

  void _onChangeStart(double v) {
    _sineController.repeat();
    widget.onChangeStart?.call(v);
  }

  void _onChangeEnd(double v) {
    _sineController.stop();
    widget.onChangeEnd?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    return ValueListenableBuilder<double>(
      valueListenable: _sine,
      builder: (context, sineStart, _) => SliderTheme(
        data: SliderThemeData(
          trackShape: MD3SliderTrackShape(
            sineStart: isLtr ? 2 - sineStart : sineStart,
          ),
        ),
        child: Slider(
          value: widget.value,
          onChanged: widget.onChanged,
          onChangeStart: _onChangeStart,
          onChangeEnd: _onChangeEnd,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: widget.label,
          activeColor: widget.activeColor,
          inactiveColor: widget.inactiveColor,
          thumbColor: widget.thumbColor,
          mouseCursor: widget.mouseCursor,
          semanticFormatterCallback: widget.semanticFormatterCallback,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
        ),
      ),
    );
  }
}

class MD3SliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  const MD3SliderTrackShape({
    this.sineStart = 0,
  });
  final double sineStart;
  static const kActiveTrackSize = 4.8; // more like 4.8 or 5.5 but idk
  static const kActiveTrackAmplitude = 8 / 2;
  static const kInactiveTrackSize = 4.0; // more like 4.24 but idk
  static const kLambda = 24.0;
  static const kLambdaSize = Offset(kLambda, 0);

  void _paintInactiveTrack(
    Canvas canvas,
    Size size, {
    required Color color,
    required double value,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = kInactiveTrackSize
      ..style = PaintingStyle.stroke;
    const halfSize = kInactiveTrackSize / 2;
    final centerX = size.width * value;
    final centerY = size.height / 2;
    canvas.drawLine(
      Offset(centerX + halfSize, centerY),
      Offset(size.width - halfSize, centerY),
      paint,
    );
  }

  void _paintActiveTrack(
    Canvas canvas,
    Size size, {
    required Color color,
    required double value,
    required double sineStart,
  }) {
    // half the thumb size. TODO: should we do this?
    if (value * size.width <= 10.0) {
      return;
    }
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = kActiveTrackSize
      ..style = PaintingStyle.stroke;

    final startT = sineStart;
    final startOffset = size.centerLeft(Offset.zero).translate(
          -kLambda * startT / 2 + kActiveTrackSize / 2,
          kActiveTrackAmplitude / 2,
        );
    final startSine =
        _CubicPair.sine(startOffset, kLambda, kActiveTrackAmplitude)
            .cutAfter(startT);

    final path = Path();

    var offset = _Cubic.applyMany(startSine, path, Offset.zero);

    final remainingSineWidth =
        size.width * value - kActiveTrackSize / 2 - offset.dx;
    final remainingSines = remainingSineWidth / kLambda;
    for (var i = 0; i < remainingSines.ceil(); i++) {
      final sine = _CubicPair.sine(offset, kLambda, kActiveTrackAmplitude);
      offset = _CubicPair.apply(sine, path, offset);
    }

    // Needed so that we avoid handling the edge cases for the last sine
    canvas.clipRect(
      Rect.fromLTRB(
        0,
        -kActiveTrackAmplitude,
        size.width * value,
        size.height + kActiveTrackAmplitude,
      ),
    );
    canvas.drawPath(path, paint);
  }

  void _paint(
    Canvas canvas,
    Size size, {
    required Color activeTrackColor,
    required Color inactiveTrackColor,
    required double value,
    required double sineStart,
  }) {
    _paintInactiveTrack(
      canvas,
      size,
      color: inactiveTrackColor,
      value: value,
    );
    _paintActiveTrack(
      canvas,
      size,
      color: activeTrackColor,
      value: value,
      sineStart: sineStart,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = true,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final value = (thumbCenter.dx - rect.left) / rect.width;
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(rect.topLeft.dx, rect.topLeft.dy);
    _paint(
      canvas,
      rect.size,
      activeTrackColor: (isEnabled
          ? sliderTheme.activeTrackColor
          : sliderTheme.disabledActiveTrackColor)!,
      inactiveTrackColor: (isEnabled
          ? sliderTheme.inactiveTrackColor
          : sliderTheme.disabledInactiveTrackColor)!,
      value: value,
      sineStart: sineStart,
    );
    canvas.restore();
  }
}

class _Cubic {
  const _Cubic(
    this.p0,
    this.p1,
    this.p2,
    this.p3,
  );
  final Offset p0;
  final Offset p1;
  final Offset p2;
  final Offset p3;

  _CubicPair cutAt(double t) => _CubicPair(
        segmentFrom(0, t),
        segmentFrom(t, 1.0),
      );

  /// Algorithm from https://stackoverflow.com/questions/878862/drawing-part-of-a-b%c3%a9zier-curve-by-reusing-a-basic-b%c3%a9zier-curve-function/879213#879213
  _Cubic segmentFrom(double t0, double t1) {
    final x1 = p0.dx, y1 = p0.dy;
    final bx1 = p1.dx, by1 = p1.dy;
    final bx2 = p2.dx, by2 = p2.dy;
    final x2 = p3.dx, y2 = p3.dy;

    final u0 = 1.0 - t0;
    final u1 = 1.0 - t1;

    final qxa = x1 * u0 * u0 + bx1 * 2 * t0 * u0 + bx2 * t0 * t0;
    final qxb = x1 * u1 * u1 + bx1 * 2 * t1 * u1 + bx2 * t1 * t1;
    final qxc = bx1 * u0 * u0 + bx2 * 2 * t0 * u0 + x2 * t0 * t0;
    final qxd = bx1 * u1 * u1 + bx2 * 2 * t1 * u1 + x2 * t1 * t1;

    final qya = y1 * u0 * u0 + by1 * 2 * t0 * u0 + by2 * t0 * t0;
    final qyb = y1 * u1 * u1 + by1 * 2 * t1 * u1 + by2 * t1 * t1;
    final qyc = by1 * u0 * u0 + by2 * 2 * t0 * u0 + y2 * t0 * t0;
    final qyd = by1 * u1 * u1 + by2 * 2 * t1 * u1 + y2 * t1 * t1;

    final xa = qxa * u0 + qxc * t0;
    final xb = qxa * u1 + qxc * t1;
    final xc = qxb * u0 + qxd * t0;
    final xd = qxb * u1 + qxd * t1;

    final ya = qya * u0 + qyc * t0;
    final yb = qya * u1 + qyc * t1;
    final yc = qyb * u0 + qyd * t0;
    final yd = qyb * u1 + qyd * t1;

    return _Cubic(
      Offset(xa, ya),
      Offset(xb, yb),
      Offset(xc, yc),
      Offset(xd, yd),
    );
  }

  static Offset apply(_Cubic c, Path p, Offset currOffset) {
    if (currOffset != c.p0) {
      p.moveTo(c.p0.dx, c.p0.dy);
    }
    p.cubicTo(
      c.p1.dx,
      c.p1.dy,
      c.p2.dx,
      c.p2.dy,
      c.p3.dx,
      c.p3.dy,
    );
    return c.p3;
  }

  static Offset applyMany(List<_Cubic> cs, Path p, Offset start) =>
      cs.fold<Offset>(start, (offset, c) => _Cubic.apply(c, p, offset));
}

class _CubicPair {
  const _CubicPair(this.left, this.right);

  /// Aproximation of the sine curve with two cubic beziers.
  /// kappa and algorithm from https://stackoverflow.com/questions/25238465/how-to-use-css-cubic-bezier-to-implement-sine-function
  factory _CubicPair.sine(
    Offset startOffset,
    double lambda,
    double amplitude,
  ) {
    const kappa = 0.3642;
    const kappaRest = 1 - kappa;
    final halfLambda = lambda / 2;

    final startX = startOffset.dx;
    final midX = startX + halfLambda;
    final endX = startX + lambda;
    final startY = startOffset.dy;
    final endY = startY - amplitude / 2;

    final midOffset = Offset(midX, endY);
    final endOffset = Offset(endX, startY);

    return _CubicPair(
      _Cubic(
        startOffset,
        Offset(
          startX + (kappa * halfLambda),
          startY,
        ),
        Offset(
          startX + (kappaRest * halfLambda),
          endY,
        ),
        midOffset,
      ),
      _Cubic(
        midOffset,
        Offset(
          midX + (kappa * halfLambda),
          endY,
        ),
        Offset(
          midX + (kappaRest * halfLambda),
          startY,
        ),
        endOffset,
      ),
    );
  }

  final _Cubic left;
  final _Cubic right;

  static Offset apply(_CubicPair c, Path p, Offset currOffset) {
    return _Cubic.apply(
      c.right,
      p,
      _Cubic.apply(c.left, p, currOffset),
    );
  }

  List<_Cubic> cutAfter(double t) {
    if (t >= 0 && t <= 1) {
      final cut = left.cutAt(t);
      return [
        cut.right,
        right,
      ];
    } else if (t >= 1 && t <= 2) {
      final cut = right.cutAt(t - 1);
      return [
        cut.right,
      ];
    } else {
      throw ArgumentError(
        'Out of bounds value, it should follow that 0 <= t <= 2',
        't',
      );
    }
  }

  List<_Cubic> cutBefore(double t) {
    if (t >= 0 && t <= 1) {
      final cut = left.cutAt(t);
      return [
        cut.left,
      ];
    } else if (t >= 1 && t <= 2) {
      final cut = right.cutAt(t - 1);
      return [
        left,
        cut.left,
      ];
    } else {
      throw ArgumentError(
        'Out of bounds value, it should follow that 0 <= t <= 2',
        't',
      );
    }
  }

  List<_Cubic> cutAt(double t) {
    if (t >= 0 && t <= 1) {
      final cut = left.cutAt(t);
      return [
        cut.left,
        cut.right,
        right,
      ];
    } else if (t >= 1 && t <= 2) {
      final cut = right.cutAt(t - 1);
      return [
        left,
        cut.left,
        cut.right,
      ];
    } else {
      throw ArgumentError(
        'Out of bounds value, it should follow that 0 <= t <= 2',
        't',
      );
    }
  }
}
