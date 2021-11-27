import 'package:flutter/material.dart';
import 'package:material_you/material_you.dart';

abstract class MD3DeviceTypeWidget extends StatelessWidget {
  const MD3DeviceTypeWidget({Key? key}) : super(key: key);

  @protected
  Widget buildWatch(BuildContext context);
  @protected
  Widget buildMobile(BuildContext context);
  @protected
  Widget buildTablet(BuildContext context);
  @protected
  Widget buildDesktop(BuildContext context);
  @protected
  Widget buildLargeScreenTv(BuildContext context);

  @override
  Widget build(BuildContext context) {
    switch (context.deviceType) {
      case MD3DeviceType.watch:
        return buildWatch(context);
      case MD3DeviceType.mobile:
        return buildMobile(context);
      case MD3DeviceType.tablet:
        return buildTablet(context);
      case MD3DeviceType.desktop:
        return buildDesktop(context);
      case MD3DeviceType.largeScreenTv:
        return buildLargeScreenTv(context);
    }
  }
}

class MD3DeviceTypeBuilder extends MD3DeviceTypeWidget {
  const MD3DeviceTypeBuilder({
    Key? key,
    required WidgetBuilder watch,
    required WidgetBuilder mobile,
    required WidgetBuilder tablet,
    required WidgetBuilder desktop,
    required WidgetBuilder largeScreenTv,
  })  : _watch = watch,
        _mobile = mobile,
        _tablet = tablet,
        _desktop = desktop,
        _largeScreenTv = largeScreenTv,
        super(key: key);

  final WidgetBuilder _watch;
  final WidgetBuilder _mobile;
  final WidgetBuilder _tablet;
  final WidgetBuilder _desktop;
  final WidgetBuilder _largeScreenTv;

  @override
  Widget buildWatch(BuildContext context) => _watch(context);

  @override
  Widget buildMobile(BuildContext context) => _mobile(context);

  @override
  Widget buildTablet(BuildContext context) => _tablet(context);

  @override
  Widget buildDesktop(BuildContext context) => _desktop(context);

  @override
  Widget buildLargeScreenTv(BuildContext context) => _largeScreenTv(context);
}

abstract class MD3SizeClassWidget extends StatelessWidget {
  const MD3SizeClassWidget({Key? key}) : super(key: key);

  @protected
  Widget buildCompact(BuildContext context);
  @protected
  Widget buildMedium(BuildContext context);
  @protected
  Widget buildExpanded(BuildContext context);

  @override
  Widget build(BuildContext context) {
    switch (context.sizeClass) {
      case MD3WindowSizeClass.compact:
        return buildCompact(context);
      case MD3WindowSizeClass.medium:
        return buildMedium(context);
      case MD3WindowSizeClass.expanded:
        return buildExpanded(context);
    }
  }
}

class MD3SizeClassBuilder extends MD3SizeClassWidget {
  const MD3SizeClassBuilder({
    Key? key,
    required WidgetBuilder compact,
    required WidgetBuilder medium,
    required WidgetBuilder expanded,
  })  : _compact = compact,
        _medium = medium,
        _expanded = expanded,
        super(key: key);

  final WidgetBuilder _compact;
  final WidgetBuilder _medium;
  final WidgetBuilder _expanded;

  @override
  Widget buildCompact(BuildContext context) => _compact(context);

  @override
  Widget buildMedium(BuildContext context) => _medium(context);

  @override
  Widget buildExpanded(BuildContext context) => _expanded(context);
}
