import 'package:example/common/layout.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

class SliderDemo extends StatefulWidget {
  const SliderDemo({Key? key}) : super(key: key);

  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  double value = 0.5;
  bool enabled = true;

  void _setValue(double v) => setState(() => value = v);
  void _toggleEnabled() => setState(() => enabled = !enabled);

  ValueChanged<double>? get setValue => enabled ? _setValue : null;

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    return MD3AdaptativeScaffold(
      floatingActionButton: MD3FloatingActionButton.expanded(
        onPressed: _toggleEnabled,
        label: Text('Toggle enabled'),
        icon: Icon(Icons.label_off),
      ),
      body: ListView(
        children: [
          margin,
          Text('Large', style: title),
          gutter,
          MD3Slider(value: value, onChanged: setValue),
          margin,
          Text('Constrained', style: title),
          gutter,
          Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: MD3Slider(value: value, onChanged: setValue),
            ),
          ),
          margin,
          Text('Discrete', style: title),
          gutter,
          MD3Slider(
            value: value,
            onChanged: setValue,
            divisions: 10,
          ),
          margin,
        ],
      ),
    );
  }
}
