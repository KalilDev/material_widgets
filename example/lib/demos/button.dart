import 'package:example/common/layout.dart';
import 'package:material_widgets/material_widgets.dart';
import 'package:material_you/material_you.dart';
import 'package:flutter/material.dart';

class ButtonDemo extends StatefulWidget {
  const ButtonDemo({
    Key key,
  }) : super(key: key);

  @override
  State<ButtonDemo> createState() => _ButtonDemoState();
}

class _ButtonDemoState extends State<ButtonDemo> {
  bool _enabled = true;
  void _toggleEnabled() => setState(() => _enabled = !_enabled);
  VoidCallback get _onPressed => _enabled ? () {} : null;

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;

    return MD3AdaptativeScaffold(
      appBar: MD3CenterAlignedAppBar(
        title: Text('Button'),
      ),
      floatingActionButton: MD3FloatingActionButton.expanded(
        onPressed: _toggleEnabled,
        icon: Icon(Icons.label_off),
        label: Text('Toggle enabled'),
      ),
      body: ListView(
        children: [
          margin,
          Text('Elevated', style: title),
          gutter,
          Center(
            child: ElevatedButton(onPressed: _onPressed, child: Text('Action')),
          ),
          margin,
          Text('Filled', style: title),
          gutter,
          Center(
            child: FilledButton(onPressed: _onPressed, child: Text('Action')),
          ),
          margin,
          Text('Filled Tonal', style: title),
          gutter,
          Center(
            child:
                FilledTonalButton(onPressed: _onPressed, child: Text('Action')),
          ),
          margin,
          Text('Text', style: title),
          gutter,
          Center(
            child: TextButton(onPressed: _onPressed, child: Text('Action')),
          ),
          margin,
          Text('Outlined', style: title),
          gutter,
          Center(
            child: OutlinedButton(onPressed: _onPressed, child: Text('Action')),
          ),
          margin,
        ],
      ),
    );
  }
}
