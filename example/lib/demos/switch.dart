import 'package:example/common/layout.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

class SwitchDemo extends StatefulWidget {
  const SwitchDemo({Key? key}) : super(key: key);

  @override
  _SwitchDemoState createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<SwitchDemo> {
  bool value = false;
  bool enabled = true;

  void _setValue(bool v) => setState(() => value = v);

  ValueChanged<bool>? get setValue => enabled ? _setValue : null;

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(title: Text('Switch')),
      body: ListView(
        children: [
          margin,
          Text('Interactive', style: title),
          gutter,
          MD3Switch(value: value, onChanged: setValue),
          margin,
          Text('Enabled (on)', style: title),
          gutter,
          MD3Switch(value: true, onChanged: (_) {}),
          margin,
          Text('Enabled (off)', style: title),
          gutter,
          MD3Switch(value: false, onChanged: (_) {}),
          margin,
          Text('Disabled (on)', style: title),
          gutter,
          MD3Switch(value: true, onChanged: null),
          margin,
          Text('Disabled (off)', style: title),
          gutter,
          MD3Switch(value: false, onChanged: null),
          margin,
        ],
      ),
    );
  }
}
