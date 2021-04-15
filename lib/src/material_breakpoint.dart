import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

enum DeviceType {
  smallHandset,
  mediumHandset,
  largeHandset,
  smallTablet,
  largeTablet,
  undefined
}

enum WindowSize { xsmall, small, medium, large, xlarge }

class MaterialBreakpoint with Diagnosticable {
  const MaterialBreakpoint._(
      {@required this.min,
      @required this.max,
      @required this.portraitDeviceType,
      @required this.landscapeDeviceType,
      @required this.windowSize,
      @required this.columns,
      @required this.marginsAndGutters});

  factory MaterialBreakpoint.fromWidth(double width,
      [List<MaterialBreakpoint> allowedBreakpoints]) {
    allowedBreakpoints ??= MaterialBreakpoint.values;
    final mins = allowedBreakpoints.map((e) => e.min).toList();

    MaterialBreakpoint fromMin(double min) =>
        allowedBreakpoints.singleWhere((e) => e.min == min);

    if (mins.contains(width)) {
      return fromMin(width);
    }

    final minsAndWidth = mins.toList()
      ..add(width)
      ..sort();
    var widthIndex = minsAndWidth.indexOf(width);
    if (widthIndex != 0) {
      widthIndex--;
    }
    final min = mins[widthIndex];
    return fromMin(min);
  }

  /// Inclusive
  final double min;

  /// Exclusive
  final double max;

  /// Undefined after 960.0dp
  final DeviceType portraitDeviceType;

  /// Undefined before 480.0dp and after 960.0dp
  final DeviceType landscapeDeviceType;

  final WindowSize windowSize;

  final int columns;

  final double marginsAndGutters;

  static const MaterialBreakpoint one = MaterialBreakpoint._(
      min: 0,
      max: 360,
      portraitDeviceType: DeviceType.smallHandset,
      landscapeDeviceType: DeviceType.undefined,
      windowSize: WindowSize.xsmall,
      columns: 4,
      marginsAndGutters: 16);
  static const MaterialBreakpoint two = MaterialBreakpoint._(
      min: 360,
      max: 400,
      portraitDeviceType: DeviceType.mediumHandset,
      landscapeDeviceType: DeviceType.undefined,
      windowSize: WindowSize.xsmall,
      columns: 4,
      marginsAndGutters: 16);
  static const MaterialBreakpoint three = MaterialBreakpoint._(
      min: 400,
      max: 480,
      portraitDeviceType: DeviceType.largeHandset,
      landscapeDeviceType: DeviceType.undefined,
      windowSize: WindowSize.xsmall,
      columns: 4,
      marginsAndGutters: 16);
  static const MaterialBreakpoint four = MaterialBreakpoint._(
      min: 480,
      max: 600,
      portraitDeviceType: DeviceType.largeHandset,
      landscapeDeviceType: DeviceType.smallHandset,
      windowSize: WindowSize.xsmall,
      columns: 4,
      marginsAndGutters: 16);
  static const MaterialBreakpoint five = MaterialBreakpoint._(
      min: 600,
      max: 720,
      portraitDeviceType: DeviceType.smallTablet,
      landscapeDeviceType: DeviceType.mediumHandset,
      windowSize: WindowSize.small,
      columns: 8,
      marginsAndGutters: 16);
  static const MaterialBreakpoint six = MaterialBreakpoint._(
      min: 720,
      max: 840,
      portraitDeviceType: DeviceType.largeTablet,
      landscapeDeviceType: DeviceType.largeHandset,
      windowSize: WindowSize.small,
      columns: 8,
      marginsAndGutters: 24);
  static const MaterialBreakpoint seven = MaterialBreakpoint._(
      min: 840,
      max: 960,
      portraitDeviceType: DeviceType.largeTablet,
      landscapeDeviceType: DeviceType.largeHandset,
      windowSize: WindowSize.small,
      columns: 12,
      marginsAndGutters: 24);
  static const MaterialBreakpoint eight = MaterialBreakpoint._(
      min: 960,
      max: 1024,
      portraitDeviceType: DeviceType.undefined,
      landscapeDeviceType: DeviceType.smallTablet,
      windowSize: WindowSize.small,
      columns: 12,
      marginsAndGutters: 24);
  static const MaterialBreakpoint nine = MaterialBreakpoint._(
      min: 1024,
      max: 1280,
      portraitDeviceType: DeviceType.undefined,
      landscapeDeviceType: DeviceType.largeTablet,
      windowSize: WindowSize.medium,
      columns: 12,
      marginsAndGutters: 24);
  static const MaterialBreakpoint ten = MaterialBreakpoint._(
      min: 1280,
      max: 1440,
      portraitDeviceType: DeviceType.undefined,
      landscapeDeviceType: DeviceType.largeTablet,
      windowSize: WindowSize.medium,
      columns: 12,
      marginsAndGutters: 24);
  static const MaterialBreakpoint eleven = MaterialBreakpoint._(
      min: 1440,
      max: 1600,
      portraitDeviceType: DeviceType.undefined,
      landscapeDeviceType: DeviceType.undefined,
      windowSize: WindowSize.large,
      columns: 12,
      marginsAndGutters: 24);
  static const MaterialBreakpoint twelve = MaterialBreakpoint._(
      min: 1600,
      max: 1920,
      portraitDeviceType: DeviceType.undefined,
      landscapeDeviceType: DeviceType.undefined,
      windowSize: WindowSize.large,
      columns: 12,
      marginsAndGutters: 24);
  static const MaterialBreakpoint thirteen = MaterialBreakpoint._(
      min: 1920,
      max: double.infinity,
      portraitDeviceType: DeviceType.undefined,
      landscapeDeviceType: DeviceType.undefined,
      windowSize: WindowSize.xlarge,
      columns: 12,
      marginsAndGutters: 24);

  static const List<MaterialBreakpoint> values = [
    one,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    ten,
    eleven,
    twelve,
    thirteen
  ];

  bool operator >(MaterialBreakpoint other) => min > other.min;
  bool operator <(MaterialBreakpoint other) => min < other.min;

  bool operator >=(MaterialBreakpoint other) => this == other || this > other;
  bool operator <=(MaterialBreakpoint other) => this == other || this < other;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('min', min));
    properties.add(DoubleProperty('max', max));
    properties.add(
        EnumProperty<DeviceType>('portraitDeviceType', portraitDeviceType));
    properties.add(
        EnumProperty<DeviceType>('landscapeDeviceType', landscapeDeviceType));
    properties.add(EnumProperty<WindowSize>('windowSize', windowSize));
    properties.add(IntProperty('columns', columns));
    properties.add(DoubleProperty('marginsAndGutters', marginsAndGutters));
  }
}
