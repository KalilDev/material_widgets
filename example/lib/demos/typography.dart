import 'package:example/common/layout.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';

class TypographyDemo extends StatefulWidget {
  const TypographyDemo({
    Key key,
  }) : super(key: key);

  @override
  State<TypographyDemo> createState() => _TypographyDemoState();
}

class _TypographyDemoState extends State<TypographyDemo> {
  int _deviceTypeI = 0;
  MD3DeviceType deviceType;
  void initState() {
    super.initState();
    deviceType =
        MD3DeviceType.values[_deviceTypeI++ % MD3DeviceType.values.length];
  }

  _toggleDeviceType() => setState(() => deviceType =
      MD3DeviceType.values[_deviceTypeI++ % MD3DeviceType.values.length]);

  @override
  Widget build(BuildContext context) {
    final tt = baselineMD3Typography.resolveTo(deviceType);
    return MD3AdaptativeScaffold(
      appBar: MD3CenterAlignedAppBar(
        title: Text('Typography'),
      ),
      floatingActionButton: MD3FloatingActionButton.expanded(
        onPressed: _toggleDeviceType,
        icon: Icon(Icons.devices),
        label: Text('Change Device'),
      ),
      body: ListView(
        children: [
          margin,
          Text(
            'Device type: $deviceType',
            style: context.textTheme.headlineSmall,
          ),
          margin,
          Text('Display Large', style: tt.displayLarge),
          gutter,
          Text('Display Medium', style: tt.displayMedium),
          gutter,
          Text('Display Small', style: tt.displaySmall),
          margin,
          Text('Headline Large', style: tt.headlineLarge),
          gutter,
          Text('Headline Medium', style: tt.headlineMedium),
          gutter,
          Text('Headline Small', style: tt.headlineSmall),
          margin,
          Text('Title Large', style: tt.titleLarge),
          gutter,
          Text('Title Medium', style: tt.titleMedium),
          gutter,
          Text('Title Small', style: tt.titleSmall),
          margin,
          Text('Label Large', style: tt.labelLarge),
          gutter,
          Text('Label Medium', style: tt.labelMedium),
          gutter,
          Text('Label Small', style: tt.labelSmall),
          margin,
          Text('Body Large', style: tt.bodyLarge),
          gutter,
          Text('Body Medium', style: tt.bodyMedium),
          gutter,
          Text('Body Small', style: tt.bodySmall),
          margin,
        ],
      ),
    );
  }
}
