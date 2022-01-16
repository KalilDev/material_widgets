import 'package:example/common/layout.dart';
import 'package:flutter/material.dart';
import 'package:material_widgets/material_widgets.dart';

class CheckboxDemo extends StatefulWidget {
  const CheckboxDemo({Key? key}) : super(key: key);

  @override
  _CheckboxDemoState createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<CheckboxDemo> {
  bool value = false;
  bool enabled = true;

  void _setValue(bool? v) => setState(() => value = v!);

  ValueChanged<bool?>? get setValue => enabled ? _setValue : null;

  @override
  Widget build(BuildContext context) {
    final title = context.textTheme.headlineSmall;
    final scheme = context.colorScheme;
    return MD3AdaptativeScaffold(
      appBar: MD3SmallAppBar(title: Text('Checkbox')),
      body: ListView(
        children: [
          margin,
          Text('Interactive', style: title),
          gutter,
          CheckboxTheme(
            data: CheckboxThemeData(
              splashRadius: 100,
            ),
            child: Checkbox(
              value: value,
              onChanged: setValue,
            ),
          ),
          margin,
          Text('Enabled (on)', style: title),
          gutter,
          Checkbox(value: true, onChanged: (_) {}),
          margin,
          Text('Enabled (off)', style: title),
          gutter,
          Checkbox(value: false, onChanged: (_) {}),
          margin,
          Text('Disabled (on)', style: title),
          gutter,
          Checkbox(value: true, onChanged: null),
          margin,
          Text('Disabled (off)', style: title),
          gutter,
          Checkbox(value: false, onChanged: null),
          margin,
        ],
      ),
    );
  }
}
