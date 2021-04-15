import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'material_breakpoint.dart';
import 'material_layout_data.dart';
import 'material_layout_visualizer.dart';

class _InheritedMaterialLayout extends InheritedWidget with Diagnosticable {
  final MaterialLayoutData data;

  _InheritedMaterialLayout({this.data, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedMaterialLayout oldWidget) =>
      data != oldWidget.data;
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MaterialLayoutData>('data', data));
  }
}

/// An material layout that will have columns, margins and gutters, as defined
/// in http://material.io
abstract class MaterialLayout extends StatelessWidget {
  final bool debugEnableVisualization;
  final Widget child;
  final List<MaterialBreakpoint> allowedBreakpoints;

  const MaterialLayout(
      {Key key,
      @required this.debugEnableVisualization,
      @required this.child,
      List<MaterialBreakpoint> allowedBreakpoints})
      : allowedBreakpoints = allowedBreakpoints ?? MaterialBreakpoint.values,
        super(key: key);

  factory MaterialLayout.removeMargin(
      {@required BuildContext context,
      @required Widget child,
      double remaining = 0,
      bool debugEnableVisualization = false}) {
    return MaterialLayoutWithData(
        data: MaterialLayout.of(context)?.removeMargin(remaining),
        child: child,
        debugEnableVisualization: debugEnableVisualization);
  }

  bool get _enableVisualization {
    return kDebugMode && debugEnableVisualization;
  }

  static MaterialLayoutData of(BuildContext context) {
    final layout =
        context.dependOnInheritedWidgetOfExactType<_InheritedMaterialLayout>();
    return layout?.data;
  }

  MaterialLayoutData buildLayoutData(
      BuildContext context, BoxConstraints constraints);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final layoutData = buildLayoutData(context, constraints);
      var child = this.child;
      if (_enableVisualization) {
        child = MaterialLayoutPaper(
          child: child,
          data: layoutData,
        );
      }
      return _InheritedMaterialLayout(data: layoutData, child: child);
    });
  }
}

double _columnSize(
    double width, int columnCount, double gutter, double margin) {
  var size = width;
  size -= (columnCount - 1) * gutter;
  size -= 2 * margin;
  return size / columnCount;
}

class MaterialLayoutWithData extends MaterialLayout {
  final MaterialLayoutData data;

  MaterialLayoutWithData(
      {Key key,
      @required Widget child,
      bool debugEnableVisualization = false,
      this.data})
      : super(
            key: key,
            child: child,
            debugEnableVisualization: debugEnableVisualization);

  @override
  MaterialLayoutData buildLayoutData(
          BuildContext context, BoxConstraints constraints) =>
      data;
}

class FixedGridMaterialLayout extends MaterialLayout {
  final double gutter;

  FixedGridMaterialLayout(
      {Key key,
      @required Widget child,
      bool debugEnableVisualization = false,
      this.gutter,
      List<MaterialBreakpoint> allowedBreakpoints})
      : super(
            key: key,
            child: child,
            debugEnableVisualization: debugEnableVisualization,
            allowedBreakpoints: allowedBreakpoints);

  @override
  MaterialLayoutData buildLayoutData(
      BuildContext context, BoxConstraints constraints) {
    final breakpoint =
        MaterialBreakpoint.fromWidth(constraints.maxWidth, allowedBreakpoints);
    var columnCount = breakpoint.columns;
    if (breakpoint.columns < columnCount) {
      columnCount = breakpoint.columns;
    }
    final gutter = this.gutter ?? breakpoint.marginsAndGutters;
    final fakeWidth =
        breakpoint.min == 0 ? constraints.maxWidth : breakpoint.min;
    final columnSize = _columnSize(fakeWidth, columnCount, gutter, gutter);
    var marginSize = constraints.maxWidth;
    marginSize -= columnCount * columnSize;
    marginSize -= gutter * (columnCount - 1);
    marginSize /= 2;
    return MaterialLayoutData(
        margin: marginSize, gutter: gutter, breakpoint: breakpoint);
  }
}

class FluidGridMaterialLayout extends MaterialLayout {
  final double gutter;
  final double margin;

  FluidGridMaterialLayout(
      {Key key,
      @required Widget child,
      bool debugEnableVisualization = false,
      this.gutter,
      this.margin,
      List<MaterialBreakpoint> allowedBreakpoints})
      : super(
            key: key,
            child: child,
            debugEnableVisualization: debugEnableVisualization,
            allowedBreakpoints: allowedBreakpoints);
  @override
  MaterialLayoutData buildLayoutData(
      BuildContext context, BoxConstraints constraints) {
    final breakpoint =
        MaterialBreakpoint.fromWidth(constraints.maxWidth, allowedBreakpoints);
    final gutter = this.gutter ?? breakpoint.marginsAndGutters;
    final margin = this.margin ?? gutter;
    return MaterialLayoutData(
        margin: margin, gutter: gutter, breakpoint: breakpoint);
  }
}

class FluidUntilMaterialLayout extends MaterialLayout {
  final double gutter;
  final double margin;
  final MaterialBreakpoint lastFluidBreakpoint;

  FluidUntilMaterialLayout(
      {Key key,
      @required Widget child,
      bool debugEnableVisualization = false,
      this.gutter,
      this.margin,
      this.lastFluidBreakpoint = MaterialBreakpoint.nine,
      List<MaterialBreakpoint> allowedBreakpoints})
      : super(
            key: key,
            child: child,
            debugEnableVisualization: debugEnableVisualization,
            allowedBreakpoints: allowedBreakpoints);
  @override
  MaterialLayoutData buildLayoutData(
      BuildContext context, BoxConstraints constraints) {
    final fluid = FluidGridMaterialLayout(
      gutter: gutter,
      margin: margin,
      debugEnableVisualization: null,
      allowedBreakpoints: allowedBreakpoints,
      child: null,
    );

    final fixed = FixedGridMaterialLayout(
      gutter: gutter,
      debugEnableVisualization: null,
      allowedBreakpoints: allowedBreakpoints,
      child: null,
    );

    final width = constraints.maxWidth;

    final lastBreakpoint = allowedBreakpoints.last;

    /// we will reuse the constraints. TODO hacky
    if (width >= lastFluidBreakpoint.max || width >= lastBreakpoint.max) {
      return fixed.buildLayoutData(context, constraints);
    }
    return fluid.buildLayoutData(context, constraints);
  }
}
